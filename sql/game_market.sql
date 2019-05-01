-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 01, 2019 at 11:51 AM
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
CREATE TRIGGER `add_cart_transaction_history` AFTER INSERT ON `cart` FOR EACH ROW INSERT INTO transaction_history SET item_id = NEW.item_id, user_id = NEW.user_id, action='Added'
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `pay_cart_transaction_history` AFTER UPDATE ON `cart` FOR EACH ROW INSERT INTO transaction_history SET item_id = OLD.item_id, user_id = OLD.user_id, action='Paid'
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `remove_cart_transaction_history` AFTER DELETE ON `cart` FOR EACH ROW INSERT INTO transaction_history SET item_id = OLD.item_id, user_id = OLD.user_id, action='Removed'
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
-- Stand-in structure for view `get_all_unpaid_items`
-- (See below for the actual view)
--
CREATE TABLE `get_all_unpaid_items` (
`id` int(11)
,`item_id` int(11)
,`user_id` int(11)
,`is_paid` tinyint(1)
,`created_at` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `get_user_all_paid_items`
-- (See below for the actual view)
--
CREATE TABLE `get_user_all_paid_items` (
`id` int(11)
,`user_id` int(11)
,`item_id` int(11)
,`name` varchar(125)
,`price` double
,`is_paid` tinyint(1)
,`created_at` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `get_user_all_unpaid_items`
-- (See below for the actual view)
--
CREATE TABLE `get_user_all_unpaid_items` (
`id` int(11)
,`user_id` int(11)
,`item_id` int(11)
,`name` varchar(125)
,`price` double
,`is_paid` tinyint(1)
,`created_at` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `get_user_transaction_history`
-- (See below for the actual view)
--
CREATE TABLE `get_user_transaction_history` (
`user_id` int(11)
,`action` varchar(256)
,`created_at` datetime
,`name` varchar(125)
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
-- Structure for view `get_all_unpaid_items`
--
DROP TABLE IF EXISTS `get_all_unpaid_items`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_all_unpaid_items`  AS  select `cart`.`id` AS `id`,`cart`.`item_id` AS `item_id`,`cart`.`user_id` AS `user_id`,`cart`.`is_paid` AS `is_paid`,`cart`.`created_at` AS `created_at` from `cart` where (`cart`.`is_paid` = 0) ;

-- --------------------------------------------------------

--
-- Structure for view `get_user_all_paid_items`
--
DROP TABLE IF EXISTS `get_user_all_paid_items`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_user_all_paid_items`  AS  select `cart`.`id` AS `id`,`users`.`id` AS `user_id`,`items`.`id` AS `item_id`,`items`.`name` AS `name`,`items`.`price` AS `price`,`cart`.`is_paid` AS `is_paid`,`cart`.`created_at` AS `created_at` from ((`cart` join `items`) join `users`) where ((`cart`.`user_id` = `users`.`id`) and (`items`.`id` = `cart`.`item_id`) and (`cart`.`is_paid` = 1)) ;

-- --------------------------------------------------------

--
-- Structure for view `get_user_all_unpaid_items`
--
DROP TABLE IF EXISTS `get_user_all_unpaid_items`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_user_all_unpaid_items`  AS  select `cart`.`id` AS `id`,`users`.`id` AS `user_id`,`items`.`id` AS `item_id`,`items`.`name` AS `name`,`items`.`price` AS `price`,`cart`.`is_paid` AS `is_paid`,`cart`.`created_at` AS `created_at` from ((`cart` join `items`) join `users`) where ((`cart`.`user_id` = `users`.`id`) and (`items`.`id` = `cart`.`item_id`) and (`cart`.`is_paid` = 0)) ;

-- --------------------------------------------------------

--
-- Structure for view `get_user_transaction_history`
--
DROP TABLE IF EXISTS `get_user_transaction_history`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_user_transaction_history`  AS  select `users`.`id` AS `user_id`,`transaction_history`.`action` AS `action`,`transaction_history`.`created_at` AS `created_at`,`items`.`name` AS `name` from ((`transaction_history` join `items`) join `users`) where ((`transaction_history`.`user_id` = `users`.`id`) and (`items`.`id` = `transaction_history`.`item_id`)) ;

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
