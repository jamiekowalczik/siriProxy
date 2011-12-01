-- phpMyAdmin SQL Dump
-- version 3.3.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 01, 2011 at 04:08 PM
-- Server version: 5.1.51
-- PHP Version: 5.3.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `responses2`
--

-- --------------------------------------------------------

--
-- Table structure for table `lookups`
--

DROP TABLE IF EXISTS `lookups`;
CREATE TABLE IF NOT EXISTS `lookups` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `lookup` varchar(2048) NOT NULL,
  `response_id` int(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

--
-- Dumping data for table `lookups`
--

INSERT INTO `lookups` (`id`, `lookup`, `response_id`) VALUES
(2, 'Test Look up', 0),
(3, 'night night', 3),
(4, 'yell', 4),
(5, 'juliet', 4),
(6, 'test script', 5),
(7, 'stop apache', 6),
(8, 'start apache', 7),
(9, 'Apache status', 8),
(10, 'Who is logged in', 9),
(11, 'server uptime', 10),
(12, 'server storage', 11),
(13, 'show basement', 12),
(14, 'tell', 13),
(15, 'juliet', 13),
(16, 'do', 13),
(17, 'thing', 13),
(18, 'late night', 14);

-- --------------------------------------------------------

--
-- Table structure for table `responses`
--

DROP TABLE IF EXISTS `responses`;
CREATE TABLE IF NOT EXISTS `responses` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `response_type_id` int(255) NOT NULL,
  `response` varchar(2048) NOT NULL,
  `updated_by` varchar(512) NOT NULL,
  `updated_date` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=15 ;

--
-- Dumping data for table `responses`
--

INSERT INTO `responses` (`id`, `response_type_id`, `response`, `updated_by`, `updated_date`) VALUES
(1, 0, 'Test Response', 'jamie', '2011-11-28'),
(5, 1, 'testscript.sh', 'jamie', '2011-11-28'),
(3, 0, 'Good Night Justina!  I Love You!', 'jamie', '2011-11-28'),
(4, 0, 'Juliet! Get In Your Cage!', 'jamie', '2011-11-28'),
(6, 1, '/etc/init.d/httpd stop', 'jamie', '2011-11-28'),
(7, 1, '/etc/init.d/httpd start', 'jamie', '2011-11-28'),
(8, 1, '/etc/init.d/httpd status', 'jamie', '2011-11-28'),
(9, 1, 'who', 'jamie', '2011-11-28'),
(10, 1, 'uptime', 'jamie', '2011-11-28'),
(11, 1, 'df -hP', 'jamie', '2011-11-28'),
(12, 1, 'sh emailimg.sh', 'jamie', '2011-11-28'),
(13, 0, 'Juliet, Say I Love You!', 'jamie', '2011-11-29'),
(14, 0, 'AnneMarie, I think Jamie should work from home today!', 'jamie', '2011-11-29');

-- --------------------------------------------------------

--
-- Table structure for table `response_types`
--

DROP TABLE IF EXISTS `response_types`;
CREATE TABLE IF NOT EXISTS `response_types` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `response_name` varchar(2048) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `response_types`
--

INSERT INTO `response_types` (`id`, `response_name`) VALUES
(0, 'Term'),
(1, 'Scripts');
