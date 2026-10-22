from datetime import datetime
from flask import Blueprint, render_template, redirect, url_for, flash, request, send_file
from app.extensions import mysql
from app.utils.decorators import admin_required
from io import BytesIO
from datetime import datetime
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle

admin_bp = Blueprint(
    "admin",
    __name__,
    url_prefix="/admin"
)

@admin_bp.route("/generate-student-id", methods=["POST"])
@admin_required
def generate_student_id():
    cur = mysql.connection.cursor()

    try:
        cur.execute("""
            SELECT student_id
            FROM student_id_codes
            WHERE student_id LIKE 'STU%'
            ORDER BY id DESC
            LIMIT 1
        """)

        row = cur.fetchone()
        next_number = 1

        if row and row.get("student_id"):
            import re
            match = re.search(r"STU(\d+)$", row["student_id"])

            if match:
                next_number = int(match.group(1)) + 1

        while True:
            student_id = f"STU{next_number:04d}"

            cur.execute(
                "SELECT id FROM student_id_codes WHERE student_id=%s",
                (student_id,)
            )

            if not cur.fetchone():
                break

            next_number += 1

        cur.execute("""
            INSERT INTO student_id_codes (student_id, is_used)
            VALUES (%s, 0)
        """, (student_id,))

        mysql.connection.commit()

        flash(
            f"Student ID generated: {student_id}. Give this ID to the student.",
            "success"
        )

    except Exception as e:
        mysql.connection.rollback()
        flash(f"Could not generate Student ID: {e}", "danger")

    finally:
        cur.close()

    return redirect(url_for("admin.dashboard"))


@admin_bp.route("/generate-student-ids", methods=["GET"])
@admin_required
def generate_student_ids_page():
    return render_template("admin/student_id_generator.html")

@admin_bp.route("/student-id-generator")
@admin_required
def student_id_generator():
    return render_template("admin/student_id_generator.html")
@admin_bp.route("/generate-student-ids-pdf", methods=["POST"])
@admin_required
def generate_student_ids_pdf():
    quantity = request.form.get("quantity", "250").strip()

    try:
        quantity = int(quantity)
    except ValueError:
        flash("Please enter a valid number of codes.", "danger")
        return redirect(url_for("admin.student_id_generator"))

    if quantity < 1 or quantity > 5000:
        flash("Please enter a number between 1 and 5000.", "danger")
        return redirect(url_for("admin.student_id_generator"))

    cur = mysql.connection.cursor()

    try:
        # Find the latest Student ID
        cur.execute("""
            SELECT student_id
            FROM student_id_codes
            WHERE student_id LIKE 'STU%'
            ORDER BY id DESC
            LIMIT 1
        """)

        row = cur.fetchone()

        next_number = 1

        if row and row.get("student_id"):
            import re

            match = re.search(r"STU(\d+)$", row["student_id"])

            if match:
                next_number = int(match.group(1)) + 1

        generated_codes = []

        # Generate requested number of unique IDs
        while len(generated_codes) < quantity:
            student_id = f"STU{next_number:04d}"

            cur.execute(
                "SELECT id FROM student_id_codes WHERE student_id=%s",
                (student_id,)
            )

            if not cur.fetchone():
                cur.execute("""
                    INSERT INTO student_id_codes
                    (student_id, is_used)
                    VALUES (%s, 0)
                """, (student_id,))

                generated_codes.append(student_id)

            next_number += 1

        mysql.connection.commit()

        # ---------------------------------------------------------
        # CREATE PDF
        # ---------------------------------------------------------

        pdf_buffer = BytesIO()

        doc = SimpleDocTemplate(
            pdf_buffer,
            pagesize=A4,
            rightMargin=30,
            leftMargin=30,
            topMargin=30,
            bottomMargin=30
        )

        styles = getSampleStyleSheet()

        title_style = ParagraphStyle(
            "StudentIDTitle",
            parent=styles["Title"],
            alignment=TA_CENTER,
            fontSize=22,
            leading=26,
            spaceAfter=18
        )

        code_style = ParagraphStyle(
            "StudentIDCode",
            parent=styles["Normal"],
            alignment=TA_CENTER,
            fontSize=18,
            leading=22
        )

        story = []

        # PDF title
        story.append(
            Paragraph(
                "VoteHub Student ID Codes",
                title_style
            )
        )

        # ---------------------------------------------------------
        # 3 COLUMN LAYOUT
        # ---------------------------------------------------------

        rows = []

        for i in range(0, len(generated_codes), 3):

            row_codes = generated_codes[i:i + 3]

            row = []

            for code in row_codes:
                row.append(
                    Paragraph(
                        f"<b>{code}</b>",
                        code_style
                    )
                )

            # Fill empty cells so every row has 3 columns
            while len(row) < 3:
                row.append("")

            rows.append(row)

        table = Table(
            rows,
            colWidths=[175, 175, 175],
            rowHeights=42
        )

        table.setStyle(
            TableStyle([
                (
                    "GRID",
                    (0, 0),
                    (-1, -1),
                    0.7,
                    colors.grey
                ),
                (
                    "VALIGN",
                    (0, 0),
                    (-1, -1),
                    "MIDDLE"
                ),
                (
                    "ALIGN",
                    (0, 0),
                    (-1, -1),
                    "CENTER"
                ),
                (
                    "LEFTPADDING",
                    (0, 0),
                    (-1, -1),
                    5
                ),
                (
                    "RIGHTPADDING",
                    (0, 0),
                    (-1, -1),
                    5
                ),
                (
                    "TOPPADDING",
                    (0, 0),
                    (-1, -1),
                    5
                ),
                (
                    "BOTTOMPADDING",
                    (0, 0),
                    (-1, -1),
                    5
                )
            ])
        )

        story.append(table)

        doc.build(story)

        pdf_buffer.seek(0)

        return send_file(
            pdf_buffer,
            mimetype="application/pdf",
            as_attachment=True,
            download_name=f"VoteHub_Student_ID_Codes_{quantity}.pdf"
        )

    except Exception as e:
        mysql.connection.rollback()

        flash(
            f"Could not generate Student IDs: {e}",
            "danger"
        )

        return redirect(
            url_for("admin.student_id_generator")
        )

    finally:
        cur.close()
@admin_bp.route("/dashboard")
@admin_required
def dashboard():
    cur = mysql.connection.cursor()

    cur.execute("""
        SELECT COUNT(*) AS total
        FROM users
        WHERE role='voter'
    """)
    total_voters = cur.fetchone()["total"]

    cur.execute("""
        SELECT COUNT(*) AS total
        FROM elections
    """)
    total_elections = cur.fetchone()["total"]

    cur.execute("""
        SELECT COUNT(*) AS total
        FROM candidates
    """)
    total_candidates = cur.fetchone()["total"]

    cur.execute("""
        SELECT COUNT(*) AS total
        FROM votes
    """)
    total_votes = cur.fetchone()["total"]

    cur.execute("""
        SELECT COUNT(DISTINCT v.voter_id) AS total
        FROM voters v
        INNER JOIN users u
            ON v.user_id = u.user_id
        WHERE v.verification_status='pending'
          AND u.role='voter'
          AND u.status='active'
          AND v.date_of_birth IS NOT NULL
          AND v.gender IS NOT NULL
          AND TRIM(COALESCE(v.address, '')) <> ''
          AND TRIM(COALESCE(v.id_type, '')) <> ''
          AND TRIM(COALESCE(v.id_number, '')) <> ''
    """)
    pending_voters = cur.fetchone()["total"]

    cur.execute("""
        SELECT COUNT(*) AS total
        FROM elections
        WHERE status='active'
          AND start_datetime <= NOW()
          AND end_datetime > NOW()
    """)
    live_elections = cur.fetchone()["total"]

    cur.execute("""
        SELECT COUNT(*) AS total
        FROM elections
        WHERE result_published=1
    """)
    published_results = cur.fetchone()["total"]

    cur.execute("""
        SELECT id, student_id, is_used, created_at, used_at
        FROM student_id_codes
        ORDER BY id DESC
        LIMIT 20
    """)
    student_id_codes = cur.fetchall()

    cur.close()

    stats = {
        "total_voters": total_voters,
        "total_elections": total_elections,
        "total_candidates": total_candidates,
        "total_votes": total_votes,
        "pending_voters": pending_voters,
        "live_elections": live_elections,
        "published_results": published_results
    }

    return render_template(
    "admin/dashboard.html",
    stats=stats,
    student_id_codes=student_id_codes
)

@admin_bp.route("/voters")
@admin_required
def voters():
    cur = mysql.connection.cursor()

    cur.execute("""
        SELECT
            u.user_id,
            u.full_name,
            u.email,
            u.phone,
            u.status,
            v.voter_id,
            v.voter_uid,
            v.date_of_birth,
            v.gender,
            v.address,
            v.id_type,
            v.id_number,
            v.verification_status
        FROM users u
        LEFT JOIN voters v
            ON u.user_id = v.user_id
        WHERE u.role='voter'
        ORDER BY u.user_id DESC
    """)

    voter_list = cur.fetchall()
    cur.close()

    return render_template(
        "admin/voters.html",
        voters=voter_list
    )

@admin_bp.route("/voters/approve/<int:voter_id>")
@admin_required
def approve_voter(voter_id):
    cur = mysql.connection.cursor()

    cur.execute("""
        UPDATE voters
        SET verification_status='approved'
        WHERE voter_id=%s
    """, (voter_id,))

    mysql.connection.commit()
    cur.close()

    flash("Voter approved successfully.", "success")
    return redirect(url_for("admin.voters"))

@admin_bp.route("/voters/reject/<int:voter_id>")
@admin_required
def reject_voter(voter_id):
    cur = mysql.connection.cursor()

    cur.execute("""
        UPDATE voters
        SET verification_status='rejected'
        WHERE voter_id=%s
    """, (voter_id,))

    mysql.connection.commit()
    cur.close()

    flash("Voter rejected successfully.", "warning")
    return redirect(url_for("admin.voters"))

@admin_bp.route("/voters/block/<int:user_id>")
@admin_required
def block_voter(user_id):
    cur = mysql.connection.cursor()

    cur.execute("""
        UPDATE users
        SET status='blocked'
        WHERE user_id=%s
          AND role='voter'
    """, (user_id,))

    mysql.connection.commit()
    cur.close()

    flash("Voter account blocked.", "danger")
    return redirect(url_for("admin.voters"))

@admin_bp.route("/voters/activate/<int:user_id>")
@admin_required
def activate_voter(user_id):
    cur = mysql.connection.cursor()

    cur.execute("""
        UPDATE users
        SET status='active'
        WHERE user_id=%s
          AND role='voter'
    """, (user_id,))

    mysql.connection.commit()
    cur.close()

    flash("Voter account activated.", "success")
    return redirect(url_for("admin.voters"))

















