-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 01, 2019 at 07:56 AM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `game_market`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_paid` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `cart`
--
DELIMITER $$
CREATE TRIGGER `cart_transaction_history` AFTER INSERT ON `cart` FOR EACH ROW INSERT INTO transaction_history SET item_id = NEW.item_id, user_id = NEW.user_id, action='Added'
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `get_all_active_items`
-- (See below for the actual view)
--
CREATE TABLE `get_all_active_items` (
`id` int(11)
,`name` varchar(125)
,`description` varchar(512)
,`price` double
,`img_path` varchar(258)
,`created_at` datetime
,`is_active` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `get_all_active_users`
-- (See below for the actual view)
--
CREATE TABLE `get_all_active_users` (
`id` int(11)
,`username` varchar(125)
,`email` varchar(125)
,`name` varchar(125)
,`password` binary(60)
,`is_admin` tinyint(1)
,`created_at` datetime
,`is_active` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `get_all_unpaid_from_cart`
-- (See below for the actual view)
--
CREATE TABLE `get_all_unpaid_from_cart` (
`id` int(11)
,`item_id` int(11)
,`user_id` int(11)
,`is_paid` tinyint(1)
,`created_at` datetime
);

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `name` varchar(125) NOT NULL,
  `description` varchar(512) NOT NULL,
  `price` double NOT NULL,
  `img_path` varchar(258) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_history`
--

CREATE TABLE `transaction_history` (
  `id` int(11) NOT NULL,
  `action` varchar(256) NOT NULL,
  `item_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(125) NOT NULL,
  `email` varchar(125) NOT NULL,
  `name` varchar(125) NOT NULL,
  `password` binary(60) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure for view `get_all_active_items`
--
DROP TABLE IF EXISTS `get_all_active_items`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_all_active_items`  AS  select `items`.`id` AS `id`,`items`.`name` AS `name`,`items`.`description` AS `description`,`items`.`price` AS `price`,`items`.`img_path` AS `img_path`,`items`.`created_at` AS `created_at`,`items`.`is_active` AS `is_active` from `items` where (`items`.`is_active` = 1) ;

-- --------------------------------------------------------

--
-- Structure for view `get_all_active_users`
--
DROP TABLE IF EXISTS `get_all_active_users`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_all_active_users`  AS  select `users`.`id` AS `id`,`users`.`username` AS `username`,`users`.`email` AS `email`,`users`.`name` AS `name`,`users`.`password` AS `password`,`users`.`is_admin` AS `is_admin`,`users`.`created_at` AS `created_at`,`users`.`is_active` AS `is_active` from `users` where (`users`.`is_active` = 1) ;

-- --------------------------------------------------------

--
-- Structure for view `get_all_unpaid_from_cart`
--
DROP TABLE IF EXISTS `get_all_unpaid_from_cart`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_all_unpaid_from_cart`  AS  select `cart`.`id` AS `id`,`cart`.`item_id` AS `item_id`,`cart`.`user_id` AS `user_id`,`cart`.`is_paid` AS `is_paid`,`cart`.`created_at` AS `created_at` from `cart` where (`cart`.`is_paid` = 0) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaction_history`
--
ALTER TABLE `transaction_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction_history`
--
ALTER TABLE `transaction_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `transaction_history`
--
ALTER TABLE `transaction_history`
  ADD CONSTRAINT `transaction_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transaction_history_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
