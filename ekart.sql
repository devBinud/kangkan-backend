-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 09, 2023 at 01:10 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ekart`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateProduct` (IN `p_name` VARCHAR(255), IN `p_description` TEXT, IN `p_MRP` DECIMAL(10,2), IN `p_category_id` INT, IN `p_image` VARCHAR(255), IN `p_arrangement_id` INT, IN `p_sub_heading` VARCHAR(255), IN `p_sub_description` TEXT, IN `product_rating` INT)   BEGIN
  DECLARE last_product_id INT;
  DECLARE product_code VARCHAR(50);
  DECLARE rollback_flag BOOLEAN DEFAULT 0;

  -- Declare handler for SQL exceptions
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    SET rollback_flag = 1;

  -- Start the transaction
  START TRANSACTION;

  -- Try block
  BEGIN
    -- Insert into master_product table
    INSERT INTO master_products (name, description, MRP, category_id,product_rating)
    VALUES (p_name, p_description, p_MRP, p_category_id,product_rating);

    -- Get the last inserted product_id
    SET last_product_id = LAST_INSERT_ID();

	   -- Generate product_code based on some logic (you can customize this logic)
    SET product_code = CONCAT('PROD', LPAD(last_product_id, 5, '0'));

    -- Update master_product table with the generated product_code
    UPDATE master_products SET product_code = product_code WHERE product_id = last_product_id;

    -- Insert into product_image table
    -- INSERT INTO product_image (product_id, image, arrangement_id)
    -- VALUES (last_product_id, p_image, p_arrangement_id);

    -- Insert into product_details table
    -- INSERT INTO product_details (product_id, sub_heading, sub_description)
    -- VALUES (last_product_id, p_sub_heading, p_sub_description);
  END;

  -- Commit or rollback the transaction based on the rollback flag
  IF (rollback_flag) THEN
    ROLLBACK;
  ELSE
    COMMIT;
    -- Return the inserted product_id
    SELECT last_product_id ;
  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCategoryHierarchy` ()   BEGIN
    WITH RECURSIVE CategoryCTE AS (
        SELECT
            category_id,
            category_name,
            parent_category_id,
            category_name AS hierarchy_path
        FROM
            master_categories
        WHERE
            parent_category_id IS NULL

        UNION ALL

        SELECT
            mc.category_id,
            mc.category_name,
            mc.parent_category_id,
            CONCAT(cte.hierarchy_path, ' > ', mc.category_name) AS hierarchy_path
        FROM
            master_categories mc
        JOIN
            CategoryCTE cte ON mc.parent_category_id = cte.category_id
    )

    SELECT
        category_id,
        category_name,
        hierarchy_path
    FROM
        CategoryCTE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LoginGoogle` (IN `p_username` VARCHAR(255))   BEGIN
    DECLARE user_id INT;
    DECLARE token varchar(255);
    
    -- Check if the username and password match
    SELECT id INTO user_id
    FROM admin
    WHERE email = p_username;

    -- If a matching user is found, log the login time
    IF user_id IS NOT NULL THEN
        SET token = MD5(FLOOR(10000 + RAND() * 99999));
        
        -- Insert login time into admin_login_history
        INSERT INTO admin_login_history (admin_id, login_time)
        VALUES (user_id, CURRENT_TIMESTAMP);

        -- Update token in the admin table
        UPDATE admin SET token = token WHERE id = user_id;

        -- You can also return a success message or status if needed
        SELECT 'Login successful' AS status, token AS token;
    ELSE
        -- You can return a failure message or status if needed
        SELECT 'Invalid username or password' AS status, '' AS token;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LoginProcedure` (IN `p_username` VARCHAR(255), IN `p_password` VARCHAR(255))   BEGIN
    DECLARE user_id INT;
    DECLARE token varchar(255);
    
    -- Check if the username and password match
    SELECT id INTO user_id
    FROM admin
    WHERE email = p_username AND password = p_password;

    -- If a matching user is found, log the login time
    IF user_id IS NOT NULL THEN
        SET token = MD5(FLOOR(10000 + RAND() * 99999));
        
        -- Insert login time into admin_login_history
        INSERT INTO admin_login_history (admin_id, login_time)
        VALUES (user_id, CURRENT_TIMESTAMP);

        -- Update token in the admin table
        UPDATE admin SET token = token WHERE id = user_id;

        -- You can also return a success message or status if needed
        SELECT 'Login successful' AS status, token AS token;
    ELSE
        -- You can return a failure message or status if needed
        SELECT 'Invalid username or password' AS status, '' AS token;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(12) NOT NULL,
  `password` varchar(255) NOT NULL,
  `ip_address` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `admin_type` enum('super','gen') NOT NULL DEFAULT 'super',
  `token` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `name`, `photo`, `email`, `phone`, `password`, `ip_address`, `created_at`, `created_by`, `admin_type`, `token`) VALUES
(1, 'user1', 'photo.jpg', 'gyaankunja@gmail.com', '', 'abc', '10.177.213.221', '2023-11-24 09:39:19', 1, 'super', '5a2038a5c5cc18eb8abb5abfbc4c95d9'),
(2, 'Manas Barman', NULL, 'profile@gmail.com', '9435487128', 'pass@123', NULL, '2023-11-24 09:39:19', 1, 'super', '5a2038a5c5cc18eb8abb5abfbc4c95d8'),
(3, 'Manas Barman', NULL, 'profile@gmail.com', '9435487128', 'pass@123', NULL, '2023-11-24 09:39:19', 1, 'super', '5a2038a5c5cc18eb8abb5abfbc4c95d8'),
(4, 'Manas Barman', NULL, 'profile@gmail.com', '9435487128', 'pass@123', NULL, '2023-11-24 09:39:19', 1, 'super', '5a2038a5c5cc18eb8abb5abfbc4c95d8');

-- --------------------------------------------------------

--
-- Table structure for table `admin_delivary_address`
--

CREATE TABLE `admin_delivary_address` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `pin` int(11) NOT NULL,
  `address` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_login_history`
--

CREATE TABLE `admin_login_history` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `login_time` datetime NOT NULL,
  `ip_address` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_login_history`
--

INSERT INTO `admin_login_history` (`id`, `admin_id`, `login_time`, `ip_address`) VALUES
(1, 1, '2023-11-24 15:15:59', NULL),
(2, 1, '2023-11-24 15:16:59', NULL),
(3, 1, '2023-11-24 15:34:36', NULL),
(4, 1, '2023-11-24 15:50:01', NULL),
(5, 1, '2023-11-24 16:26:31', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `base_price`
--

CREATE TABLE `base_price` (
  `id` int(11) NOT NULL,
  `base_price` float NOT NULL,
  `is_active` varchar(1) NOT NULL DEFAULT 'Y' COMMENT 'y->active, n-> not active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) NOT NULL,
  `ip_address` varchar(18) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `coupon_details`
--

CREATE TABLE `coupon_details` (
  `id` int(11) NOT NULL,
  `coupon_code` varchar(50) NOT NULL,
  `product_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `discount_type` enum('percentage','rupees') NOT NULL,
  `min_buy_amount` float NOT NULL,
  `max_discount_amount` float NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_address`
--

CREATE TABLE `customer_address` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `address` varchar(255) NOT NULL,
  `pin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_cart`
--

CREATE TABLE `customer_cart` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_details`
--

CREATE TABLE `customer_details` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact` varchar(12) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `token` varchar(100) DEFAULT NULL COMMENT 'ip'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_details`
--

INSERT INTO `customer_details` (`id`, `name`, `contact`, `email`, `password`, `token`) VALUES
(1, 'arun', '9874686557', 'abc@gmail.com', 'qwertyuiop', NULL),
(2, 'rabin', '9870000000', 'rabin@gmail.com', 'uyutyt', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `customer_order`
--

CREATE TABLE `customer_order` (
  `id` int(11) NOT NULL,
  `order_code` varchar(20) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `customer_address_id` int(11) NOT NULL,
  `payment_type` enum('credit_card','upi','cod','netbanking') NOT NULL,
  `discount` float NOT NULL,
  `coupon_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_order_delivery`
--

CREATE TABLE `customer_order_delivery` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `delivery_date` date NOT NULL,
  `customer_address_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_order_payment`
--

CREATE TABLE `customer_order_payment` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `payment_status` enum('paid','unpaid') NOT NULL,
  `transaction_id` varchar(100) NOT NULL,
  `method` enum('cod','credit_card','netbanking','debitcard') NOT NULL,
  `price_amount` float NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_order_return`
--

CREATE TABLE `customer_order_return` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `payment_id` int(11) NOT NULL,
  `delivery_id` int(11) NOT NULL,
  `refund_amount` float NOT NULL,
  `created_at` datetime NOT NULL,
  `return_exchange` tinyint(4) NOT NULL COMMENT 'return 0, exchange 1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_product_review`
--

CREATE TABLE `customer_product_review` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `rating` float NOT NULL,
  `comments` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_wishlist`
--

CREATE TABLE `customer_wishlist` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `master_categories`
--

CREATE TABLE `master_categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `parent_category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `master_categories`
--

INSERT INTO `master_categories` (`category_id`, `category_name`, `parent_category_id`) VALUES
(1, 'mekhela sador', NULL),
(2, 'gamusa-mix', NULL),
(3, 'single sador', NULL),
(4, 'uka set (plain)', NULL),
(5, 'paat mugha', 1),
(6, 'pure toss', 1),
(7, 'padmini cotton', 1),
(8, 'pure nuni', 1),
(9, 'assam paat', 1),
(10, 'mugha', 4),
(11, 'toss', 4),
(12, 'test1', 10);

-- --------------------------------------------------------

--
-- Table structure for table `master_dealer`
--

CREATE TABLE `master_dealer` (
  `delar_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `contact` varchar(12) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `master_gst_details`
--

CREATE TABLE `master_gst_details` (
  `gst_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `hsn` varchar(20) NOT NULL,
  `igst` float DEFAULT NULL,
  `cgst` float DEFAULT NULL,
  `sgst` float DEFAULT NULL,
  `other` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `master_products`
--

CREATE TABLE `master_products` (
  `product_id` int(11) NOT NULL,
  `product_code` varchar(100) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `MRP` float NOT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `product_rating` int(11) NOT NULL DEFAULT 0 COMMENT '1 to 10; rating set by admin',
  `is_active` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 for active, 0 for delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `master_products`
--

INSERT INTO `master_products` (`product_id`, `product_code`, `name`, `description`, `MRP`, `brand_id`, `category_id`, `product_rating`, `is_active`) VALUES
(1, 'PROD00008', 'jamaican watch', 'A watch is a portable timepiece intended to be carried or worn by a person. It is designed to keep a consistent movement despite the motions caused by the person\'s activities.', 0, 1, 1, 0, 1),
(2, 'PROD00008', 'johny walker', 'Johnnie Walker Black Label is one of life\'s true icons. A masterful blend of single malt and grain whiskies from across Scotland, aged for at least 12 years. The result is a timeless classic with depth and balance of flavor. Drink it with ice, neat or in a Highball.', 0, 1, 1, 0, 1),
(3, 'PROD00008', 'jeans', 'assam jeans', 5000, NULL, 3, 7, 1),
(6, 'PROD00008', 'kurta', 'assam kurta', 5000, NULL, 3, 7, 1),
(7, 'PROD00008', 'kurta2', 'assam kurta2', 5002, NULL, 2, 7, 1),
(8, 'PROD00008', 'kurta3', 'assam kurta3', 5002, NULL, 2, 7, 1),
(9, 'PROD00009', 'kurta4', 'assam kurta4', 5004, NULL, 4, 7, 1);

-- --------------------------------------------------------

--
-- Table structure for table `offer_details`
--

CREATE TABLE `offer_details` (
  `offer_id` int(11) NOT NULL,
  `discount_on` enum('product','customer','cart') NOT NULL,
  `product_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `discount_type` enum('percentage','rupees') NOT NULL,
  `min_buy_amount` float NOT NULL,
  `max_discount_amount` float NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_current_stock`
--

CREATE TABLE `product_current_stock` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL COMMENT 'unique',
  `available_stock` float NOT NULL COMMENT 'it can be on meter ',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
  `threshold_limit` float DEFAULT 0 COMMENT 'for stock low alert'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_details`
--

CREATE TABLE `product_details` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `sub_heading` varchar(100) NOT NULL,
  `sub_description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_image`
--

CREATE TABLE `product_image` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `image` varchar(255) NOT NULL,
  `arrangement_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_inventory`
--

CREATE TABLE `product_inventory` (
  `pinv_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `buy_rate` decimal(10,2) NOT NULL,
  `purchase_date` date NOT NULL,
  `mfg_date` date NOT NULL,
  `exp_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin_delivary_address`
--
ALTER TABLE `admin_delivary_address`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin_login_history`
--
ALTER TABLE `admin_login_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `base_price`
--
ALTER TABLE `base_price`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coupon_details`
--
ALTER TABLE `coupon_details`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_address`
--
ALTER TABLE `customer_address`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_cart`
--
ALTER TABLE `customer_cart`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_details`
--
ALTER TABLE `customer_details`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_order`
--
ALTER TABLE `customer_order`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_order_delivery`
--
ALTER TABLE `customer_order_delivery`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_order_payment`
--
ALTER TABLE `customer_order_payment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_order_return`
--
ALTER TABLE `customer_order_return`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `master_categories`
--
ALTER TABLE `master_categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `master_products`
--
ALTER TABLE `master_products`
  ADD PRIMARY KEY (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `master_categories`
--
ALTER TABLE `master_categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `master_products`
--
ALTER TABLE `master_products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
