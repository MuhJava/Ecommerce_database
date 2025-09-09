-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 09, 2025 at 07:08 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecommerce site`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getAge` (`customerID` INT(8)) RETURNS DECIMAL(6,2)  BEGIN
 DECLARE age DEC(6,4);
 SELECT (DATEDIFF(CURDATE(), customer.dob) / 365) INTO age
 FROM customer
 WHERE customerID = customer.customerID;
 RETURN age;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getAmountSpent` (`customerID` INT) RETURNS DECIMAL(10,2)  BEGIN
 DECLARE total int;
 SELECT SUM(order.total) INTO total
 FROM `order`
 WHERE order.customerID = customerID;
 RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getStockOut` (`storeID` INT(6), `productID` INT(8)) RETURNS INT(5)  BEGIN
 DECLARE stockVariance int;
 SELECT (store_items.stock_limit - store_items.stock_level) INTO stockVariance
 FROM store_items
 WHERE store_items.storeID = storeID AND store_items.productID = productID;
 RETURN stockVariance;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `address_id` int(10) NOT NULL,
  `street_number` varchar(10) NOT NULL,
  `street_name` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL,
  `postcode` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`address_id`, `street_number`, `street_name`, `city`, `country`, `postcode`) VALUES
(1, '253', 'cherrystreet', 'manchester', 'Great Britain', 'M1345'),
(2, '233', 'superstreet', 'peterborough', 'Great Britain', 'PE213RG'),
(3, '232', 'funstreet', 'london', 'Great Britain', 'CR28GH'),
(4, '64B', 'scaryavenue', 'cambridge', 'Great Britain', 'CB204BR'),
(5, '12E', 'lestreet', 'leoise', 'France', '20500'),
(6, '2A', 'leavenue', 'paris', 'France', '40000'),
(7, '65', 'lesclose', 'paris', 'France', '40021'),
(8, '105', 'ammostreet', 'montana', 'United States', '12345-2'),
(9, '2532', 'berrystreet', 'manchester', 'Great Britain', 'M4345'),
(10, '2333', 'faluperstreet', 'peterborough', 'Great Britain', 'PE183RG'),
(11, '2342', 'chunstreet', 'london', 'Great Britain', 'CR13GH'),
(12, '646B', 'waryavenue', 'cambridge', 'Great Britain', 'CB114BR'),
(13, '142E', 'lesointreet', 'bordeux', 'France', '20876'),
(14, '22A', 'lesavenues', 'bordeux', 'France', '40126');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `categoryID` int(8) NOT NULL,
  `category_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`categoryID`, `category_name`) VALUES
(1, 'Laptops'),
(2, 'Desktops'),
(3, 'Monitors'),
(4, 'Keyboards'),
(5, 'Printers'),
(6, 'Mouse');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customerID` int(9) NOT NULL,
  `password` varchar(8) NOT NULL,
  `dob` date NOT NULL,
  `address_id` int(10) NOT NULL,
  `first_name` varchar(6) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email_address` varchar(30) NOT NULL,
  `title` enum('Mr','Mrs','Ms','Dr') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customerID`, `password`, `dob`, `address_id`, `first_name`, `last_name`, `email_address`, `title`) VALUES
(1, 'pass123', '1995-11-10', 1, 'tim', 'straw', 'guy@hotmail.com', 'Mr'),
(2, 'pass543', '1995-08-10', 2, 'jim', 'barry', 'boy@hotmail.com', 'Mr'),
(3, 'pass234', '2001-04-14', 3, 'bill', 'mithson', 'man@hotmail.com', 'Mr'),
(4, 'pass645', '1997-07-16', 4, 'steve', 'smith', 'dude@hotmail.com', 'Mr'),
(5, 'pass765', '1994-09-08', 5, 'susan', 'smith', 'person@hotmail.com', 'Mrs'),
(6, 'pass673', '1997-05-12', 6, 'sarah', 'stoosen', 'girl@hotmail.com', 'Mrs'),
(7, 'pass835', '2001-10-18', 7, 'jennif', 'goota', 'woman@hotmail.com', 'Ms'),
(8, 'pass934', '1986-04-16', 8, 'eve', 'larson', 'bad@hotmail.com', 'Dr'),
(9, 'pass12gh', '1990-10-19', 1, 'bob', 'straw', 'otherguy@gmail.com', 'Mr'),
(10, 'pass54df', '1992-02-01', 3, 'jill', 'barry', 'bouya@gmail.co.uk', 'Mrs'),
(11, 'pass23we', '1989-05-12', 2, 'may', 'mithson', 'anotherman@gmail.com', 'Mr'),
(12, 'pass64qw', '1970-03-18', 8, 'chris', 'smith', 'dudette@gmail.co.uk', 'Mrs');

-- --------------------------------------------------------

--
-- Table structure for table `discounts`
--

CREATE TABLE `discounts` (
  `discount_id` int(6) NOT NULL,
  `code` varchar(8) NOT NULL,
  `percentage_off` smallint(3) NOT NULL,
  `sponsor` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `discounts`
--

INSERT INTO `discounts` (`discount_id`, `code`, `percentage_off`, `sponsor`) VALUES
(1, 'ABC123', 20, 'Some toy company'),
(2, 'DFG234', 15, 'Some toy company'),
(3, 'FGH567', 15, 'Some cleaning company'),
(4, 'SDF345', 40, 'Some cleaning company'),
(5, 'RTY567', 10, 'Some toy company'),
(6, 'DFG456', 10, 'Some game company'),
(7, 'RTY890', 15, 'Some tech company'),
(8, 'TYU789', 10, 'Some toy company'),
(9, 'XCV456', 25, 'Some game company'),
(10, 'BNM789', 30, 'Some game company');

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `orderID` int(12) NOT NULL,
  `customerID` int(8) NOT NULL,
  `storeID` int(6) NOT NULL,
  `discount_id` int(6) NOT NULL,
  `tracking_number` varchar(12) NOT NULL,
  `subtotal` decimal(8,2) NOT NULL,
  `total` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order`
--

INSERT INTO `order` (`orderID`, `customerID`, `storeID`, `discount_id`, `tracking_number`, `subtotal`, `total`) VALUES
(1, 1, 1, 1, '123456', 400.98, 320.78),
(2, 3, 1, 2, 'AB3456', 678.50, 576.73),
(3, 4, 1, 1, 'BC3456', 580.99, 464.79),
(4, 5, 2, 1, 'GH3456', 101.98, 81.58),
(5, 8, 2, 3, 'DF3456', 222.98, 189.53),
(6, 8, 2, 4, '123332', 523.98, 314.39),
(7, 5, 3, 4, '123232', 200.96, 120.58),
(8, 5, 4, 5, '123123', 468.92, 422.03),
(9, 4, 5, 7, '123987', 798.92, 679.08),
(10, 2, 6, 7, '123FGH', 689.92, 586.43),
(11, 2, 6, 6, '123ERT', 240.95, 216.86);

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `orderID` int(12) NOT NULL,
  `productID` int(10) NOT NULL,
  `item_quantity` tinyint(3) UNSIGNED NOT NULL,
  `unit_price` decimal(7,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`orderID`, `productID`, `item_quantity`, `unit_price`) VALUES
(1, 1, 1, 150.98),
(1, 3, 1, 300.98),
(2, 1, 2, 301.96),
(2, 2, 1, 250.98),
(2, 3, 1, 150.98),
(3, 4, 1, 100.99),
(3, 5, 3, 540.00),
(4, 7, 1, 101.98),
(5, 6, 1, 222.98),
(6, 8, 3, 543.92),
(7, 9, 2, 213.96),
(8, 15, 3, 513.92),
(9, 14, 3, 423.92),
(10, 13, 1, 97.98),
(11, 12, 1, 120.50),
(11, 11, 1, 99.98),
(11, 10, 1, 76.98),
(10, 11, 2, 199.96),
(9, 11, 4, 399.92),
(10, 14, 3, 420.92);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `productID` int(10) NOT NULL,
  `categoryID` int(8) NOT NULL,
  `description` varchar(300) NOT NULL,
  `customer_rating` enum('1','1.5','2','2.5','3','3.5','4','4.5','5') NOT NULL,
  `delivery_type` enum('fast','standard','next day') NOT NULL,
  `number_of_purchases` mediumint(8) UNSIGNED NOT NULL,
  `product_price` decimal(7,2) NOT NULL,
  `product_name` varchar(50) NOT NULL,
  `number_of_views` int(10) UNSIGNED NOT NULL,
  `product_image` geometry NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`productID`, `categoryID`, `description`, `customer_rating`, `delivery_type`, `number_of_purchases`, `product_price`, `product_name`, `number_of_views`, `product_image`) VALUES
(1, 1, 'Not great not bad laptop', '3', '', 1020, 150.98, 'cheaplaptop', 4050, 0x),
(2, 1, 'Average laptop with good specs for gaming', '4', '', 102, 250.98, 'averagelaptop', 6785, 0x),
(3, 1, 'High end gaming laptop with latest gen parts', '5', '', 345, 300.98, 'goodlaptop', 687, 0x),
(4, 2, 'Not great not bad desktop', '3.5', '', 54, 100.99, 'cheapdesktop', 123, 0x),
(5, 2, 'Average desktop with good specs for gaming', '4', '', 23, 180.00, 'averagedesktop', 444, 0x),
(6, 2, 'High end gaming desktop with latest gen parts', '4.5', '', 34, 222.98, 'gooddesktop', 366, 0x),
(7, 3, 'Not great not bad monitor', '2.5', '', 545, 101.98, 'cheapmonitor', 634, 0x),
(8, 3, 'Average monitor with good specs for gaming', '3.5', '', 432, 180.98, 'averagemonitor', 7373, 0x),
(9, 3, 'High end gaming monitor with latest gen parts', '4.5', '', 234, 206.98, 'goodmonitor', 6457, 0x),
(10, 4, 'Not great not bad keyboard', '3', '', 767, 76.98, 'cheapkeyboard', 54747, 0x),
(11, 5, 'Not great not bad printer', '3.5', '', 77, 99.98, 'cheapprinter', 4584, 0x),
(12, 6, 'Not great not bad mouse', '4.5', '', 554, 120.50, 'cheapmouse', 45645, 0x),
(13, 4, 'Pretty good keyboard for not bad price', '3', '', 34, 97.98, 'goodkeyboard', 9877, 0x),
(14, 5, 'Pretty good printer for not bad price', '3.5', '', 97, 140.98, 'goodprinter', 9766, 0x),
(15, 6, 'Pretty good mouse for not bad price', '4.5', '', 808, 170.98, 'goodmouse', 5647, 0x);

-- --------------------------------------------------------

--
-- Table structure for table `product_history`
--

CREATE TABLE `product_history` (
  `product_historyID` int(8) NOT NULL,
  `productID` int(11) NOT NULL,
  `previous_price` decimal(7,2) NOT NULL,
  `previous_number_of_purchases` mediumint(8) UNSIGNED NOT NULL,
  `update_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_history`
--

INSERT INTO `product_history` (`product_historyID`, `productID`, `previous_price`, `previous_number_of_purchases`, `update_date`) VALUES
(1, 1, 174.32, 1500, '2020-02-10'),
(2, 2, 235.34, 153, '2020-02-10'),
(3, 3, 345.34, 320, '2020-02-10'),
(4, 4, 60.00, 234, '2020-02-10'),
(5, 5, 130.00, 50, '2020-02-10'),
(6, 6, 240.00, 52, '2020-02-10'),
(7, 7, 141.32, 500, '2020-02-10'),
(8, 8, 200.32, 400, '2020-02-10'),
(9, 9, 220.50, 201, '2020-02-10'),
(10, 10, 50.69, 800, '2020-02-10'),
(11, 11, 89.99, 98, '2020-02-10'),
(12, 12, 101.69, 589, '2020-02-10'),
(13, 13, 80.65, 64, '2020-02-10'),
(14, 14, 120.00, 205, '2020-02-10'),
(15, 15, 205.00, 705, '2020-02-10'),
(16, 1, 186.65, 1654, '2020-02-10'),
(17, 2, 245.65, 174, '2020-02-10'),
(18, 3, 360.45, 301, '2020-02-10');

-- --------------------------------------------------------

--
-- Table structure for table `store`
--

CREATE TABLE `store` (
  `storeID` int(6) NOT NULL,
  `contact_number` varchar(15) NOT NULL,
  `address_id` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `store`
--

INSERT INTO `store` (`storeID`, `contact_number`, `address_id`) VALUES
(1, '+447812365478', 9),
(2, '+447435485724', 14),
(3, '+447572935612', 10),
(4, '+447856453421', 11),
(5, '555-555-1234', 12),
(6, '+33215468875', 13);

-- --------------------------------------------------------

--
-- Table structure for table `store_items`
--

CREATE TABLE `store_items` (
  `productID` int(10) NOT NULL,
  `storeID` int(6) NOT NULL,
  `stock_limit` smallint(5) UNSIGNED NOT NULL,
  `stock_level` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `store_items`
--

INSERT INTO `store_items` (`productID`, `storeID`, `stock_limit`, `stock_level`) VALUES
(1, 1, 150, 80),
(1, 3, 150, 60),
(1, 5, 150, 36),
(1, 6, 150, 70),
(2, 1, 100, 70),
(3, 1, 80, 20),
(3, 3, 80, 40),
(3, 5, 80, 60),
(4, 2, 120, 30),
(4, 4, 200, 160),
(5, 2, 300, 240),
(5, 3, 180, 150),
(5, 4, 150, 130),
(6, 2, 90, 60),
(6, 4, 90, 60),
(7, 3, 100, 60),
(8, 3, 123, 43),
(9, 3, 321, 300),
(10, 2, 76, 28),
(10, 4, 76, 60),
(10, 5, 200, 150),
(11, 2, 85, 24),
(11, 4, 60, 50),
(11, 5, 85, 75),
(11, 6, 85, 40),
(12, 2, 200, 95),
(12, 4, 200, 150),
(12, 5, 200, 50),
(12, 6, 200, 30),
(13, 1, 170, 94),
(13, 5, 170, 150),
(13, 6, 170, 140),
(14, 1, 35, 24),
(14, 6, 35, 20),
(15, 1, 50, 10),
(15, 6, 50, 20);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`address_id`),
  ADD KEY `postcode` (`postcode`),
  ADD KEY `country` (`country`),
  ADD KEY `city` (`city`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`categoryID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customerID`),
  ADD KEY `User_DOBs` (`dob`),
  ADD KEY `User_surnames` (`last_name`),
  ADD KEY `address_id` (`address_id`);

--
-- Indexes for table `discounts`
--
ALTER TABLE `discounts`
  ADD PRIMARY KEY (`discount_id`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`orderID`),
  ADD KEY `tracking_number` (`tracking_number`),
  ADD KEY `customerID` (`customerID`),
  ADD KEY `storeID` (`storeID`),
  ADD KEY `discount_id` (`discount_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD KEY `orderID` (`orderID`),
  ADD KEY `productID` (`productID`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`productID`),
  ADD KEY `customer_rating` (`customer_rating`),
  ADD KEY `delivery_type` (`delivery_type`),
  ADD KEY `product_price` (`product_price`),
  ADD KEY `product_name` (`product_name`),
  ADD KEY `categoryID` (`categoryID`);

--
-- Indexes for table `product_history`
--
ALTER TABLE `product_history`
  ADD KEY `update_date` (`update_date`),
  ADD KEY `product` (`productID`);

--
-- Indexes for table `store`
--
ALTER TABLE `store`
  ADD PRIMARY KEY (`storeID`),
  ADD KEY `contact_number` (`contact_number`),
  ADD KEY `address` (`address_id`);

--
-- Indexes for table `store_items`
--
ALTER TABLE `store_items`
  ADD PRIMARY KEY (`productID`,`storeID`),
  ADD KEY `stock_limit` (`stock_limit`),
  ADD KEY `stock_level` (`stock_level`),
  ADD KEY `storeID` (`storeID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `address_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customerID` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `discounts`
--
ALTER TABLE `discounts`
  MODIFY `discount_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`);

--
-- Constraints for table `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `order_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`),
  ADD CONSTRAINT `order_ibfk_3` FOREIGN KEY (`storeID`) REFERENCES `store` (`storeID`),
  ADD CONSTRAINT `order_ibfk_4` FOREIGN KEY (`discount_id`) REFERENCES `discounts` (`discount_id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`orderID`) REFERENCES `order` (`orderID`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`categoryID`) REFERENCES `category` (`categoryID`);

--
-- Constraints for table `product_history`
--
ALTER TABLE `product_history`
  ADD CONSTRAINT `product` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`);

--
-- Constraints for table `store`
--
ALTER TABLE `store`
  ADD CONSTRAINT `address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`);

--
-- Constraints for table `store_items`
--
ALTER TABLE `store_items`
  ADD CONSTRAINT `store_items_ibfk_1` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`),
  ADD CONSTRAINT `store_items_ibfk_2` FOREIGN KEY (`storeID`) REFERENCES `store` (`storeID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
