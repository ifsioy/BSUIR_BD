CREATE TABLE `users` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `username` varchar(255) UNIQUE NOT NULL,
  `email` varchar(255) UNIQUE NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` int NOT NULL,
  `level_id` int NOT NULL,
  `experience_points` int DEFAULT 0,
  `created_at` timestamp DEFAULT (now()),
  `is_active` boolean DEFAULT true
);

CREATE TABLE `roles` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `permissions` json
);

CREATE TABLE `user_levels` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `level_name` varchar(255) NOT NULL,
  `min_experience` int NOT NULL,
  `max_experience` int NOT NULL,
  `badge_color` varchar(255)
);

CREATE TABLE `coffee_cups` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `uploaded_at` timestamp DEFAULT (now())
);

CREATE TABLE `predictions` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `prediction_text` text NOT NULL,
  `category_id` int NOT NULL,
  `rarity_id` int NOT NULL,
  `created_at` timestamp DEFAULT (now()),
  `usage_count` int DEFAULT 0
);

CREATE TABLE `prediction_categories` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `emoji` varchar(255),
  `description` text
);

CREATE TABLE `rarity_levels` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `weight` int NOT NULL,
  `color` varchar(255)
);

CREATE TABLE `fortune_sessions` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `cup_id` int NOT NULL,
  `prediction_id` int NOT NULL,
  `session_date` timestamp DEFAULT (now()),
  `accuracy_rating` int,
  `user_feedback` text
);

CREATE TABLE `achievements` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `badge_icon` varchar(255),
  `condition_type` varchar(255) NOT NULL,
  `condition_value` varchar(255) NOT NULL
);

CREATE TABLE `user_achievements` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `achievement_id` int NOT NULL,
  `prediction_id` int,
  `achieved_at` timestamp DEFAULT (now())
);

CREATE TABLE `user_stats` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total_fortunes` int DEFAULT 0,
  `accurate_predictions` int DEFAULT 0,
  `last_activity` timestamp
);

CREATE TABLE `action_logs` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `action_type` varchar(255) NOT NULL,
  `timestamp` timestamp DEFAULT (now()),
  `ip_address` varchar(255),
  `details` text
);

ALTER TABLE `users` ADD FOREIGN KEY (`id`) REFERENCES `user_stats` (`user_id`);

ALTER TABLE `users` ADD FOREIGN KEY (`id`) REFERENCES `coffee_cups` (`user_id`);

ALTER TABLE `coffee_cups` ADD FOREIGN KEY (`id`) REFERENCES `fortune_sessions` (`cup_id`);

ALTER TABLE `users` ADD FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

ALTER TABLE `users` ADD FOREIGN KEY (`level_id`) REFERENCES `user_levels` (`id`);

ALTER TABLE `predictions` ADD FOREIGN KEY (`category_id`) REFERENCES `prediction_categories` (`id`);

ALTER TABLE `predictions` ADD FOREIGN KEY (`rarity_id`) REFERENCES `rarity_levels` (`id`);

ALTER TABLE `fortune_sessions` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `fortune_sessions` ADD FOREIGN KEY (`prediction_id`) REFERENCES `predictions` (`id`);

ALTER TABLE `user_achievements` ADD FOREIGN KEY (`prediction_id`) REFERENCES `predictions` (`id`);

ALTER TABLE `action_logs` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `user_achievements` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `user_achievements` ADD FOREIGN KEY (`achievement_id`) REFERENCES `achievements` (`id`);
