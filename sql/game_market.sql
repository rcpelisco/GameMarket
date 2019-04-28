-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 28, 2019 at 10:40 AM
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
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `item_id`, `user_id`, `created_at`) VALUES
(1, 8, 4, '2019-04-28 14:55:20'),
(4, 10, 4, '2019-04-28 14:58:51'),
(6, 12, 4, '2019-04-28 14:59:30'),
(8, 12, 4, '2019-04-28 15:14:27'),
(9, 10, 6, '2019-04-28 15:37:30');

--
-- Triggers `cart`
--
DELIMITER $$
CREATE TRIGGER `cart_transaction_history` AFTER INSERT ON `cart` FOR EACH ROW INSERT INTO transaction_history SET item_id = NEW.item_id, user_id = NEW.user_id, action='Added'
$$
DELIMITER ;

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
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `name`, `description`, `price`, `img_path`, `created_at`) VALUES
(8, 'Swine of the Sunken Galley', 'After months of work, Techies Demolitions proudly unveiled their latest commission: The Swine, the most powerful cannon ever designed. Yet during its first frantic use aboard a homebound galley, the Swine\'s awesome blast tore its host ship asunder, rocketing the cannon itself backwards toward the shore. It was found days later, deeply embedded in a rocky cliffside just below its makers\' workshop.', 1975, '181-20190426171940.png', '2019-04-26 17:19:40'),
(9, 'Fiery Soul of the Slayer', 'It has often been said that Lina\'s hair was touched by fire, though few know the truth of this claim. In Lina\'s youth, as her natural talents first began to smoke and smolder it was her fiery hair that told the tale of the storm to come. With time and training, her skill and control of the flame was enough to suppress the searing display. Yet on occasion, when her ire grows and tempers flare, the full measure of Lina\'s burning spirit threatens to unleash its wrath.', 2000, '305-20190426172825.png', '2019-04-26 17:28:25'),
(10, 'Demon Eater', 'Shadow Fiend has long collected the souls of his enemies. As is the case with any collector, some prizes have stood above others, to be sought out at any cost. However, there are certain souls that should not be tried, and forces so dark and filled with rage that no being could hope to contain them. Thus did Shadow Fiend learn the price, and gift, that comes with stealing the souls of demons, and he was changed evermore.', 1525, '254-20190426173427.png', '2019-04-26 17:34:28'),
(11, 'Benevolent Companion', 'The wispy tendrils of Io the Fundamental can be found in all planes of the universe, having existed across the boundaries of realms known and unknown since before time itself. After an eternity of exploring the span of its mystic province, Io knows that no matter where the tide of battle leads, the bonds of friendship will always carry the day.', 1560, '265-20190428132224.png', '2019-04-28 13:22:24'),
(12, 'Frost Avalanche', 'Some say the garment began as the wedding gown of an ancient queen. Others say it was once a battle cloak of a frost ogre. In truth, the enchanted fabric is as malleable as an avalanche, and can mold itself into various forms. This form has attracted a lone wolf pup, who has now become a hardy and loyal companion.', 1945, '164-20190428133431.png', '2019-04-28 13:34:31'),
(13, 'Swine of the Sunken Galleys', 'Most Magi believed the Puzzle of Perplex to be a mere curiosity. Yet generations of wizards had broken themselves trying to solve it. And even after the Grand Magus thought he finally grasped the crux of its secret, the epiphany of true meaning came only much later—that the knowledge at the heart of Perplex might allow him to alter the very foundations of magic itself. Now, no longer limited to masterful mimicry, Rubick toys with the boundaries of arcane artistry, reshaping the world of magic as he sees fit', 2450, '448-20190428134514.png', '2019-04-28 13:45:14');

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

--
-- Dumping data for table `transaction_history`
--

INSERT INTO `transaction_history` (`id`, `action`, `item_id`, `user_id`, `created_at`) VALUES
(1, 'Added item', 12, 4, '2019-04-28 15:14:27'),
(2, 'Added item', 10, 6, '2019-04-28 15:37:30');

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
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `name`, `password`, `is_admin`, `created_at`) VALUES
(4, 'rcpelisco', 'rcpelisco@gmail.com', 'RC Pelisco', 0x243262243132247a7531377262374c68576a436c474e38594e753275654c41326c5450595a727a6b2f594d384a4c2e5a6e66365438306d312e472e79, 1, '2019-04-25 20:34:51'),
(5, 'shimbardo', 'shimbardo@gmail.com', 'Shim Bardo', 0x24326224313224564251677965424c79634f45626a6a595073754b324f427a46766d7137343169762f54334d4956742f796b547954526e4a47713265, 1, '2019-04-25 20:35:27'),
(6, 'IvanInvanovsky', 'ivan@gmail.com', 'Ivan Ivanovsky', 0x243262243132242f6d59414379597962332f367350504265534a6a564f595966474f4e6270383631496d59622e7a78695574342e2f4675464a767479, 0, '2019-04-28 13:02:58'),
(11, 'rambubuts', 'rambubuts@gmail.com', 'Ram Bubuts', 0x24326224313224336c7645444a6b365a446e7231532f594e6473435a756455376c544965566b6d68727575723471745a5338734c7850666c73747879, 1, '2019-04-28 13:18:43'),
(12, 'nik', 'nick@yahoo.com', 'nick', 0x24326224313224763670554d756f767a346a694d4a367279635449694f42647041474c6a63636e4476704e2f556f6851325355646d67345479362e79, 0, '2019-04-28 13:31:35'),
(13, 'Nick', 'nick@yahoo.com', 'Nick', 0x243262243132243630656e7a704c79344d4a307a414f6246657452594f596a61582e33564d72417753355872384851554d6d67353557716635535879, 1, '2019-04-28 13:33:33');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `transaction_history`
--
ALTER TABLE `transaction_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

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
