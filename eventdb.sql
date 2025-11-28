-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 28, 2025 at 03:52 PM
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
-- Database: `eventdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `Account_ID` int(11) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Hash` text DEFAULT NULL,
  `PhoneNumber` bigint(20) DEFAULT NULL,
  `FirstName` varchar(100) DEFAULT NULL,
  `LastName` varchar(100) DEFAULT NULL,
  `M_I` varchar(10) DEFAULT NULL,
  `Role` enum('customer','designer','admin') NOT NULL DEFAULT 'customer'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`Account_ID`, `Email`, `Hash`, `PhoneNumber`, `FirstName`, `LastName`, `M_I`, `Role`) VALUES
(1, 'chaw@yahoo.com', '$2y$10$5yCtaqOGGNOj.bAD5YgOfeGoYm4CBOjHo0jVsCBRYGfM9wB5pCvzu', 9195687451, 'Charlie', 'Villacoba', 'R.', 'customer'),
(4, 'admin@yahoo.com', '$2b$10$8oFhTdnNjKcBtyWas1907uZEPp.QBaXwb3C.ZUEiaAmKx2Xi3n9Iu', NULL, 'Admin', 'User', '', 'admin'),
(5, 'design@yahoo.com', '$2y$10$.Bh7kFcUC844CnGg7LNviOoenEiCMdho6R.8ULFUrnFiZ.MCB2MXS', NULL, 'Designer', NULL, NULL, 'designer'),
(30, 'rendal@yahoo.com', '$2b$10$RrWaWXu0bu7HFk06Dj9kj.X3fdhXrdcg6RmK48DgRf5K3nXmekeyO', 9057735076, 'Roi', 'Rendal', 'C.', 'customer');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `booking_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `event_type` varchar(100) NOT NULL,
  `event_date` date NOT NULL,
  `event_time` time NOT NULL,
  `location` varchar(255) NOT NULL,
  `guest_count` int(11) DEFAULT 0,
  `total_amount` decimal(10,2) DEFAULT 0.00,
  `status` enum('pending','confirmed','completed','cancelled') DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`booking_id`, `client_id`, `package_id`, `event_type`, `event_date`, `event_time`, `location`, `guest_count`, `total_amount`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(2, 30, 17, 'Birthday', '2025-11-13', '15:42:00', 'Darlow Ranch', 7, 145123.00, 'cancelled', 'Sample Sample', '2025-11-28 10:18:30', '2025-11-28 12:32:20'),
(3, 30, 21, 'Wedding', '2025-10-10', '22:10:00', 'Extreme Peaks', 10, 1231230.00, 'pending', 'Okay.', '2025-11-28 12:39:43', '2025-11-28 12:39:43');

-- --------------------------------------------------------

--
-- Table structure for table `design_activity_log`
--

CREATE TABLE `design_activity_log` (
  `log_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `performed_by` int(11) NOT NULL,
  `details` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `design_requests`
--

CREATE TABLE `design_requests` (
  `request_id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `assigned_to` int(11) DEFAULT NULL,
  `layout_specs` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `final_output` varchar(500) DEFAULT NULL,
  `status` enum('pending','assigned','in_progress','revision','completed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `completed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `design_revisions`
--

CREATE TABLE `design_revisions` (
  `revision_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `revision_note` text NOT NULL,
  `revised_by` int(11) NOT NULL,
  `revision_file` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `Event_ID` int(11) NOT NULL,
  `Account_ID` int(11) DEFAULT NULL,
  `Package_ID` int(11) DEFAULT NULL,
  `Event_Name` varchar(255) NOT NULL,
  `Theme` varchar(255) DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `Time_Start` time DEFAULT NULL,
  `Time_End` time DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `Layout` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`Layout`)),
  `Event_Status` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `faq`
--

CREATE TABLE `faq` (
  `faq_ID` int(11) NOT NULL,
  `Account_ID` int(11) DEFAULT NULL,
  `question` varchar(500) DEFAULT NULL,
  `answer` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `feedback_ID` int(11) NOT NULL,
  `Account_ID` int(11) DEFAULT NULL,
  `feedback` varchar(1000) DEFAULT NULL,
  `rate` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `package`
--

CREATE TABLE `package` (
  `Package_ID` int(11) NOT NULL,
  `Package_Name` varchar(255) NOT NULL,
  `Description` text NOT NULL,
  `NumTables` int(11) DEFAULT NULL,
  `NumRoundTables` int(11) NOT NULL,
  `NumChairs` int(11) DEFAULT NULL,
  `NumTent` int(11) DEFAULT NULL,
  `NumPlatform` tinyint(1) DEFAULT NULL,
  `Package_Amount` float DEFAULT NULL,
  `Status` text NOT NULL,
  `package_layout` longtext DEFAULT NULL,
  `canvas_layout` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `package`
--

INSERT INTO `package` (`Package_ID`, `Package_Name`, `Description`, `NumTables`, `NumRoundTables`, `NumChairs`, `NumTent`, `NumPlatform`, `Package_Amount`, `Status`, `package_layout`, `canvas_layout`) VALUES
(16, 'asd', 'asdasd', 1, 2, 3, 4, 55, 0, 'active', 'n/a', NULL),
(17, 'v1', 'asdasdasd', 1, 1, 1, 1, 1, 145123, 'active', '{\"version\":\"5.1.0\",\"objects\":[{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":100,\"top\":100,\"width\":51,\"height\":41,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"rect\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-25.5,\"top\":-20.5,\"width\":50,\"height\":40,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":0,\"ry\":0},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-12.5,\"top\":-5.5,\"width\":19.86,\"height\":10.17,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":9,\"text\":\"Table\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":180,\"top\":120,\"width\":45,\"height\":37,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"ellipse\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-22.5,\"top\":-18.5,\"width\":44,\"height\":36,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":22,\"ry\":18},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-14.5,\"top\":-8.5,\"width\":18.67,\"height\":17.09,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":7,\"text\":\"Round\\nTable\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"center\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":150,\"top\":150,\"width\":31,\"height\":31,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"circle\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-15.5,\"top\":-15.5,\"width\":30,\"height\":30,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"radius\":15,\"startAngle\":0,\"endAngle\":360},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-10.5,\"top\":-4.5,\"width\":17.77,\"height\":9.04,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":8,\"text\":\"Chair\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":200,\"top\":200,\"width\":61,\"height\":36,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"rect\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-30.5,\"top\":-18,\"width\":60,\"height\":35,\"fill\":\"rgba(255, 255, 255, 0.01)\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":0,\"ry\":0},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-8.5,\"top\":-5.5,\"width\":12.34,\"height\":7.91,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":7,\"text\":\"Tent\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":250,\"top\":150,\"width\":71,\"height\":51,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"rect\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-35.5,\"top\":-25.5,\"width\":70,\"height\":50,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":0,\"ry\":0},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-16.5,\"top\":-4.5,\"width\":28,\"height\":9.04,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":8,\"text\":\"Platform\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]}],\"background\":\"#1f2937\"}', NULL),
(18, '1', 'asdjobnasdvhjasdvjh', 2, 2, 2, 2, 1, 123123000, 'active', '{\"version\":\"5.1.0\",\"objects\":[{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":180,\"top\":120,\"width\":45,\"height\":37,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"ellipse\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-22.5,\"top\":-18.5,\"width\":44,\"height\":36,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":22,\"ry\":18},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-14.5,\"top\":-8.5,\"width\":18.67,\"height\":17.09,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":7,\"text\":\"Round\\nTable\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"center\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":180,\"top\":120,\"width\":45,\"height\":37,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"ellipse\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-22.5,\"top\":-18.5,\"width\":44,\"height\":36,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":22,\"ry\":18},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-14.5,\"top\":-8.5,\"width\":18.67,\"height\":17.09,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":7,\"text\":\"Round\\nTable\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"center\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":100,\"top\":100,\"width\":51,\"height\":41,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"rect\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-25.5,\"top\":-20.5,\"width\":50,\"height\":40,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":0,\"ry\":0},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-12.5,\"top\":-5.5,\"width\":19.86,\"height\":10.17,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":9,\"text\":\"Table\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":150,\"top\":150,\"width\":31,\"height\":31,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"circle\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-15.5,\"top\":-15.5,\"width\":30,\"height\":30,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"radius\":15,\"startAngle\":0,\"endAngle\":360},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-10.5,\"top\":-4.5,\"width\":17.77,\"height\":9.04,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":8,\"text\":\"Chair\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":150,\"top\":150,\"width\":31,\"height\":31,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"circle\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-15.5,\"top\":-15.5,\"width\":30,\"height\":30,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"radius\":15,\"startAngle\":0,\"endAngle\":360},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-10.5,\"top\":-4.5,\"width\":17.77,\"height\":9.04,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":8,\"text\":\"Chair\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":200,\"top\":200,\"width\":61,\"height\":36,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"rect\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-30.5,\"top\":-18,\"width\":60,\"height\":35,\"fill\":\"rgba(255, 255, 255, 0.01)\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":0,\"ry\":0},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-8.5,\"top\":-5.5,\"width\":12.34,\"height\":7.91,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":7,\"text\":\"Tent\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":200,\"top\":200,\"width\":61,\"height\":36,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"rect\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-30.5,\"top\":-18,\"width\":60,\"height\":35,\"fill\":\"rgba(255, 255, 255, 0.01)\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":0,\"ry\":0},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-8.5,\"top\":-5.5,\"width\":12.34,\"height\":7.91,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":7,\"text\":\"Tent\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":429,\"top\":245,\"width\":71,\"height\":51,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"rect\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-35.5,\"top\":-25.5,\"width\":70,\"height\":50,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":0,\"ry\":0},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-16.5,\"top\":-4.5,\"width\":28,\"height\":9.04,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":8,\"text\":\"Platform\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]}],\"background\":\"#1f2937\"}', NULL),
(19, 'v2', 'asdasdnjkob 123bjo123', 1, 1, 1, 1, 0, 123123000, 'active', NULL, NULL),
(20, 'v3', 'asdasd njk12bjk3bjk123bkj', 1, 1, 1, 1, 0, 12312300, 'active', NULL, NULL),
(21, 'zdzxcc', 'axdasdasd', 1, 1, 1, 1, 0, 1231230, 'active', '{\"version\":\"5.1.0\",\"objects\":[{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":180,\"top\":120,\"width\":45,\"height\":37,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":8.14,\"scaleY\":8.14,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"ellipse\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-22.5,\"top\":-18.5,\"width\":44,\"height\":36,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":22,\"ry\":18},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-14.5,\"top\":-8.5,\"width\":18.67,\"height\":17.09,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":7,\"text\":\"Round\\nTable\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"center\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":100,\"top\":100,\"width\":51,\"height\":41,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"rect\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-25.5,\"top\":-20.5,\"width\":50,\"height\":40,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":0,\"ry\":0},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-12.5,\"top\":-5.5,\"width\":19.86,\"height\":10.17,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":9,\"text\":\"Table\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]}],\"background\":\"#1f2937\"}', NULL),
(22, 'a', 'asdainsdubijasd', 1, 1, 1, 1, 0, 123123000, 'active', '{\"version\":\"5.1.0\",\"objects\":[{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":181,\"top\":120,\"width\":45,\"height\":37,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":5.34,\"scaleY\":5.34,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"ellipse\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-22.5,\"top\":-18.5,\"width\":44,\"height\":36,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"rx\":22,\"ry\":18},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-14.5,\"top\":-8.5,\"width\":18.67,\"height\":17.09,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":7,\"text\":\"Round\\nTable\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"center\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]},{\"type\":\"group\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":466,\"top\":178,\"width\":31,\"height\":31,\"fill\":\"rgb(0,0,0)\",\"stroke\":null,\"strokeWidth\":0,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":4.8,\"scaleY\":4.8,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"objects\":[{\"type\":\"circle\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-15.5,\"top\":-15.5,\"width\":30,\"height\":30,\"fill\":\"transparent\",\"stroke\":\"#ffffff\",\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"radius\":15,\"startAngle\":0,\"endAngle\":360},{\"type\":\"text\",\"version\":\"5.1.0\",\"originX\":\"left\",\"originY\":\"top\",\"left\":-10.5,\"top\":-4.5,\"width\":17.77,\"height\":9.04,\"fill\":\"rgba(255, 255, 255, 0.5)\",\"stroke\":null,\"strokeWidth\":1,\"strokeDashArray\":null,\"strokeLineCap\":\"butt\",\"strokeDashOffset\":0,\"strokeLineJoin\":\"miter\",\"strokeUniform\":false,\"strokeMiterLimit\":4,\"scaleX\":1,\"scaleY\":1,\"angle\":0,\"flipX\":false,\"flipY\":false,\"opacity\":1,\"shadow\":null,\"visible\":true,\"backgroundColor\":\"\",\"fillRule\":\"nonzero\",\"paintFirst\":\"fill\",\"globalCompositeOperation\":\"source-over\",\"skewX\":0,\"skewY\":0,\"fontFamily\":\"Times New Roman\",\"fontWeight\":\"normal\",\"fontSize\":8,\"text\":\"Chair\",\"underline\":false,\"overline\":false,\"linethrough\":false,\"textAlign\":\"left\",\"fontStyle\":\"normal\",\"lineHeight\":1.16,\"textBackgroundColor\":\"\",\"charSpacing\":0,\"styles\":{},\"direction\":\"ltr\",\"path\":null,\"pathStartOffset\":0,\"pathSide\":\"left\",\"pathAlign\":\"baseline\"}]}],\"background\":\"#1f2937\"}', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `package_photos`
--

CREATE TABLE `package_photos` (
  `Photo_ID` int(11) NOT NULL,
  `Package_ID` int(11) NOT NULL,
  `Photo` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `package_photos`
--

INSERT INTO `package_photos` (`Photo_ID`, `Package_ID`, `Photo`) VALUES
(33, 17, '/Eventique/api/uploads/package_17/p_6920739fa5701_0.png'),
(34, 19, 'http://localhost:3001/uploads/package_19/p_1764072599267_0.png'),
(35, 19, 'http://localhost:3001/uploads/package_19/p_1764072721130_rwgm5jetk.png'),
(36, 20, 'http://localhost:3001/uploads/package_20/p_1764073035615_0.jpeg'),
(37, 21, 'http://localhost:3001/uploads/package_21/p_1764073074131_0.jpeg'),
(38, 21, 'http://localhost:3001/uploads/package_21/p_1764073225260_xspnocsm2.png'),
(39, 22, 'http://localhost:3001/uploads/package_22/p_1764073510186_0.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `Payment_ID` int(11) NOT NULL,
  `Event_ID` int(11) DEFAULT NULL,
  `Amount` varchar(100) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `Method` varchar(100) DEFAULT NULL,
  `Status` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`Account_ID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `idx_client` (`client_id`),
  ADD KEY `idx_package` (`package_id`);

--
-- Indexes for table `design_activity_log`
--
ALTER TABLE `design_activity_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `performed_by` (`performed_by`),
  ADD KEY `idx_request` (`request_id`);

--
-- Indexes for table `design_requests`
--
ALTER TABLE `design_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_client` (`client_id`),
  ADD KEY `idx_designer` (`assigned_to`),
  ADD KEY `idx_booking` (`booking_id`);

--
-- Indexes for table `design_revisions`
--
ALTER TABLE `design_revisions`
  ADD PRIMARY KEY (`revision_id`),
  ADD KEY `revised_by` (`revised_by`),
  ADD KEY `idx_request` (`request_id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`Event_ID`),
  ADD KEY `Account_ID` (`Account_ID`),
  ADD KEY `Package_ID` (`Package_ID`);

--
-- Indexes for table `faq`
--
ALTER TABLE `faq`
  ADD PRIMARY KEY (`faq_ID`),
  ADD KEY `Account_ID` (`Account_ID`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_ID`),
  ADD KEY `Account_ID` (`Account_ID`);

--
-- Indexes for table `package`
--
ALTER TABLE `package`
  ADD PRIMARY KEY (`Package_ID`);

--
-- Indexes for table `package_photos`
--
ALTER TABLE `package_photos`
  ADD PRIMARY KEY (`Photo_ID`),
  ADD KEY `Package_ID` (`Package_ID`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`Payment_ID`),
  ADD KEY `Event_ID` (`Event_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `Account_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `booking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `design_activity_log`
--
ALTER TABLE `design_activity_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `design_requests`
--
ALTER TABLE `design_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `design_revisions`
--
ALTER TABLE `design_revisions`
  MODIFY `revision_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `Event_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faq`
--
ALTER TABLE `faq`
  MODIFY `faq_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `package`
--
ALTER TABLE `package`
  MODIFY `Package_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `package_photos`
--
ALTER TABLE `package_photos`
  MODIFY `Photo_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `Payment_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_booking_client` FOREIGN KEY (`client_id`) REFERENCES `account` (`Account_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_booking_package` FOREIGN KEY (`package_id`) REFERENCES `package` (`Package_ID`) ON DELETE CASCADE;

--
-- Constraints for table `design_activity_log`
--
ALTER TABLE `design_activity_log`
  ADD CONSTRAINT `design_activity_log_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `design_requests` (`request_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `design_activity_log_ibfk_2` FOREIGN KEY (`performed_by`) REFERENCES `account` (`Account_ID`) ON DELETE CASCADE;

--
-- Constraints for table `design_requests`
--
ALTER TABLE `design_requests`
  ADD CONSTRAINT `design_requests_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `account` (`Account_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `design_requests_ibfk_2` FOREIGN KEY (`assigned_to`) REFERENCES `account` (`Account_ID`) ON DELETE SET NULL;

--
-- Constraints for table `design_revisions`
--
ALTER TABLE `design_revisions`
  ADD CONSTRAINT `design_revisions_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `design_requests` (`request_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `design_revisions_ibfk_2` FOREIGN KEY (`revised_by`) REFERENCES `account` (`Account_ID`) ON DELETE CASCADE;

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_ibfk_1` FOREIGN KEY (`Account_ID`) REFERENCES `account` (`Account_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `events_ibfk_2` FOREIGN KEY (`Package_ID`) REFERENCES `package` (`Package_ID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `faq`
--
ALTER TABLE `faq`
  ADD CONSTRAINT `faq_ibfk_1` FOREIGN KEY (`Account_ID`) REFERENCES `account` (`Account_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`Account_ID`) REFERENCES `account` (`Account_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `package_photos`
--
ALTER TABLE `package_photos`
  ADD CONSTRAINT `package_photos_ibfk_1` FOREIGN KEY (`Package_ID`) REFERENCES `package` (`Package_ID`) ON DELETE CASCADE;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`Event_ID`) REFERENCES `events` (`Event_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
