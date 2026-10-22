-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 27, 2026 at 07:00 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `votehub_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(150) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidates`
--

CREATE TABLE `candidates` (
  `candidate_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `party_name` varchar(100) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `manifesto_file` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `candidates`
--

INSERT INTO `candidates` (`candidate_id`, `full_name`, `party_name`, `symbol`, `photo`, `manifesto_file`, `description`, `created_at`) VALUES
(1, 'Rithesh dsouza', 'SPL', '2858a937_pen.jpg', '2f4213f7_rithesh.jpg', NULL, 'An enthusiastic and responsible student who is contesting for the Special Role with the goal of supporting fellow students, organizing activities, addressing concerns, and contributing to a positive and inclusive environment.', '2026-06-29 05:49:47'),
(2, 'Priya', 'Asst SPL', 'da930612_flower.jpeg', '3676b04b_priya.jpg', NULL, '', '2026-07-02 04:52:39'),
(3, 'Jeevan', 'SPL', 'f0fb1cac_pencil.jpg', 'a7a92500_jeevan.jpg', NULL, '', '2026-07-02 04:53:29'),
(4, 'Joy', 'Asst SPL', 'e68445b4_book.jpg', '16ee7129_joy.jpg', NULL, '', '2026-07-02 04:54:11'),
(5, 'resvina', 'discipline ', '47f922ed_pen.jpg', '72baaaa8_sister.jpeg', NULL, 'please vote me', '2026-07-23 05:35:44');

-- --------------------------------------------------------

--
-- Table structure for table `elections`
--

CREATE TABLE `elections` (
  `election_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `status` enum('draft','active','completed','cancelled') DEFAULT 'draft',
  `result_published` tinyint(1) DEFAULT 0,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `elections`
--

INSERT INTO `elections` (`election_id`, `title`, `description`, `start_datetime`, `end_datetime`, `status`, `result_published`, `created_by`, `created_at`) VALUES
(2, 'splL election', 'u can vote only during election', '2026-07-02 10:28:00', '2026-07-02 23:59:00', 'completed', 1, NULL, '2026-07-02 04:58:59'),
(3, 'asst spl', 'vote for the election of asst role', '2026-07-02 10:59:00', '2026-07-02 12:00:00', 'completed', 1, NULL, '2026-07-02 05:30:29'),
(4, 'discipline  leader', '', '2026-07-23 10:59:00', '2026-07-24 11:00:00', 'active', 0, NULL, '2026-07-23 05:29:53');

-- --------------------------------------------------------

--
-- Table structure for table `election_candidates`
--

CREATE TABLE `election_candidates` (
  `id` int(11) NOT NULL,
  `election_id` int(11) NOT NULL,
  `candidate_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `election_candidates`
--

INSERT INTO `election_candidates` (`id`, `election_id`, `candidate_id`) VALUES
(3, 2, 1),
(2, 2, 3),
(8, 3, 2),
(9, 3, 4),
(10, 4, 5);

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

CREATE TABLE `login_attempts` (
  `attempt_id` int(11) NOT NULL,
  `email` varchar(120) DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `status` enum('success','failed') DEFAULT 'failed',
  `attempted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(150) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `otp_verifications`
--

CREATE TABLE `otp_verifications` (
  `otp_id` int(11) NOT NULL,
  `email` varchar(120) NOT NULL,
  `otp_code` varchar(10) NOT NULL,
  `purpose` enum('register','forgot_password') DEFAULT 'register',
  `is_used` tinyint(1) DEFAULT 0,
  `expires_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `otp_verifications`
--

INSERT INTO `otp_verifications` (`otp_id`, `email`, `otp_code`, `purpose`, `is_used`, `expires_at`, `created_at`) VALUES
(1, 'dsouzajoylin21@gmail.com', '321278', 'register', 1, '2026-06-29 10:39:32', '2026-06-29 04:59:32'),
(2, 'admin@gmail.com', '195238', 'register', 0, '2026-06-29 10:48:17', '2026-06-29 05:08:17'),
(3, 'votehub21@gmail.com', '118409', 'register', 1, '2026-06-29 11:20:43', '2026-06-29 05:40:43'),
(4, 'votehub21@gmail.com', '784382', 'register', 1, '2026-07-02 10:16:39', '2026-07-02 04:36:39'),
(5, 'joylinjoyce21@gmail.com', '397191', 'register', 1, '2026-07-23 10:48:52', '2026-07-23 05:08:52');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `reset_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `reset_token` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `is_used` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `results`
--

CREATE TABLE `results` (
  `result_id` int(11) NOT NULL,
  `election_id` int(11) NOT NULL,
  `candidate_id` int(11) NOT NULL,
  `total_votes` int(11) DEFAULT 0,
  `result_status` enum('pending','published') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `setting_id` int(11) NOT NULL,
  `setting_key` varchar(100) DEFAULT NULL,
  `setting_value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(120) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','voter') DEFAULT 'voter',
  `status` enum('active','pending','blocked') DEFAULT 'pending',
  `email_verified` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `email`, `phone`, `password_hash`, `role`, `status`, `email_verified`, `created_at`) VALUES
(4, 'admin', 'votehub21@gmail.com', '8867663354', '$2b$12$35mSbeT80QDhYoSb6FDBzOMZMnolnMyTzzLLk8Lu9YXeoCPMymqlm', 'admin', 'active', 1, '2026-07-02 04:36:39'),
(5, 'joylin dsouza', 'joylinjoyce21@gmail.com', '8867663354', '$2b$12$s9/b4mRNnpjTgH9ilwHp3./Hgh0cICC6PFqrBo.pmXVIUkfQTVALO', 'voter', 'active', 1, '2026-07-23 05:08:52');

-- --------------------------------------------------------

--
-- Table structure for table `voters`
--

CREATE TABLE `voters` (
  `voter_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `voter_uid` varchar(50) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `address` text DEFAULT NULL,
  `id_type` varchar(50) DEFAULT NULL,
  `id_number` varchar(100) DEFAULT NULL,
  `id_document` varchar(255) DEFAULT NULL,
  `profile_photo` varchar(255) DEFAULT NULL,
  `verification_status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `voters`
--

INSERT INTO `voters` (`voter_id`, `user_id`, `voter_uid`, `date_of_birth`, `gender`, `address`, `id_type`, `id_number`, `id_document`, `profile_photo`, `verification_status`, `created_at`) VALUES
(3, 4, 'VH-VOTER-00004', '1996-01-21', 'Female', 'mangalore', 'College ID', 'poza123453', NULL, NULL, 'pending', '2026-07-02 04:38:55'),
(4, 5, 'VH-VOTER-00005', '2000-01-21', 'Female', 'mangalore', 'College ID', 'po5z123422', NULL, NULL, 'approved', '2026-07-23 05:12:26');

-- --------------------------------------------------------

--
-- Table structure for table `votes`
--

CREATE TABLE `votes` (
  `vote_id` int(11) NOT NULL,
  `election_id` int(11) NOT NULL,
  `voter_id` int(11) NOT NULL,
  `candidate_id` int(11) NOT NULL,
  `vote_hash` varchar(255) DEFAULT NULL,
  `voted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `votes`
--

INSERT INTO `votes` (`vote_id`, `election_id`, `voter_id`, `candidate_id`, `vote_hash`, `voted_at`) VALUES
(4, 3, 4, 4, 'e4975f098c650f9727d97291f71943d5d05853a7d4c043ecbde72d2318829eba', '2026-07-23 05:15:18'),
(5, 2, 4, 3, '8f4b71cfe8b05146bc13a8e7271ebf09a559fb88abdb60b901016a783c9558ff', '2026-07-23 05:16:25'),
(6, 4, 4, 5, 'd7f5ef7ea3b5db98f948a5c18088201ad36f6b53e579ab9d1e8cd9436402b98c', '2026-07-23 05:46:12');

-- --------------------------------------------------------

--
-- Table structure for table `vote_receipts`
--

CREATE TABLE `vote_receipts` (
  `receipt_id` int(11) NOT NULL,
  `vote_id` int(11) NOT NULL,
  `receipt_code` varchar(100) DEFAULT NULL,
  `generated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vote_receipts`
--

INSERT INTO `vote_receipts` (`receipt_id`, `vote_id`, `receipt_code`, `generated_at`) VALUES
(4, 4, 'VH-RCPT-67E24425', '2026-07-23 05:15:18'),
(5, 5, 'VH-RCPT-1FAE95EC', '2026-07-23 05:16:25'),
(6, 6, 'VH-RCPT-D79AC93F', '2026-07-23 05:46:12');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `candidates`
--
ALTER TABLE `candidates`
  ADD PRIMARY KEY (`candidate_id`);

--
-- Indexes for table `elections`
--
ALTER TABLE `elections`
  ADD PRIMARY KEY (`election_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `election_candidates`
--
ALTER TABLE `election_candidates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_election_candidate` (`election_id`,`candidate_id`),
  ADD KEY `candidate_id` (`candidate_id`);

--
-- Indexes for table `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`attempt_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `otp_verifications`
--
ALTER TABLE `otp_verifications`
  ADD PRIMARY KEY (`otp_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`reset_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `results`
--
ALTER TABLE `results`
  ADD PRIMARY KEY (`result_id`),
  ADD KEY `election_id` (`election_id`),
  ADD KEY `candidate_id` (`candidate_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`setting_id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `voters`
--
ALTER TABLE `voters`
  ADD PRIMARY KEY (`voter_id`),
  ADD UNIQUE KEY `voter_uid` (`voter_uid`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `votes`
--
ALTER TABLE `votes`
  ADD PRIMARY KEY (`vote_id`),
  ADD UNIQUE KEY `unique_vote` (`election_id`,`voter_id`),
  ADD KEY `voter_id` (`voter_id`),
  ADD KEY `candidate_id` (`candidate_id`);

--
-- Indexes for table `vote_receipts`
--
ALTER TABLE `vote_receipts`
  ADD PRIMARY KEY (`receipt_id`),
  ADD UNIQUE KEY `receipt_code` (`receipt_code`),
  ADD KEY `vote_id` (`vote_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `candidates`
--
ALTER TABLE `candidates`
  MODIFY `candidate_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `elections`
--
ALTER TABLE `elections`
  MODIFY `election_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `election_candidates`
--
ALTER TABLE `election_candidates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `attempt_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `otp_verifications`
--
ALTER TABLE `otp_verifications`
  MODIFY `otp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `reset_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `results`
--
ALTER TABLE `results`
  MODIFY `result_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `setting_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `voters`
--
ALTER TABLE `voters`
  MODIFY `voter_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `votes`
--
ALTER TABLE `votes`
  MODIFY `vote_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `vote_receipts`
--
ALTER TABLE `vote_receipts`
  MODIFY `receipt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `elections`
--
ALTER TABLE `elections`
  ADD CONSTRAINT `elections_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `election_candidates`
--
ALTER TABLE `election_candidates`
  ADD CONSTRAINT `election_candidates_ibfk_1` FOREIGN KEY (`election_id`) REFERENCES `elections` (`election_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `election_candidates_ibfk_2` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`candidate_id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `results`
--
ALTER TABLE `results`
  ADD CONSTRAINT `results_ibfk_1` FOREIGN KEY (`election_id`) REFERENCES `elections` (`election_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `results_ibfk_2` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`candidate_id`) ON DELETE CASCADE;

--
-- Constraints for table `voters`
--
ALTER TABLE `voters`
  ADD CONSTRAINT `voters_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `votes`
--
ALTER TABLE `votes`
  ADD CONSTRAINT `votes_ibfk_1` FOREIGN KEY (`election_id`) REFERENCES `elections` (`election_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `votes_ibfk_2` FOREIGN KEY (`voter_id`) REFERENCES `voters` (`voter_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `votes_ibfk_3` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`candidate_id`) ON DELETE CASCADE;

--
-- Constraints for table `vote_receipts`
--
ALTER TABLE `vote_receipts`
  ADD CONSTRAINT `vote_receipts_ibfk_1` FOREIGN KEY (`vote_id`) REFERENCES `votes` (`vote_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
