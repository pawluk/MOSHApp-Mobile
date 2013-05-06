-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 24, 2013 at 11:09 PM
-- Server version: 5.5.29
-- PHP Version: 5.3.10-1ubuntu3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `c9mosh`
--
CREATE DATABASE `c9mosh` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `c9mosh`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`c9mosh`@`localhost` PROCEDURE `GetLoginUser`(IN LoginName varchar(30))
BEGIN
  SELECT
    users.*,
    user_options.p_vsbl_tm, user_options.e_vsbl_tm,
    login.login_name, login.login_pass
  FROM
    login
      INNER JOIN users ON login.u_id = users.u_id
      INNER JOIN user_options ON users.u_id = user_options.u_id
  WHERE
    login.login_name = LoginName;
END$$

CREATE DEFINER=`c9mosh`@`localhost` PROCEDURE `GetTeam`(IN TeamId int(11))
BEGIN
  SELECT
    teams.*, users.*, user_options.*
  FROM
    users
      INNER JOIN user_options ON users.u_id = user_options.u_id
      INNER JOIN team_user ON team_user.u_id = users.u_id
      INNER JOIN teams ON team_user.t_id = teams.t_id
  WHERE
    teams.t_id = TeamId;
END$$

CREATE DEFINER=`c9mosh`@`localhost` PROCEDURE `GetTeamWithUser`(IN UserId int(11))
BEGIN
  SELECT
    users.*, teams.*, user_options.*
  FROM
    team_user
      INNER JOIN teams ON team_user.t_id = teams.t_id
      INNER JOIN users ON team_user.u_id = users.u_id
      INNER JOIN user_options ON users.u_id = user_options.u_id,
        (SELECT
           team_user.t_id AS Team,
           team_user.u_id AS User
         FROM
           team_user) TeamMember
  WHERE
    TeamMember.Team = team_user.t_id AND
    TeamMember.User = UserId;
END$$

CREATE DEFINER=`c9mosh`@`localhost` PROCEDURE `GetUser`(IN UserId int(11))
BEGIN
  SELECT
    users.*,
    user_options.p_vsbl_tm, user_options.e_vsbl_tm
  FROM
    users
      INNER JOIN user_options ON users.u_id = user_options.u_id
  WHERE users.u_id = UserId;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `answers`
--

CREATE TABLE IF NOT EXISTS `answers` (
  `a_id` int(11) NOT NULL AUTO_INCREMENT,
  `q_id` int(11) DEFAULT NULL,
  `answer` text,
  PRIMARY KEY (`a_id`),
  KEY `q_id` (`q_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `answers`
--

INSERT INTO `answers` (`a_id`, `q_id`, `answer`) VALUES
(1, 1, 'georgebrown.ca'),
(2, 2, 'Yes'),
(3, 3, 'Yes'),
(4, 4, '6 months after starting school as a full-time student'),
(5, 5, 'Last week of month'),
(6, 6, 'Eight weeks after the start of your program'),
(7, 7, 'John'),
(8, 8, '12th week of every semester'),
(9, 9, 'stars.georgebrown.ca'),
(10, 10, 'Do an on-line orientation'),
(11, 11, 'Grammar and Conversation'),
(12, 12, 'Peer Assisted Learning'),
(13, 13, 'gym');

-- --------------------------------------------------------

--
-- Table structure for table `campus`
--

CREATE TABLE IF NOT EXISTS `campus` (
  `c_id` int(11) NOT NULL AUTO_INCREMENT,
  `c_name` varchar(30) NOT NULL,
  `c_lat` double DEFAULT NULL,
  `c_lng` double DEFAULT NULL,
  PRIMARY KEY (`c_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `campus`
--

INSERT INTO `campus` (`c_id`, `c_name`, `c_lat`, `c_lng`) VALUES
(1, 'St. James Campus', 43.6512279, -79.3693856),
(2, 'Casa Loma Campus', 43.6757552, -79.410208),
(3, 'Waterfront Campus', 43.643929, -79.367659);

-- --------------------------------------------------------

--
-- Table structure for table `clue`
--

CREATE TABLE IF NOT EXISTS `clue` (
  `clue_id` int(11) NOT NULL AUTO_INCREMENT,
  `clue_typ_id` int(11) DEFAULT NULL,
  `clue_text` text,
  `clue_audio` text,
  `clue_image` text,
  PRIMARY KEY (`clue_id`),
  KEY `clue_typ_id` (`clue_typ_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `clue_question`
--

CREATE TABLE IF NOT EXISTS `clue_question` (
  `clue_id` int(11) NOT NULL DEFAULT '0',
  `q_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`clue_id`,`q_id`),
  KEY `q_id` (`q_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `clue_type`
--

CREATE TABLE IF NOT EXISTS `clue_type` (
  `clue_typ_id` int(11) NOT NULL AUTO_INCREMENT,
  `typ_desc` text,
  PRIMARY KEY (`clue_typ_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `dic`
--

CREATE TABLE IF NOT EXISTS `dic` (
  `td_id` int(11) NOT NULL AUTO_INCREMENT,
  `direction` text,
  `audio` text,
  `image` text,
  `td_lat` double DEFAULT NULL,
  `td_lng` double DEFAULT NULL,
  PRIMARY KEY (`td_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=15 ;

--
-- Dumping data for table `dic`
--

INSERT INTO `dic` (`td_id`, `direction`, `audio`, `image`, `td_lat`, `td_lng`) VALUES
(1, 'The first place you will want to visit on this scavenger hunt is the International Centre. Go through the first door on west (left) side of the lobby. Walk down the hall and there you will see a desk on the left hand side.  Find and scan the MOSHapp QR-code displayed there or if you have any problems finding the QR code ask the person at the desk for directions.  Follow the instructions displayed on the phone; then send your answers using the application.', 'Checkpt1.1.mp3', 'check.1.1.png', 43.657965, -79.5647896),
(2, 'Once you have all this information you are ready to move to the next stop.  You can choose whichever order you wish to visit all the stops; it doesn''''t make a difference because they will all be directed from the center elevators on the first floor of the building.  To get there from the International Centre, walk directly across the lobby, up 5 steps past the Information Desk and the Security office into the mezzanine.  Go up another set of 8 steps, past the first Aid Centre and Tim Horton''''s on the left, through the double doors to find yourself in front of the center elevators.', 'Checkpt1.2.mp3', 'check.1.2.png', 43.658965, -79.5647896),
(3, 'Another service for the students but run by the students is the Student Association office.  To get there, walk towards the variety store at the end of the hallway.  Don''''t go in but turn right.  At the end of that hallway, you will see the Student Association office -Room 147. Go in through the glass doors. Scan the MOSHapp QR-code displayed on the door. Follow the instruction and send your answers using the MOSH application.', 'Checkpt2.1.mp3', 'check.1.1.png', 43.658965, -79.5947896),
(4, 'Another place you will be spending a lot of time during your studies at George Brown is the Library Learning Commons.  To get there from the center elevators, walk through the double doors right by the elevators.  Immediately on your left is the entrance to the library.  Go inside to the front desk.  You will need your student ID card for this exercise.  Scan the QR-code displayed there or ask for assistance with finding the MOSHapp QR code. Follow the instruction and send your answers using the application.', 'Checkpt3.1.mp3', 'check.1.2.png', 43.658965, -79.5947896),
(5, 'When you begin your studies at George Brown you will need to buy your textbooks and other materials at the Bookstore.  Getting there from the center elevators is quite easy.  Go through the double doors, past the library on your left and Tim Horton''''s on the right.  Just past Tim Horton''''s you will go down 4 steps; then immediately on your left you will see the bookstore.  Scan the MOSHapp QR-code and follow the instruction provided in the recording.', 'Checkpt4.1.mp3', 'check.1.1.png', 43.658965, -79.5947896),
(6, 'Go inside and find a hoodie in the colour you like.  Try it on and have your partner snap a picture of you in it; then send it using the application.  If you don''''t want to have your picture posted on the website, just have your partner take your picture without your face showing.', 'Checkpt4.2.mp3', 'check.1.2.png', 43.658965, -79.5947896),
(7, 'The School of Business has two main offices:  one in SJA and one in SJC (The Centre for Financial Services Education).  To get to the SJA office, take the elevator to the third floor.  When you get out of the elevator, turn left and walk to the end of the hallway; then turn right. This is the A hallway. Take this hallway to the very end and walk through the double doors at 313A.  You are now in the Business office.  Scan the MOSHapp QR-code displayed in the Business office and follow the instructions that appear on your phone; then send your answers using the application.', 'Checkpt5.1.mp3', 'check.1.1.png', 43.658965, -79.5947896),
(8, 'Now turn around and walk completely to the other end of hallway A.  Go through the doors, down the stairs to the first floor, and then outside.  Being very careful, cross the street.  It is safest to cross Adelaide Street at the lights you see on your left.  Once you are on the other side of the street you will see a walkway directly west of the Hospitality building.  Take that walkway to the CFSE, Building C, go through the glass doors and turn left into the other Business office.  Once again go to the front desk, scan the MOSHapp QR code and use the MOSH app to submit the answers you received from the people at the front desk.', 'Checkpt5.2.mp3', 'check.1.2.png', 43.658965, -79.5947896),
(9, 'One of the services you will definitely want to use on a regular basis is the Tutoring and Learning Centre, TLC (430A).  Take the center elevators to the 4th floor. As you get out of the elevators, turn left and walk to the end of the hallway; then turn left again.  Before you go through the doors at the end of the hallway, you will see the Tutoring and Learning Centre on the right.  Go inside and scan the MOSHapp QR-code displayed at the front desk of the Tutoring and Learning Centre. Follow the instruction and send your answers using the application. To get your answers, speak to the person who is at the front desk. Ask this person about the services being offered.', 'Checkpt6.1.mp3', 'check.1.1.png', 43.658965, -79.5947896),
(10, 'One of the great services George Brown provides for its students is the Student Affairs on the 5th floor, 582C.  This is different from the Student Association, so don''''t get them confused. This office provides support for students in job searching, housing, counseling, and studying techniques.  To get to the Student Affairs office, take the center elevators to the 5th floor.  When the elevator doors open, walk straight ahead, past the lounge/study area to the hallway at the end.  Turn left.  Halfway down that hallway you will see the Student Affairs on the right.  Go in and walk to the front desk.  Scan the QR-code and follow the instructions in the recording', 'Checkpt7.1.mp3', 'check.1.2.png', 43.658965, -79.5947896),
(11, 'In front of the desk you will see a stand that is holding a number of information sheets.  Look for the sheet titled “Welcome to Student Affairs.”  Take a copy of that sheet and bring it with you. Answer the question shown in the application.', 'Checkpt7.2.mp3', 'check.1.1.png', 43.658965, -79.5947896),
(12, 'A great way to meet people and keep in shape while at George Brown is to go to the gym.  Even getting there is part of the warm-up.  You have two different ways to do this.  The easy way is to take the center elevators to the fifth floor.  That is the highest it will go.  Then directly in front of the elevator is a set of stairs that will take you to the 6th floor.  Climb the stairs, go through the door to the front desk, which is directly on your left. That''''s the easy way. The harder way is to take the stairs from the first floor all the way to the 6th floor, but you''''ve also had a good cardio workout at the same time. Once you are at the gym scan the QR-code and follow the instructions. You might want to ask the person at the desk for help', 'Checkpt8.1.mp3', 'check.1.2.png', 43.658965, -79.5947896),
(13, 'There are many other services available at George Brown, but now you need to go outside the college to discover some of the services that George Brown students use.  To get a quick fix of mojo, go outside through the main doors on King Street. Walk west to the stoplight at King and George Streets.  Cross the street twice to get to Starbucks on the south-west corner of the street.  Enter the store and scan the MOSHapp QR-code displayed there. Follow the instructions. One of the servers will be able to provide you the necessary information.', 'Checkpt9.1.mp3', 'check.1.1.png', 43.658965, -79.5947896),
(14, 'Another very important service you will need to use is the bank.  George Brown works closely with Scotia Bank.  To get to this bank from George Brown, walk east on King Street (away from the CN Tower).  Cross over Sherbourne Street and cross again to the south side of King Street. Continue walking east till you see the Scotia Bank sign.  Go inside and scan the QR-code at the Customer Service desk. Follow the instructions on your phone. Ask the person at the Customer Service desk for the necessary information.', 'Checkpt10.1.mp3', 'check.1.2.png', 43.658965, -79.5947896);

-- --------------------------------------------------------

--
-- Table structure for table `dic_question`
--

CREATE TABLE IF NOT EXISTS `dic_question` (
  `td_id` int(11) NOT NULL DEFAULT '0',
  `q_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`td_id`,`q_id`),
  KEY `q_id` (`q_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `dic_question`
--

INSERT INTO `dic_question` (`td_id`, `q_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(3, 5),
(3, 6),
(4, 7),
(7, 8),
(8, 9),
(9, 10),
(9, 11),
(11, 12),
(12, 13),
(12, 14),
(12, 15),
(13, 16),
(13, 17),
(13, 18),
(14, 19),
(14, 20);

-- --------------------------------------------------------

--
-- Table structure for table `game`
--

CREATE TABLE IF NOT EXISTS `game` (
  `g_id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `finis_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`g_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `game`
--

INSERT INTO `game` (`g_id`, `start_time`, `finis_time`) VALUES
(1, '2013-01-28 13:15:23', '2013-02-28 13:15:23');

-- --------------------------------------------------------

--
-- Table structure for table `game_task`
--

CREATE TABLE IF NOT EXISTS `game_task` (
  `tsk_id` int(11) NOT NULL DEFAULT '0',
  `g_id` int(11) NOT NULL DEFAULT '0',
  `prv_tsk_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`tsk_id`,`g_id`),
  KEY `prv_tsk_id` (`prv_tsk_id`),
  KEY `g_id` (`g_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `game_task`
--

INSERT INTO `game_task` (`tsk_id`, `g_id`, `prv_tsk_id`) VALUES
(1, 1, NULL),
(2, 1, 1),
(6, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE IF NOT EXISTS `login` (
  `login_name` varchar(30) NOT NULL,
  `login_pass` varchar(64) NOT NULL,
  `u_id` int(11) DEFAULT NULL,
  `p_id` int(11) DEFAULT '0',
  UNIQUE KEY `login_name` (`login_name`),
  UNIQUE KEY `u_id` (`u_id`),
  KEY `p_id` (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`login_name`, `login_pass`, `u_id`, `p_id`) VALUES
('aga', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 11, NULL),
('andrei', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 16, NULL),
('burns3', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 9, NULL),
('hkim', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 7, NULL),
('jason', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 15, NULL),
('jordan', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 17, NULL),
('jseo', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 4, NULL),
('kraay', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 12, NULL),
('pawluk', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 10, NULL),
('sam', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 14, NULL),
('schoi', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 5, NULL),
('sjung', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 3, NULL),
('slee', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 2, NULL),
('sullivan6', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 13, NULL),
('thwang', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 1, NULL),
('tkim', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 0, NULL),
('yim', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 8, NULL),
('ykwon', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 6, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE IF NOT EXISTS `permissions` (
  `p_id` int(11) NOT NULL,
  `p_desc` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`p_id`, `p_desc`) VALUES
(0, 'Regular user, can play game'),
(1, 'Master Admin, has all the power ower game and players.'),
(2, 'Editor, can change add new tasks and teams'),
(3, 'Admin, has ability that editor can do plus able to ban users'),
(4, 'Banned User');

-- --------------------------------------------------------

--
-- Table structure for table `progress`
--

CREATE TABLE IF NOT EXISTS `progress` (
  `t_id` int(11) DEFAULT NULL,
  `u_id` int(11) DEFAULT NULL,
  `tsk_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `currenttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `pk_progress_rule` (`t_id`,`u_id`,`tsk_id`,`status`),
  KEY `tsk_id` (`tsk_id`),
  KEY `u_id` (`u_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `progress`
--

INSERT INTO `progress` (`t_id`, `u_id`, `tsk_id`, `status`, `currenttime`) VALUES
(1, 5, 1, 1, '2013-02-17 16:43:11'),
(1, 5, 1, 2, '2013-02-17 16:43:33'),
(1, 5, 2, 1, '2013-02-17 16:44:01'),
(1, 5, 2, 2, '2013-02-17 16:44:22'),
(1, 5, 6, 1, '2013-02-17 16:44:28'),
(1, 5, 6, 2, '2013-02-17 16:45:09'),
(2, 7, 1, 1, '2013-02-17 17:03:16'),
(2, 7, 1, 2, '2013-02-17 17:03:33'),
(2, 7, 2, 1, '2013-02-17 17:03:39'),
(2, 7, 2, 2, '2013-02-17 17:03:52'),
(2, 7, 6, 1, '2013-02-17 17:03:57'),
(2, 7, 6, 2, '2013-02-17 17:04:10'),
(5, 15, 1, 1, '2013-02-18 00:36:05'),
(5, 15, 1, 2, '2013-02-18 00:36:44'),
(5, 15, 2, 1, '2013-02-18 00:37:00'),
(5, 15, 2, 2, '2013-02-18 00:37:31'),
(5, 15, 6, 1, '2013-02-18 00:37:40'),
(5, 15, 6, 2, '2013-02-18 00:38:09'),
(1, 2, 1, 1, '2013-02-18 19:01:21'),
(4, 14, 1, 1, '2013-02-21 03:55:38'),
(3, 10, 1, 1, '2013-02-21 16:04:55'),
(1, 3, 1, 1, '2013-02-24 16:04:02'),
(1, 3, 1, 2, '2013-02-24 16:05:53'),
(1, 3, 2, 1, '2013-02-24 16:06:07'),
(1, 3, 2, 2, '2013-02-24 16:06:33'),
(1, 3, 6, 1, '2013-02-24 16:06:40'),
(1, 3, 6, 2, '2013-02-24 16:07:33');

-- --------------------------------------------------------

--
-- Table structure for table `question_type`
--

CREATE TABLE IF NOT EXISTS `question_type` (
  `q_typ_id` int(11) NOT NULL AUTO_INCREMENT,
  `typ_desc` text,
  PRIMARY KEY (`q_typ_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `question_type`
--

INSERT INTO `question_type` (`q_typ_id`, `typ_desc`) VALUES
(1, 'Regular question answer type'),
(2, 'Multichoice question type');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE IF NOT EXISTS `questions` (
  `q_id` int(11) NOT NULL AUTO_INCREMENT,
  `q_typ_id` int(11) DEFAULT NULL,
  `q_text` text,
  PRIMARY KEY (`q_id`),
  KEY `q_typ_id` (`q_typ_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=21 ;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`q_id`, `q_typ_id`, `q_text`) VALUES
(1, 1, 'Where can I find out more about scholarships for International students?'),
(2, 1, 'Can I work in Canada while I am going to school? '),
(3, 1, 'Are International students eligible to work on campus at the beginning of the school year? '),
(4, 2, 'When can I apply for my off-campus work permit?~&~3 months before starting school as a full-time student~3 months after starting school as a full-time student~6 months after starting school as a full-time student~12 months after starting school as a full-time student'),
(5, 2, 'When can I buy my metro pass for the month?~&~Whenever I feel like it~Last week of month~First week of month~The 15th of each month'),
(6, 2, 'When will I be able to pick up my health benefits card?~&~Eight weeks after the start of your program~2 weeks after the start of your program~4 weeks after the start of your program'),
(7, 1, 'I am interested in accessing the library from home so I need to make sure that my student card works.  Could you please check to make sure my card is working and active?<br/>What is the name of the person who helped you?'),
(8, 1, 'What is your name?<br/>What is the last date I can drop a course without penalty?'),
(9, 1, 'What is your name?<br/>What is the website that gives information about bursaries available for students?'),
(10, 2, 'What do I need to do to use these services?~&~Nothing, just walk in and work with a tutor~Do an on-line orientation~Pay the registration fee before beginning~Agree to buy the tutor a coffee each time you use the centre'),
(11, 2, 'What are the special sessions that are offered?~&~Writing Skills for Business Concepts~Accounting Conversation~Grammar and Conversation~Personal Finance for International Students'),
(12, 1, 'What does PAL stand for?'),
(13, 1, 'What facilities can I use for free with my student card?'),
(14, 1, 'What are the special fitness classes that are given?<br/>Name one that you would be interested in.'),
(15, 1, 'How much does it cost to join these special classes?'),
(16, 1, 'What is the season special?'),
(17, 1, 'How much does it cost?'),
(18, 1, 'What is your name so I can tell my partner whom I spoke with?'),
(19, 1, 'What do I need to do to open an account with Scotia Bank?'),
(20, 1, 'Can I use this bank even if I don''t have an account with them?');

-- --------------------------------------------------------

--
-- Table structure for table `responses`
--

CREATE TABLE IF NOT EXISTS `responses` (
  `r_id` int(11) NOT NULL AUTO_INCREMENT,
  `t_id` int(11) DEFAULT NULL,
  `u_id` int(11) DEFAULT NULL,
  `tsk_id` int(11) DEFAULT NULL,
  `q_id` int(11) DEFAULT NULL,
  `q_status` int(11) DEFAULT '0',
  `response` varchar(150) DEFAULT NULL,
  `location` text,
  PRIMARY KEY (`r_id`),
  UNIQUE KEY `pk_response_rule` (`u_id`,`tsk_id`,`q_id`,`response`),
  KEY `t_id` (`t_id`),
  KEY `tsk_id` (`tsk_id`),
  KEY `q_id` (`q_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=33 ;

--
-- Dumping data for table `responses`
--

INSERT INTO `responses` (`r_id`, `t_id`, `u_id`, `tsk_id`, `q_id`, `q_status`, `response`, `location`) VALUES
(1, 1, 5, 1, 1, 1, 'yes', ''),
(2, 1, 5, 1, 2, 1, 'yes', ''),
(3, 1, 5, 1, 3, 1, 'yes', ''),
(4, 1, 5, 1, 4, 1, 'yes', ''),
(5, 1, 5, 2, 5, 1, 'Last week of month', ''),
(6, 1, 5, 2, 6, 1, 'yes', ''),
(7, 1, 5, 6, 10, 1, 'Do an on-line orientation that explains how the centre works', ''),
(8, 1, 5, 6, 11, 1, 'Grammar and Conversation', ''),
(9, 2, 7, 1, 1, 1, 'yes', ''),
(10, 2, 7, 1, 2, 1, 'yes', ''),
(11, 2, 7, 1, 3, 1, 'yes', ''),
(12, 2, 7, 1, 4, 1, 'yes', ''),
(13, 2, 7, 2, 5, 1, 'Last week of month', ''),
(14, 2, 7, 2, 6, 1, 'yes', ''),
(15, 2, 7, 6, 10, 1, 'Do an on-line orientation', ''),
(16, 2, 7, 6, 11, 1, 'Grammar and Conversation', ''),
(17, 5, 15, 1, 1, 1, 'yes', ''),
(18, 5, 15, 1, 2, 1, 'yes', ''),
(19, 5, 15, 1, 3, 1, 'yes', ''),
(20, 5, 15, 1, 4, 1, 'yes', ''),
(21, 5, 15, 2, 5, 1, 'Last week of month', ''),
(22, 5, 15, 2, 6, 1, 'yes', ''),
(23, 5, 15, 6, 10, 1, 'Do an on-line orientation', ''),
(24, 5, 15, 6, 11, 1, 'Grammar and Conversation', ''),
(25, 1, 3, 1, 1, 1, 'georgebrown.ca', ''),
(26, 1, 3, 1, 2, 1, 'yes', ''),
(27, 1, 3, 1, 3, 1, 'yes', ''),
(28, 1, 3, 1, 4, 1, '6 months after starting school as a full-time student', ''),
(29, 1, 3, 2, 5, 1, 'Last week of month', ''),
(30, 1, 3, 2, 6, 1, 'Eight weeks after the start of your program', ''),
(31, 1, 3, 6, 10, 1, 'Do an on-line orientation', ''),
(32, 1, 3, 6, 11, 1, 'Grammar and Conversation', '');

-- --------------------------------------------------------

--
-- Table structure for table `task_dic`
--

CREATE TABLE IF NOT EXISTS `task_dic` (
  `tsk_id` int(11) NOT NULL DEFAULT '0',
  `td_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tsk_id`,`td_id`),
  KEY `td_id` (`td_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `task_dic`
--

INSERT INTO `task_dic` (`tsk_id`, `td_id`) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(4, 6),
(5, 7),
(5, 8),
(6, 9),
(7, 10),
(7, 11),
(8, 12),
(9, 13),
(10, 14);

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE IF NOT EXISTS `tasks` (
  `tsk_id` int(11) NOT NULL AUTO_INCREMENT,
  `tsk_name` varchar(100) DEFAULT NULL,
  `secret_id` varchar(30) NOT NULL,
  `c_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`tsk_id`),
  UNIQUE KEY `secret_id` (`secret_id`),
  KEY `c_id` (`c_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`tsk_id`, `tsk_name`, `secret_id`, `c_id`) VALUES
(1, 'International Centre', 'ABC123', 3),
(2, 'Student Association', 'CBA123', 3),
(3, 'Library Learning Commons', 'BCA123', 3),
(4, 'Bookstore', 'BAC123', 3),
(5, 'School of Business', 'ACB123', 3),
(6, 'Tutoring and Learning Centre', 'CAB123', 3),
(7, 'Student Affairs', 'ABC213', 3),
(8, 'Gym', 'ACB231', 3),
(9, 'Starbucks', 'CAB132', 3),
(10, 'Scotia Bank', 'ABC321', 3);

-- --------------------------------------------------------

--
-- Table structure for table `team_game`
--

CREATE TABLE IF NOT EXISTS `team_game` (
  `t_id` int(11) NOT NULL DEFAULT '0',
  `g_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`t_id`,`g_id`),
  KEY `g_id` (`g_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `team_game`
--

INSERT INTO `team_game` (`t_id`, `g_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `team_user`
--

CREATE TABLE IF NOT EXISTS `team_user` (
  `t_id` int(11) NOT NULL DEFAULT '0',
  `u_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`t_id`,`u_id`),
  KEY `u_id` (`u_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `team_user`
--

INSERT INTO `team_user` (`t_id`, `u_id`) VALUES
(0, 0),
(0, 1),
(1, 2),
(1, 3),
(0, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8),
(3, 9),
(3, 10),
(3, 11),
(4, 12),
(4, 13),
(4, 14),
(5, 15),
(5, 16),
(5, 17);

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE IF NOT EXISTS `teams` (
  `t_id` int(11) NOT NULL AUTO_INCREMENT,
  `t_name` varchar(30) NOT NULL,
  `t_chat_id` varchar(24) NOT NULL,
  PRIMARY KEY (`t_id`),
  UNIQUE KEY `t_name` (`t_name`),
  UNIQUE KEY `t_chat_id` (`t_chat_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`t_id`, `t_name`, `t_chat_id`) VALUES
(0, 'TTS', 'TTS'),
(1, 'SJS', 'SJS'),
(2, 'YHY', 'YHY'),
(3, 'Team 1', 'Team 1'),
(4, 'Team 2', 'Team 2'),
(5, 'Team 3', 'Team 3');

-- --------------------------------------------------------

--
-- Table structure for table `user_options`
--

CREATE TABLE IF NOT EXISTS `user_options` (
  `u_id` int(11) NOT NULL DEFAULT '0',
  `p_vsbl_tm` tinyint(1) DEFAULT '1',
  `e_vsbl_tm` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`u_id`),
  UNIQUE KEY `u_id` (`u_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_options`
--

INSERT INTO `user_options` (`u_id`, `p_vsbl_tm`, `e_vsbl_tm`) VALUES
(0, 1, 1),
(1, 0, 1),
(2, 1, 0),
(3, 1, 1),
(4, 1, 1),
(5, 1, 0),
(6, 0, 1),
(7, 0, 0),
(8, 1, 1),
(9, 1, 1),
(10, 0, 1),
(11, 1, 0),
(12, 1, 1),
(13, 1, 1),
(14, 1, 0),
(15, 0, 1),
(16, 0, 1),
(17, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `u_id` int(11) NOT NULL AUTO_INCREMENT,
  `u_nickname` varchar(30) DEFAULT NULL,
  `u_fname` varchar(30) DEFAULT NULL,
  `u_lastname` varchar(30) DEFAULT NULL,
  `u_email` varchar(100) DEFAULT NULL,
  `u_phone` varchar(10) DEFAULT NULL,
  `s_num` varchar(9) NOT NULL,
  PRIMARY KEY (`u_id`),
  UNIQUE KEY `s_num` (`s_num`),
  UNIQUE KEY `u_nickname` (`u_nickname`),
  UNIQUE KEY `u_email` (`u_email`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`u_id`, `u_nickname`, `u_fname`, `u_lastname`, `u_email`, `u_phone`, `s_num`) VALUES
(0, 'byuntaeng', 'Taeyeon', 'Kim', 'tkim@example.com', '6470010101', '100123456'),
(1, 'fany', 'Tiffany', 'Hwang', 'fany@example.com', '6470020202', '100987654'),
(2, 'sunny', 'Soonkyu', 'Lee', 'soonkyu@example.com', '4160030303', '100159753'),
(3, 'sica', 'Sooyeon', 'Jung', 'lazysica@example.com', '6470040404', '100456852'),
(4, 'seororo', 'Joohyun', 'Seo', 'seohyun@example.com', '6470050505', '100147896'),
(5, 'syoung', 'Sooyoung', 'Choi', 'dj.syoung@example.com', '6470060606', '100456963'),
(6, 'kwonyul', 'Yuri', 'Kwon', 'kyuri@example.com', '4160070707', '100987123'),
(7, 'hyoraengi', 'Hyoyeon', 'Kim', 'hyo@example.com', '6470080808', '100741963'),
(8, 'yoong', 'Yoona', 'Im', 'imyoona@example.com', '4160090909', '101793158'),
(9, 'burns3', 'burns3', 'user1', 'user1@example.com', '6471020202', '102987654'),
(10, 'pawluk', 'pawluk', 'user2', 'user2@example.com', '4162030303', '103159753'),
(11, 'aga', 'aga', 'user3', 'user3@example.com', '6473040404', '104456852'),
(12, 'kraay', 'kraay', 'user4', 'user4@example.com', '6474050505', '105147896'),
(13, 'sullivan6', 'sullivan6', 'user5', 'user5@example.com', '6475060606', '106456963'),
(14, 'Sam', 'Sam', 'user6', 'user6@example.com', '4166070707', '107987123'),
(15, 'jason', 'jason', 'user7', 'user7@example.com', '6477080808', '108741963'),
(16, 'andrei', 'andrei', 'user8', 'user8@example.com', '4168090909', '109793158'),
(17, 'jordan', 'jordan', 'user9', 'user9@example.com', '4169090909', '110793158');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `answers`
--
ALTER TABLE `answers`
  ADD CONSTRAINT `answers_ibfk_1` FOREIGN KEY (`q_id`) REFERENCES `questions` (`q_id`);

--
-- Constraints for table `clue`
--
ALTER TABLE `clue`
  ADD CONSTRAINT `clue_ibfk_1` FOREIGN KEY (`clue_typ_id`) REFERENCES `clue_type` (`clue_typ_id`);

--
-- Constraints for table `clue_question`
--
ALTER TABLE `clue_question`
  ADD CONSTRAINT `clue_question_ibfk_1` FOREIGN KEY (`clue_id`) REFERENCES `clue` (`clue_id`),
  ADD CONSTRAINT `clue_question_ibfk_2` FOREIGN KEY (`q_id`) REFERENCES `questions` (`q_id`);

--
-- Constraints for table `dic_question`
--
ALTER TABLE `dic_question`
  ADD CONSTRAINT `dic_question_ibfk_1` FOREIGN KEY (`td_id`) REFERENCES `dic` (`td_id`),
  ADD CONSTRAINT `dic_question_ibfk_2` FOREIGN KEY (`q_id`) REFERENCES `questions` (`q_id`);

--
-- Constraints for table `game_task`
--
ALTER TABLE `game_task`
  ADD CONSTRAINT `game_task_ibfk_1` FOREIGN KEY (`tsk_id`) REFERENCES `tasks` (`tsk_id`),
  ADD CONSTRAINT `game_task_ibfk_2` FOREIGN KEY (`prv_tsk_id`) REFERENCES `tasks` (`tsk_id`),
  ADD CONSTRAINT `game_task_ibfk_3` FOREIGN KEY (`g_id`) REFERENCES `game` (`g_id`);

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `users` (`u_id`),
  ADD CONSTRAINT `login_ibfk_2` FOREIGN KEY (`p_id`) REFERENCES `permissions` (`p_id`);

--
-- Constraints for table `progress`
--
ALTER TABLE `progress`
  ADD CONSTRAINT `progress_ibfk_1` FOREIGN KEY (`t_id`) REFERENCES `teams` (`t_id`),
  ADD CONSTRAINT `progress_ibfk_2` FOREIGN KEY (`tsk_id`) REFERENCES `tasks` (`tsk_id`),
  ADD CONSTRAINT `progress_ibfk_3` FOREIGN KEY (`u_id`) REFERENCES `users` (`u_id`);

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`q_typ_id`) REFERENCES `question_type` (`q_typ_id`);

--
-- Constraints for table `responses`
--
ALTER TABLE `responses`
  ADD CONSTRAINT `responses_ibfk_1` FOREIGN KEY (`t_id`) REFERENCES `teams` (`t_id`),
  ADD CONSTRAINT `responses_ibfk_2` FOREIGN KEY (`tsk_id`) REFERENCES `tasks` (`tsk_id`),
  ADD CONSTRAINT `responses_ibfk_3` FOREIGN KEY (`u_id`) REFERENCES `users` (`u_id`),
  ADD CONSTRAINT `responses_ibfk_4` FOREIGN KEY (`q_id`) REFERENCES `questions` (`q_id`);

--
-- Constraints for table `task_dic`
--
ALTER TABLE `task_dic`
  ADD CONSTRAINT `task_dic_ibfk_1` FOREIGN KEY (`tsk_id`) REFERENCES `tasks` (`tsk_id`),
  ADD CONSTRAINT `task_dic_ibfk_2` FOREIGN KEY (`td_id`) REFERENCES `dic` (`td_id`);

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`c_id`) REFERENCES `campus` (`c_id`);

--
-- Constraints for table `team_game`
--
ALTER TABLE `team_game`
  ADD CONSTRAINT `team_game_ibfk_1` FOREIGN KEY (`t_id`) REFERENCES `teams` (`t_id`),
  ADD CONSTRAINT `team_game_ibfk_2` FOREIGN KEY (`g_id`) REFERENCES `game` (`g_id`);

--
-- Constraints for table `team_user`
--
ALTER TABLE `team_user`
  ADD CONSTRAINT `team_user_ibfk_1` FOREIGN KEY (`t_id`) REFERENCES `teams` (`t_id`),
  ADD CONSTRAINT `team_user_ibfk_2` FOREIGN KEY (`u_id`) REFERENCES `users` (`u_id`);

--
-- Constraints for table `user_options`
--
ALTER TABLE `user_options`
  ADD CONSTRAINT `user_options_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `users` (`u_id`);
--
-- Database: `information_schema`
--
CREATE DATABASE `information_schema` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `information_schema`;

-- --------------------------------------------------------

--
-- Table structure for table `CHARACTER_SETS`
--

CREATE TEMPORARY TABLE `CHARACTER_SETS` (
  `CHARACTER_SET_NAME` varchar(32) NOT NULL DEFAULT '',
  `DEFAULT_COLLATE_NAME` varchar(32) NOT NULL DEFAULT '',
  `DESCRIPTION` varchar(60) NOT NULL DEFAULT '',
  `MAXLEN` bigint(3) NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `CHARACTER_SETS`
--

INSERT INTO `CHARACTER_SETS` (`CHARACTER_SET_NAME`, `DEFAULT_COLLATE_NAME`, `DESCRIPTION`, `MAXLEN`) VALUES
('big5', 'big5_chinese_ci', 'Big5 Traditional Chinese', 2),
('dec8', 'dec8_swedish_ci', 'DEC West European', 1),
('cp850', 'cp850_general_ci', 'DOS West European', 1),
('hp8', 'hp8_english_ci', 'HP West European', 1),
('koi8r', 'koi8r_general_ci', 'KOI8-R Relcom Russian', 1),
('latin1', 'latin1_swedish_ci', 'cp1252 West European', 1),
('latin2', 'latin2_general_ci', 'ISO 8859-2 Central European', 1),
('swe7', 'swe7_swedish_ci', '7bit Swedish', 1),
('ascii', 'ascii_general_ci', 'US ASCII', 1),
('ujis', 'ujis_japanese_ci', 'EUC-JP Japanese', 3),
('sjis', 'sjis_japanese_ci', 'Shift-JIS Japanese', 2),
('hebrew', 'hebrew_general_ci', 'ISO 8859-8 Hebrew', 1),
('tis620', 'tis620_thai_ci', 'TIS620 Thai', 1),
('euckr', 'euckr_korean_ci', 'EUC-KR Korean', 2),
('koi8u', 'koi8u_general_ci', 'KOI8-U Ukrainian', 1),
('gb2312', 'gb2312_chinese_ci', 'GB2312 Simplified Chinese', 2),
('greek', 'greek_general_ci', 'ISO 8859-7 Greek', 1),
('cp1250', 'cp1250_general_ci', 'Windows Central European', 1),
('gbk', 'gbk_chinese_ci', 'GBK Simplified Chinese', 2),
('latin5', 'latin5_turkish_ci', 'ISO 8859-9 Turkish', 1),
('armscii8', 'armscii8_general_ci', 'ARMSCII-8 Armenian', 1),
('utf8', 'utf8_general_ci', 'UTF-8 Unicode', 3),
('ucs2', 'ucs2_general_ci', 'UCS-2 Unicode', 2),
('cp866', 'cp866_general_ci', 'DOS Russian', 1),
('keybcs2', 'keybcs2_general_ci', 'DOS Kamenicky Czech-Slovak', 1),
('macce', 'macce_general_ci', 'Mac Central European', 1),
('macroman', 'macroman_general_ci', 'Mac West European', 1),
('cp852', 'cp852_general_ci', 'DOS Central European', 1),
('latin7', 'latin7_general_ci', 'ISO 8859-13 Baltic', 1),
('utf8mb4', 'utf8mb4_general_ci', 'UTF-8 Unicode', 4),
('cp1251', 'cp1251_general_ci', 'Windows Cyrillic', 1),
('utf16', 'utf16_general_ci', 'UTF-16 Unicode', 4),
('cp1256', 'cp1256_general_ci', 'Windows Arabic', 1),
('cp1257', 'cp1257_general_ci', 'Windows Baltic', 1),
('utf32', 'utf32_general_ci', 'UTF-32 Unicode', 4),
('binary', 'binary', 'Binary pseudo charset', 1),
('geostd8', 'geostd8_general_ci', 'GEOSTD8 Georgian', 1),
('cp932', 'cp932_japanese_ci', 'SJIS for Windows Japanese', 2),
('eucjpms', 'eucjpms_japanese_ci', 'UJIS for Windows Japanese', 3);

-- --------------------------------------------------------

--
-- Table structure for table `COLLATIONS`
--

CREATE TEMPORARY TABLE `COLLATIONS` (
  `COLLATION_NAME` varchar(32) NOT NULL DEFAULT '',
  `CHARACTER_SET_NAME` varchar(32) NOT NULL DEFAULT '',
  `ID` bigint(11) NOT NULL DEFAULT '0',
  `IS_DEFAULT` varchar(3) NOT NULL DEFAULT '',
  `IS_COMPILED` varchar(3) NOT NULL DEFAULT '',
  `SORTLEN` bigint(3) NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `COLLATIONS`
--

INSERT INTO `COLLATIONS` (`COLLATION_NAME`, `CHARACTER_SET_NAME`, `ID`, `IS_DEFAULT`, `IS_COMPILED`, `SORTLEN`) VALUES
('big5_chinese_ci', 'big5', 1, 'Yes', 'Yes', 1),
('big5_bin', 'big5', 84, '', 'Yes', 1),
('dec8_swedish_ci', 'dec8', 3, 'Yes', 'Yes', 1),
('dec8_bin', 'dec8', 69, '', 'Yes', 1),
('cp850_general_ci', 'cp850', 4, 'Yes', 'Yes', 1),
('cp850_bin', 'cp850', 80, '', 'Yes', 1),
('hp8_english_ci', 'hp8', 6, 'Yes', 'Yes', 1),
('hp8_bin', 'hp8', 72, '', 'Yes', 1),
('koi8r_general_ci', 'koi8r', 7, 'Yes', 'Yes', 1),
('koi8r_bin', 'koi8r', 74, '', 'Yes', 1),
('latin1_german1_ci', 'latin1', 5, '', 'Yes', 1),
('latin1_swedish_ci', 'latin1', 8, 'Yes', 'Yes', 1),
('latin1_danish_ci', 'latin1', 15, '', 'Yes', 1),
('latin1_german2_ci', 'latin1', 31, '', 'Yes', 2),
('latin1_bin', 'latin1', 47, '', 'Yes', 1),
('latin1_general_ci', 'latin1', 48, '', 'Yes', 1),
('latin1_general_cs', 'latin1', 49, '', 'Yes', 1),
('latin1_spanish_ci', 'latin1', 94, '', 'Yes', 1),
('latin2_czech_cs', 'latin2', 2, '', 'Yes', 4),
('latin2_general_ci', 'latin2', 9, 'Yes', 'Yes', 1),
('latin2_hungarian_ci', 'latin2', 21, '', 'Yes', 1),
('latin2_croatian_ci', 'latin2', 27, '', 'Yes', 1),
('latin2_bin', 'latin2', 77, '', 'Yes', 1),
('swe7_swedish_ci', 'swe7', 10, 'Yes', 'Yes', 1),
('swe7_bin', 'swe7', 82, '', 'Yes', 1),
('ascii_general_ci', 'ascii', 11, 'Yes', 'Yes', 1),
('ascii_bin', 'ascii', 65, '', 'Yes', 1),
('ujis_japanese_ci', 'ujis', 12, 'Yes', 'Yes', 1),
('ujis_bin', 'ujis', 91, '', 'Yes', 1),
('sjis_japanese_ci', 'sjis', 13, 'Yes', 'Yes', 1),
('sjis_bin', 'sjis', 88, '', 'Yes', 1),
('hebrew_general_ci', 'hebrew', 16, 'Yes', 'Yes', 1),
('hebrew_bin', 'hebrew', 71, '', 'Yes', 1),
('tis620_thai_ci', 'tis620', 18, 'Yes', 'Yes', 4),
('tis620_bin', 'tis620', 89, '', 'Yes', 1),
('euckr_korean_ci', 'euckr', 19, 'Yes', 'Yes', 1),
('euckr_bin', 'euckr', 85, '', 'Yes', 1),
('koi8u_general_ci', 'koi8u', 22, 'Yes', 'Yes', 1),
('koi8u_bin', 'koi8u', 75, '', 'Yes', 1),
('gb2312_chinese_ci', 'gb2312', 24, 'Yes', 'Yes', 1),
('gb2312_bin', 'gb2312', 86, '', 'Yes', 1),
('greek_general_ci', 'greek', 25, 'Yes', 'Yes', 1),
('greek_bin', 'greek', 70, '', 'Yes', 1),
('cp1250_general_ci', 'cp1250', 26, 'Yes', 'Yes', 1),
('cp1250_czech_cs', 'cp1250', 34, '', 'Yes', 2),
('cp1250_croatian_ci', 'cp1250', 44, '', 'Yes', 1),
('cp1250_bin', 'cp1250', 66, '', 'Yes', 1),
('cp1250_polish_ci', 'cp1250', 99, '', 'Yes', 1),
('gbk_chinese_ci', 'gbk', 28, 'Yes', 'Yes', 1),
('gbk_bin', 'gbk', 87, '', 'Yes', 1),
('latin5_turkish_ci', 'latin5', 30, 'Yes', 'Yes', 1),
('latin5_bin', 'latin5', 78, '', 'Yes', 1),
('armscii8_general_ci', 'armscii8', 32, 'Yes', 'Yes', 1),
('armscii8_bin', 'armscii8', 64, '', 'Yes', 1),
('utf8_general_ci', 'utf8', 33, 'Yes', 'Yes', 1),
('utf8_bin', 'utf8', 83, '', 'Yes', 1),
('utf8_unicode_ci', 'utf8', 192, '', 'Yes', 8),
('utf8_icelandic_ci', 'utf8', 193, '', 'Yes', 8),
('utf8_latvian_ci', 'utf8', 194, '', 'Yes', 8),
('utf8_romanian_ci', 'utf8', 195, '', 'Yes', 8),
('utf8_slovenian_ci', 'utf8', 196, '', 'Yes', 8),
('utf8_polish_ci', 'utf8', 197, '', 'Yes', 8),
('utf8_estonian_ci', 'utf8', 198, '', 'Yes', 8),
('utf8_spanish_ci', 'utf8', 199, '', 'Yes', 8),
('utf8_swedish_ci', 'utf8', 200, '', 'Yes', 8),
('utf8_turkish_ci', 'utf8', 201, '', 'Yes', 8),
('utf8_czech_ci', 'utf8', 202, '', 'Yes', 8),
('utf8_danish_ci', 'utf8', 203, '', 'Yes', 8),
('utf8_lithuanian_ci', 'utf8', 204, '', 'Yes', 8),
('utf8_slovak_ci', 'utf8', 205, '', 'Yes', 8),
('utf8_spanish2_ci', 'utf8', 206, '', 'Yes', 8),
('utf8_roman_ci', 'utf8', 207, '', 'Yes', 8),
('utf8_persian_ci', 'utf8', 208, '', 'Yes', 8),
('utf8_esperanto_ci', 'utf8', 209, '', 'Yes', 8),
('utf8_hungarian_ci', 'utf8', 210, '', 'Yes', 8),
('utf8_sinhala_ci', 'utf8', 211, '', 'Yes', 8),
('utf8_general_mysql500_ci', 'utf8', 223, '', 'Yes', 1),
('ucs2_general_ci', 'ucs2', 35, 'Yes', 'Yes', 1),
('ucs2_bin', 'ucs2', 90, '', 'Yes', 1),
('ucs2_unicode_ci', 'ucs2', 128, '', 'Yes', 8),
('ucs2_icelandic_ci', 'ucs2', 129, '', 'Yes', 8),
('ucs2_latvian_ci', 'ucs2', 130, '', 'Yes', 8),
('ucs2_romanian_ci', 'ucs2', 131, '', 'Yes', 8),
('ucs2_slovenian_ci', 'ucs2', 132, '', 'Yes', 8),
('ucs2_polish_ci', 'ucs2', 133, '', 'Yes', 8),
('ucs2_estonian_ci', 'ucs2', 134, '', 'Yes', 8),
('ucs2_spanish_ci', 'ucs2', 135, '', 'Yes', 8),
('ucs2_swedish_ci', 'ucs2', 136, '', 'Yes', 8),
('ucs2_turkish_ci', 'ucs2', 137, '', 'Yes', 8),
('ucs2_czech_ci', 'ucs2', 138, '', 'Yes', 8),
('ucs2_danish_ci', 'ucs2', 139, '', 'Yes', 8),
('ucs2_lithuanian_ci', 'ucs2', 140, '', 'Yes', 8),
('ucs2_slovak_ci', 'ucs2', 141, '', 'Yes', 8),
('ucs2_spanish2_ci', 'ucs2', 142, '', 'Yes', 8),
('ucs2_roman_ci', 'ucs2', 143, '', 'Yes', 8),
('ucs2_persian_ci', 'ucs2', 144, '', 'Yes', 8),
('ucs2_esperanto_ci', 'ucs2', 145, '', 'Yes', 8),
('ucs2_hungarian_ci', 'ucs2', 146, '', 'Yes', 8),
('ucs2_sinhala_ci', 'ucs2', 147, '', 'Yes', 8),
('ucs2_general_mysql500_ci', 'ucs2', 159, '', 'Yes', 1),
('cp866_general_ci', 'cp866', 36, 'Yes', 'Yes', 1),
('cp866_bin', 'cp866', 68, '', 'Yes', 1),
('keybcs2_general_ci', 'keybcs2', 37, 'Yes', 'Yes', 1),
('keybcs2_bin', 'keybcs2', 73, '', 'Yes', 1),
('macce_general_ci', 'macce', 38, 'Yes', 'Yes', 1),
('macce_bin', 'macce', 43, '', 'Yes', 1),
('macroman_general_ci', 'macroman', 39, 'Yes', 'Yes', 1),
('macroman_bin', 'macroman', 53, '', 'Yes', 1),
('cp852_general_ci', 'cp852', 40, 'Yes', 'Yes', 1),
('cp852_bin', 'cp852', 81, '', 'Yes', 1),
('latin7_estonian_cs', 'latin7', 20, '', 'Yes', 1),
('latin7_general_ci', 'latin7', 41, 'Yes', 'Yes', 1),
('latin7_general_cs', 'latin7', 42, '', 'Yes', 1),
('latin7_bin', 'latin7', 79, '', 'Yes', 1),
('utf8mb4_general_ci', 'utf8mb4', 45, 'Yes', 'Yes', 1),
('utf8mb4_bin', 'utf8mb4', 46, '', 'Yes', 1),
('utf8mb4_unicode_ci', 'utf8mb4', 224, '', 'Yes', 8),
('utf8mb4_icelandic_ci', 'utf8mb4', 225, '', 'Yes', 8),
('utf8mb4_latvian_ci', 'utf8mb4', 226, '', 'Yes', 8),
('utf8mb4_romanian_ci', 'utf8mb4', 227, '', 'Yes', 8),
('utf8mb4_slovenian_ci', 'utf8mb4', 228, '', 'Yes', 8),
('utf8mb4_polish_ci', 'utf8mb4', 229, '', 'Yes', 8),
('utf8mb4_estonian_ci', 'utf8mb4', 230, '', 'Yes', 8),
('utf8mb4_spanish_ci', 'utf8mb4', 231, '', 'Yes', 8),
('utf8mb4_swedish_ci', 'utf8mb4', 232, '', 'Yes', 8),
('utf8mb4_turkish_ci', 'utf8mb4', 233, '', 'Yes', 8),
('utf8mb4_czech_ci', 'utf8mb4', 234, '', 'Yes', 8),
('utf8mb4_danish_ci', 'utf8mb4', 235, '', 'Yes', 8),
('utf8mb4_lithuanian_ci', 'utf8mb4', 236, '', 'Yes', 8),
('utf8mb4_slovak_ci', 'utf8mb4', 237, '', 'Yes', 8),
('utf8mb4_spanish2_ci', 'utf8mb4', 238, '', 'Yes', 8),
('utf8mb4_roman_ci', 'utf8mb4', 239, '', 'Yes', 8),
('utf8mb4_persian_ci', 'utf8mb4', 240, '', 'Yes', 8),
('utf8mb4_esperanto_ci', 'utf8mb4', 241, '', 'Yes', 8),
('utf8mb4_hungarian_ci', 'utf8mb4', 242, '', 'Yes', 8),
('utf8mb4_sinhala_ci', 'utf8mb4', 243, '', 'Yes', 8),
('cp1251_bulgarian_ci', 'cp1251', 14, '', 'Yes', 1),
('cp1251_ukrainian_ci', 'cp1251', 23, '', 'Yes', 1),
('cp1251_bin', 'cp1251', 50, '', 'Yes', 1),
('cp1251_general_ci', 'cp1251', 51, 'Yes', 'Yes', 1),
('cp1251_general_cs', 'cp1251', 52, '', 'Yes', 1),
('utf16_general_ci', 'utf16', 54, 'Yes', 'Yes', 1),
('utf16_bin', 'utf16', 55, '', 'Yes', 1),
('utf16_unicode_ci', 'utf16', 101, '', 'Yes', 8),
('utf16_icelandic_ci', 'utf16', 102, '', 'Yes', 8),
('utf16_latvian_ci', 'utf16', 103, '', 'Yes', 8),
('utf16_romanian_ci', 'utf16', 104, '', 'Yes', 8),
('utf16_slovenian_ci', 'utf16', 105, '', 'Yes', 8),
('utf16_polish_ci', 'utf16', 106, '', 'Yes', 8),
('utf16_estonian_ci', 'utf16', 107, '', 'Yes', 8),
('utf16_spanish_ci', 'utf16', 108, '', 'Yes', 8),
('utf16_swedish_ci', 'utf16', 109, '', 'Yes', 8),
('utf16_turkish_ci', 'utf16', 110, '', 'Yes', 8),
('utf16_czech_ci', 'utf16', 111, '', 'Yes', 8),
('utf16_danish_ci', 'utf16', 112, '', 'Yes', 8),
('utf16_lithuanian_ci', 'utf16', 113, '', 'Yes', 8),
('utf16_slovak_ci', 'utf16', 114, '', 'Yes', 8),
('utf16_spanish2_ci', 'utf16', 115, '', 'Yes', 8),
('utf16_roman_ci', 'utf16', 116, '', 'Yes', 8),
('utf16_persian_ci', 'utf16', 117, '', 'Yes', 8),
('utf16_esperanto_ci', 'utf16', 118, '', 'Yes', 8),
('utf16_hungarian_ci', 'utf16', 119, '', 'Yes', 8),
('utf16_sinhala_ci', 'utf16', 120, '', 'Yes', 8),
('cp1256_general_ci', 'cp1256', 57, 'Yes', 'Yes', 1),
('cp1256_bin', 'cp1256', 67, '', 'Yes', 1),
('cp1257_lithuanian_ci', 'cp1257', 29, '', 'Yes', 1),
('cp1257_bin', 'cp1257', 58, '', 'Yes', 1),
('cp1257_general_ci', 'cp1257', 59, 'Yes', 'Yes', 1),
('utf32_general_ci', 'utf32', 60, 'Yes', 'Yes', 1),
('utf32_bin', 'utf32', 61, '', 'Yes', 1),
('utf32_unicode_ci', 'utf32', 160, '', 'Yes', 8),
('utf32_icelandic_ci', 'utf32', 161, '', 'Yes', 8),
('utf32_latvian_ci', 'utf32', 162, '', 'Yes', 8),
('utf32_romanian_ci', 'utf32', 163, '', 'Yes', 8),
('utf32_slovenian_ci', 'utf32', 164, '', 'Yes', 8),
('utf32_polish_ci', 'utf32', 165, '', 'Yes', 8),
('utf32_estonian_ci', 'utf32', 166, '', 'Yes', 8),
('utf32_spanish_ci', 'utf32', 167, '', 'Yes', 8),
('utf32_swedish_ci', 'utf32', 168, '', 'Yes', 8),
('utf32_turkish_ci', 'utf32', 169, '', 'Yes', 8),
('utf32_czech_ci', 'utf32', 170, '', 'Yes', 8),
('utf32_danish_ci', 'utf32', 171, '', 'Yes', 8),
('utf32_lithuanian_ci', 'utf32', 172, '', 'Yes', 8),
('utf32_slovak_ci', 'utf32', 173, '', 'Yes', 8),
('utf32_spanish2_ci', 'utf32', 174, '', 'Yes', 8),
('utf32_roman_ci', 'utf32', 175, '', 'Yes', 8),
('utf32_persian_ci', 'utf32', 176, '', 'Yes', 8),
('utf32_esperanto_ci', 'utf32', 177, '', 'Yes', 8),
('utf32_hungarian_ci', 'utf32', 178, '', 'Yes', 8),
('utf32_sinhala_ci', 'utf32', 179, '', 'Yes', 8),
('binary', 'binary', 63, 'Yes', 'Yes', 1),
('geostd8_general_ci', 'geostd8', 92, 'Yes', 'Yes', 1),
('geostd8_bin', 'geostd8', 93, '', 'Yes', 1),
('cp932_japanese_ci', 'cp932', 95, 'Yes', 'Yes', 1),
('cp932_bin', 'cp932', 96, '', 'Yes', 1),
('eucjpms_japanese_ci', 'eucjpms', 97, 'Yes', 'Yes', 1),
('eucjpms_bin', 'eucjpms', 98, '', 'Yes', 1);

-- --------------------------------------------------------

--
-- Table structure for table `COLLATION_CHARACTER_SET_APPLICABILITY`
--

CREATE TEMPORARY TABLE `COLLATION_CHARACTER_SET_APPLICABILITY` (
  `COLLATION_NAME` varchar(32) NOT NULL DEFAULT '',
  `CHARACTER_SET_NAME` varchar(32) NOT NULL DEFAULT ''
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `COLLATION_CHARACTER_SET_APPLICABILITY`
--

INSERT INTO `COLLATION_CHARACTER_SET_APPLICABILITY` (`COLLATION_NAME`, `CHARACTER_SET_NAME`) VALUES
('big5_chinese_ci', 'big5'),
('big5_bin', 'big5'),
('dec8_swedish_ci', 'dec8'),
('dec8_bin', 'dec8'),
('cp850_general_ci', 'cp850'),
('cp850_bin', 'cp850'),
('hp8_english_ci', 'hp8'),
('hp8_bin', 'hp8'),
('koi8r_general_ci', 'koi8r'),
('koi8r_bin', 'koi8r'),
('latin1_german1_ci', 'latin1'),
('latin1_swedish_ci', 'latin1'),
('latin1_danish_ci', 'latin1'),
('latin1_german2_ci', 'latin1'),
('latin1_bin', 'latin1'),
('latin1_general_ci', 'latin1'),
('latin1_general_cs', 'latin1'),
('latin1_spanish_ci', 'latin1'),
('latin2_czech_cs', 'latin2'),
('latin2_general_ci', 'latin2'),
('latin2_hungarian_ci', 'latin2'),
('latin2_croatian_ci', 'latin2'),
('latin2_bin', 'latin2'),
('swe7_swedish_ci', 'swe7'),
('swe7_bin', 'swe7'),
('ascii_general_ci', 'ascii'),
('ascii_bin', 'ascii'),
('ujis_japanese_ci', 'ujis'),
('ujis_bin', 'ujis'),
('sjis_japanese_ci', 'sjis'),
('sjis_bin', 'sjis'),
('hebrew_general_ci', 'hebrew'),
('hebrew_bin', 'hebrew'),
('tis620_thai_ci', 'tis620'),
('tis620_bin', 'tis620'),
('euckr_korean_ci', 'euckr'),
('euckr_bin', 'euckr'),
('koi8u_general_ci', 'koi8u'),
('koi8u_bin', 'koi8u'),
('gb2312_chinese_ci', 'gb2312'),
('gb2312_bin', 'gb2312'),
('greek_general_ci', 'greek'),
('greek_bin', 'greek'),
('cp1250_general_ci', 'cp1250'),
('cp1250_czech_cs', 'cp1250'),
('cp1250_croatian_ci', 'cp1250'),
('cp1250_bin', 'cp1250'),
('cp1250_polish_ci', 'cp1250'),
('gbk_chinese_ci', 'gbk'),
('gbk_bin', 'gbk'),
('latin5_turkish_ci', 'latin5'),
('latin5_bin', 'latin5'),
('armscii8_general_ci', 'armscii8'),
('armscii8_bin', 'armscii8'),
('utf8_general_ci', 'utf8'),
('utf8_bin', 'utf8'),
('utf8_unicode_ci', 'utf8'),
('utf8_icelandic_ci', 'utf8'),
('utf8_latvian_ci', 'utf8'),
('utf8_romanian_ci', 'utf8'),
('utf8_slovenian_ci', 'utf8'),
('utf8_polish_ci', 'utf8'),
('utf8_estonian_ci', 'utf8'),
('utf8_spanish_ci', 'utf8'),
('utf8_swedish_ci', 'utf8'),
('utf8_turkish_ci', 'utf8'),
('utf8_czech_ci', 'utf8'),
('utf8_danish_ci', 'utf8'),
('utf8_lithuanian_ci', 'utf8'),
('utf8_slovak_ci', 'utf8'),
('utf8_spanish2_ci', 'utf8'),
('utf8_roman_ci', 'utf8'),
('utf8_persian_ci', 'utf8'),
('utf8_esperanto_ci', 'utf8'),
('utf8_hungarian_ci', 'utf8'),
('utf8_sinhala_ci', 'utf8'),
('utf8_general_mysql500_ci', 'utf8'),
('ucs2_general_ci', 'ucs2'),
('ucs2_bin', 'ucs2'),
('ucs2_unicode_ci', 'ucs2'),
('ucs2_icelandic_ci', 'ucs2'),
('ucs2_latvian_ci', 'ucs2'),
('ucs2_romanian_ci', 'ucs2'),
('ucs2_slovenian_ci', 'ucs2'),
('ucs2_polish_ci', 'ucs2'),
('ucs2_estonian_ci', 'ucs2'),
('ucs2_spanish_ci', 'ucs2'),
('ucs2_swedish_ci', 'ucs2'),
('ucs2_turkish_ci', 'ucs2'),
('ucs2_czech_ci', 'ucs2'),
('ucs2_danish_ci', 'ucs2'),
('ucs2_lithuanian_ci', 'ucs2'),
('ucs2_slovak_ci', 'ucs2'),
('ucs2_spanish2_ci', 'ucs2'),
('ucs2_roman_ci', 'ucs2'),
('ucs2_persian_ci', 'ucs2'),
('ucs2_esperanto_ci', 'ucs2'),
('ucs2_hungarian_ci', 'ucs2'),
('ucs2_sinhala_ci', 'ucs2'),
('ucs2_general_mysql500_ci', 'ucs2'),
('cp866_general_ci', 'cp866'),
('cp866_bin', 'cp866'),
('keybcs2_general_ci', 'keybcs2'),
('keybcs2_bin', 'keybcs2'),
('macce_general_ci', 'macce'),
('macce_bin', 'macce'),
('macroman_general_ci', 'macroman'),
('macroman_bin', 'macroman'),
('cp852_general_ci', 'cp852'),
('cp852_bin', 'cp852'),
('latin7_estonian_cs', 'latin7'),
('latin7_general_ci', 'latin7'),
('latin7_general_cs', 'latin7'),
('latin7_bin', 'latin7'),
('utf8mb4_general_ci', 'utf8mb4'),
('utf8mb4_bin', 'utf8mb4'),
('utf8mb4_unicode_ci', 'utf8mb4'),
('utf8mb4_icelandic_ci', 'utf8mb4'),
('utf8mb4_latvian_ci', 'utf8mb4'),
('utf8mb4_romanian_ci', 'utf8mb4'),
('utf8mb4_slovenian_ci', 'utf8mb4'),
('utf8mb4_polish_ci', 'utf8mb4'),
('utf8mb4_estonian_ci', 'utf8mb4'),
('utf8mb4_spanish_ci', 'utf8mb4'),
('utf8mb4_swedish_ci', 'utf8mb4'),
('utf8mb4_turkish_ci', 'utf8mb4'),
('utf8mb4_czech_ci', 'utf8mb4'),
('utf8mb4_danish_ci', 'utf8mb4'),
('utf8mb4_lithuanian_ci', 'utf8mb4'),
('utf8mb4_slovak_ci', 'utf8mb4'),
('utf8mb4_spanish2_ci', 'utf8mb4'),
('utf8mb4_roman_ci', 'utf8mb4'),
('utf8mb4_persian_ci', 'utf8mb4'),
('utf8mb4_esperanto_ci', 'utf8mb4'),
('utf8mb4_hungarian_ci', 'utf8mb4'),
('utf8mb4_sinhala_ci', 'utf8mb4'),
('cp1251_bulgarian_ci', 'cp1251'),
('cp1251_ukrainian_ci', 'cp1251'),
('cp1251_bin', 'cp1251'),
('cp1251_general_ci', 'cp1251'),
('cp1251_general_cs', 'cp1251'),
('utf16_general_ci', 'utf16'),
('utf16_bin', 'utf16'),
('utf16_unicode_ci', 'utf16'),
('utf16_icelandic_ci', 'utf16'),
('utf16_latvian_ci', 'utf16'),
('utf16_romanian_ci', 'utf16'),
('utf16_slovenian_ci', 'utf16'),
('utf16_polish_ci', 'utf16'),
('utf16_estonian_ci', 'utf16'),
('utf16_spanish_ci', 'utf16'),
('utf16_swedish_ci', 'utf16'),
('utf16_turkish_ci', 'utf16'),
('utf16_czech_ci', 'utf16'),
('utf16_danish_ci', 'utf16'),
('utf16_lithuanian_ci', 'utf16'),
('utf16_slovak_ci', 'utf16'),
('utf16_spanish2_ci', 'utf16'),
('utf16_roman_ci', 'utf16'),
('utf16_persian_ci', 'utf16'),
('utf16_esperanto_ci', 'utf16'),
('utf16_hungarian_ci', 'utf16'),
('utf16_sinhala_ci', 'utf16'),
('cp1256_general_ci', 'cp1256'),
('cp1256_bin', 'cp1256'),
('cp1257_lithuanian_ci', 'cp1257'),
('cp1257_bin', 'cp1257'),
('cp1257_general_ci', 'cp1257'),
('utf32_general_ci', 'utf32'),
('utf32_bin', 'utf32'),
('utf32_unicode_ci', 'utf32'),
('utf32_icelandic_ci', 'utf32'),
('utf32_latvian_ci', 'utf32'),
('utf32_romanian_ci', 'utf32'),
('utf32_slovenian_ci', 'utf32'),
('utf32_polish_ci', 'utf32'),
('utf32_estonian_ci', 'utf32'),
('utf32_spanish_ci', 'utf32'),
('utf32_swedish_ci', 'utf32'),
('utf32_turkish_ci', 'utf32'),
('utf32_czech_ci', 'utf32'),
('utf32_danish_ci', 'utf32'),
('utf32_lithuanian_ci', 'utf32'),
('utf32_slovak_ci', 'utf32'),
('utf32_spanish2_ci', 'utf32'),
('utf32_roman_ci', 'utf32'),
('utf32_persian_ci', 'utf32'),
('utf32_esperanto_ci', 'utf32'),
('utf32_hungarian_ci', 'utf32'),
('utf32_sinhala_ci', 'utf32'),
('binary', 'binary'),
('geostd8_general_ci', 'geostd8'),
('geostd8_bin', 'geostd8'),
('cp932_japanese_ci', 'cp932'),
('cp932_bin', 'cp932'),
('eucjpms_japanese_ci', 'eucjpms'),
('eucjpms_bin', 'eucjpms');

-- --------------------------------------------------------

--
-- Table structure for table `COLUMNS`
--

CREATE TEMPORARY TABLE `COLUMNS` (
  `TABLE_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `TABLE_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `TABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `COLUMN_NAME` varchar(64) NOT NULL DEFAULT '',
  `ORDINAL_POSITION` bigint(21) unsigned NOT NULL DEFAULT '0',
  `COLUMN_DEFAULT` longtext,
  `IS_NULLABLE` varchar(3) NOT NULL DEFAULT '',
  `DATA_TYPE` varchar(64) NOT NULL DEFAULT '',
  `CHARACTER_MAXIMUM_LENGTH` bigint(21) unsigned DEFAULT NULL,
  `CHARACTER_OCTET_LENGTH` bigint(21) unsigned DEFAULT NULL,
  `NUMERIC_PRECISION` bigint(21) unsigned DEFAULT NULL,
  `NUMERIC_SCALE` bigint(21) unsigned DEFAULT NULL,
  `CHARACTER_SET_NAME` varchar(32) DEFAULT NULL,
  `COLLATION_NAME` varchar(32) DEFAULT NULL,
  `COLUMN_TYPE` longtext NOT NULL,
  `COLUMN_KEY` varchar(3) NOT NULL DEFAULT '',
  `EXTRA` varchar(27) NOT NULL DEFAULT '',
  `PRIVILEGES` varchar(80) NOT NULL DEFAULT '',
  `COLUMN_COMMENT` varchar(1024) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `COLUMNS`
--

INSERT INTO `COLUMNS` (`TABLE_CATALOG`, `TABLE_SCHEMA`, `TABLE_NAME`, `COLUMN_NAME`, `ORDINAL_POSITION`, `COLUMN_DEFAULT`, `IS_NULLABLE`, `DATA_TYPE`, `CHARACTER_MAXIMUM_LENGTH`, `CHARACTER_OCTET_LENGTH`, `NUMERIC_PRECISION`, `NUMERIC_SCALE`, `CHARACTER_SET_NAME`, `COLLATION_NAME`, `COLUMN_TYPE`, `COLUMN_KEY`, `EXTRA`, `PRIVILEGES`, `COLUMN_COMMENT`) VALUES
('def', 'information_schema', 'CHARACTER_SETS', 'CHARACTER_SET_NAME', 1, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'CHARACTER_SETS', 'DEFAULT_COLLATE_NAME', 2, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'CHARACTER_SETS', 'DESCRIPTION', 3, '', 'NO', 'varchar', 60, 180, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(60)', '', '', 'select', ''),
('def', 'information_schema', 'CHARACTER_SETS', 'MAXLEN', 4, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(3)', '', '', 'select', ''),
('def', 'information_schema', 'COLLATIONS', 'COLLATION_NAME', 1, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'COLLATIONS', 'CHARACTER_SET_NAME', 2, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'COLLATIONS', 'ID', 3, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(11)', '', '', 'select', ''),
('def', 'information_schema', 'COLLATIONS', 'IS_DEFAULT', 4, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'COLLATIONS', 'IS_COMPILED', 5, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'COLLATIONS', 'SORTLEN', 6, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(3)', '', '', 'select', ''),
('def', 'information_schema', 'COLLATION_CHARACTER_SET_APPLICABILITY', 'COLLATION_NAME', 1, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'COLLATION_CHARACTER_SET_APPLICABILITY', 'CHARACTER_SET_NAME', 2, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'TABLE_CATALOG', 1, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'TABLE_SCHEMA', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'TABLE_NAME', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'COLUMN_NAME', 4, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'ORDINAL_POSITION', 5, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'COLUMN_DEFAULT', 6, NULL, 'YES', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'IS_NULLABLE', 7, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'DATA_TYPE', 8, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'CHARACTER_MAXIMUM_LENGTH', 9, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'CHARACTER_OCTET_LENGTH', 10, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'NUMERIC_PRECISION', 11, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'NUMERIC_SCALE', 12, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'CHARACTER_SET_NAME', 13, NULL, 'YES', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'COLLATION_NAME', 14, NULL, 'YES', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'COLUMN_TYPE', 15, NULL, 'NO', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'COLUMN_KEY', 16, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'EXTRA', 17, '', 'NO', 'varchar', 27, 81, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(27)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'PRIVILEGES', 18, '', 'NO', 'varchar', 80, 240, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(80)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMNS', 'COLUMN_COMMENT', 19, '', 'NO', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMN_PRIVILEGES', 'GRANTEE', 1, '', 'NO', 'varchar', 81, 243, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(81)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMN_PRIVILEGES', 'TABLE_CATALOG', 2, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMN_PRIVILEGES', 'TABLE_SCHEMA', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMN_PRIVILEGES', 'TABLE_NAME', 4, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMN_PRIVILEGES', 'COLUMN_NAME', 5, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMN_PRIVILEGES', 'PRIVILEGE_TYPE', 6, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'COLUMN_PRIVILEGES', 'IS_GRANTABLE', 7, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'ENGINES', 'ENGINE', 1, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ENGINES', 'SUPPORT', 2, '', 'NO', 'varchar', 8, 24, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(8)', '', '', 'select', ''),
('def', 'information_schema', 'ENGINES', 'COMMENT', 3, '', 'NO', 'varchar', 80, 240, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(80)', '', '', 'select', ''),
('def', 'information_schema', 'ENGINES', 'TRANSACTIONS', 4, NULL, 'YES', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'ENGINES', 'XA', 5, NULL, 'YES', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'ENGINES', 'SAVEPOINTS', 6, NULL, 'YES', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'EVENT_CATALOG', 1, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'EVENT_SCHEMA', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'EVENT_NAME', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'DEFINER', 4, '', 'NO', 'varchar', 77, 231, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(77)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'TIME_ZONE', 5, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'EVENT_BODY', 6, '', 'NO', 'varchar', 8, 24, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(8)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'EVENT_DEFINITION', 7, NULL, 'NO', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'EVENT_TYPE', 8, '', 'NO', 'varchar', 9, 27, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(9)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'EXECUTE_AT', 9, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'INTERVAL_VALUE', 10, NULL, 'YES', 'varchar', 256, 768, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(256)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'INTERVAL_FIELD', 11, NULL, 'YES', 'varchar', 18, 54, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(18)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'SQL_MODE', 12, '', 'NO', 'varchar', 8192, 24576, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(8192)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'STARTS', 13, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'ENDS', 14, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'STATUS', 15, '', 'NO', 'varchar', 18, 54, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(18)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'ON_COMPLETION', 16, '', 'NO', 'varchar', 12, 36, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(12)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'CREATED', 17, '0000-00-00 00:00:00', 'NO', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'LAST_ALTERED', 18, '0000-00-00 00:00:00', 'NO', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'LAST_EXECUTED', 19, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'EVENT_COMMENT', 20, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'ORIGINATOR', 21, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(10)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'CHARACTER_SET_CLIENT', 22, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'COLLATION_CONNECTION', 23, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'EVENTS', 'DATABASE_COLLATION', 24, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'FILE_ID', 1, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(4)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'FILE_NAME', 2, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'FILE_TYPE', 3, '', 'NO', 'varchar', 20, 60, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(20)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'TABLESPACE_NAME', 4, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'TABLE_CATALOG', 5, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'TABLE_SCHEMA', 6, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'TABLE_NAME', 7, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'LOGFILE_GROUP_NAME', 8, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'LOGFILE_GROUP_NUMBER', 9, NULL, 'YES', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(4)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'ENGINE', 10, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'FULLTEXT_KEYS', 11, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'DELETED_ROWS', 12, NULL, 'YES', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(4)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'UPDATE_COUNT', 13, NULL, 'YES', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(4)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'FREE_EXTENTS', 14, NULL, 'YES', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(4)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'TOTAL_EXTENTS', 15, NULL, 'YES', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(4)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'EXTENT_SIZE', 16, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(4)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'INITIAL_SIZE', 17, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'MAXIMUM_SIZE', 18, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'AUTOEXTEND_SIZE', 19, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'CREATION_TIME', 20, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'LAST_UPDATE_TIME', 21, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'LAST_ACCESS_TIME', 22, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'RECOVER_TIME', 23, NULL, 'YES', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(4)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'TRANSACTION_COUNTER', 24, NULL, 'YES', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(4)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'VERSION', 25, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'ROW_FORMAT', 26, NULL, 'YES', 'varchar', 10, 30, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(10)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'TABLE_ROWS', 27, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'AVG_ROW_LENGTH', 28, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'DATA_LENGTH', 29, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'MAX_DATA_LENGTH', 30, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'INDEX_LENGTH', 31, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'DATA_FREE', 32, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'CREATE_TIME', 33, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'UPDATE_TIME', 34, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'CHECK_TIME', 35, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'CHECKSUM', 36, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'STATUS', 37, '', 'NO', 'varchar', 20, 60, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(20)', '', '', 'select', ''),
('def', 'information_schema', 'FILES', 'EXTRA', 38, NULL, 'YES', 'varchar', 255, 765, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(255)', '', '', 'select', ''),
('def', 'information_schema', 'GLOBAL_STATUS', 'VARIABLE_NAME', 1, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'GLOBAL_STATUS', 'VARIABLE_VALUE', 2, NULL, 'YES', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'GLOBAL_VARIABLES', 'VARIABLE_NAME', 1, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'GLOBAL_VARIABLES', 'VARIABLE_VALUE', 2, NULL, 'YES', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'CONSTRAINT_CATALOG', 1, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'CONSTRAINT_SCHEMA', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'CONSTRAINT_NAME', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'TABLE_CATALOG', 4, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'TABLE_SCHEMA', 5, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'TABLE_NAME', 6, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'COLUMN_NAME', 7, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'ORDINAL_POSITION', 8, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(10)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'POSITION_IN_UNIQUE_CONSTRAINT', 9, NULL, 'YES', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(10)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'REFERENCED_TABLE_SCHEMA', 10, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'REFERENCED_TABLE_NAME', 11, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'REFERENCED_COLUMN_NAME', 12, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'SPECIFIC_CATALOG', 1, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'SPECIFIC_SCHEMA', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'SPECIFIC_NAME', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'ORDINAL_POSITION', 4, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(21)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'PARAMETER_MODE', 5, NULL, 'YES', 'varchar', 5, 15, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(5)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'PARAMETER_NAME', 6, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'DATA_TYPE', 7, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'CHARACTER_MAXIMUM_LENGTH', 8, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(21)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'CHARACTER_OCTET_LENGTH', 9, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(21)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'NUMERIC_PRECISION', 10, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(21)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'NUMERIC_SCALE', 11, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(21)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'CHARACTER_SET_NAME', 12, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'COLLATION_NAME', 13, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'DTD_IDENTIFIER', 14, NULL, 'NO', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'PARAMETERS', 'ROUTINE_TYPE', 15, '', 'NO', 'varchar', 9, 27, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(9)', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'TABLE_CATALOG', 1, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'TABLE_SCHEMA', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'TABLE_NAME', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'PARTITION_NAME', 4, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'SUBPARTITION_NAME', 5, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'PARTITION_ORDINAL_POSITION', 6, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'SUBPARTITION_ORDINAL_POSITION', 7, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'PARTITION_METHOD', 8, NULL, 'YES', 'varchar', 18, 54, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(18)', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'SUBPARTITION_METHOD', 9, NULL, 'YES', 'varchar', 12, 36, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(12)', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'PARTITION_EXPRESSION', 10, NULL, 'YES', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'SUBPARTITION_EXPRESSION', 11, NULL, 'YES', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'PARTITION_DESCRIPTION', 12, NULL, 'YES', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'TABLE_ROWS', 13, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'AVG_ROW_LENGTH', 14, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'DATA_LENGTH', 15, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'MAX_DATA_LENGTH', 16, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'INDEX_LENGTH', 17, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'DATA_FREE', 18, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'CREATE_TIME', 19, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'UPDATE_TIME', 20, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'CHECK_TIME', 21, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'CHECKSUM', 22, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'PARTITION_COMMENT', 23, '', 'NO', 'varchar', 80, 240, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(80)', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'NODEGROUP', 24, '', 'NO', 'varchar', 12, 36, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(12)', '', '', 'select', ''),
('def', 'information_schema', 'PARTITIONS', 'TABLESPACE_NAME', 25, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PLUGINS', 'PLUGIN_NAME', 1, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PLUGINS', 'PLUGIN_VERSION', 2, '', 'NO', 'varchar', 20, 60, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(20)', '', '', 'select', ''),
('def', 'information_schema', 'PLUGINS', 'PLUGIN_STATUS', 3, '', 'NO', 'varchar', 10, 30, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(10)', '', '', 'select', ''),
('def', 'information_schema', 'PLUGINS', 'PLUGIN_TYPE', 4, '', 'NO', 'varchar', 80, 240, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(80)', '', '', 'select', ''),
('def', 'information_schema', 'PLUGINS', 'PLUGIN_TYPE_VERSION', 5, '', 'NO', 'varchar', 20, 60, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(20)', '', '', 'select', ''),
('def', 'information_schema', 'PLUGINS', 'PLUGIN_LIBRARY', 6, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PLUGINS', 'PLUGIN_LIBRARY_VERSION', 7, NULL, 'YES', 'varchar', 20, 60, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(20)', '', '', 'select', ''),
('def', 'information_schema', 'PLUGINS', 'PLUGIN_AUTHOR', 8, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PLUGINS', 'PLUGIN_DESCRIPTION', 9, NULL, 'YES', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'PLUGINS', 'PLUGIN_LICENSE', 10, NULL, 'YES', 'varchar', 80, 240, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(80)', '', '', 'select', ''),
('def', 'information_schema', 'PLUGINS', 'LOAD_OPTION', 11, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PROCESSLIST', 'ID', 1, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(4)', '', '', 'select', ''),
('def', 'information_schema', 'PROCESSLIST', 'USER', 2, '', 'NO', 'varchar', 16, 48, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(16)', '', '', 'select', ''),
('def', 'information_schema', 'PROCESSLIST', 'HOST', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PROCESSLIST', 'DB', 4, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PROCESSLIST', 'COMMAND', 5, '', 'NO', 'varchar', 16, 48, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(16)', '', '', 'select', ''),
('def', 'information_schema', 'PROCESSLIST', 'TIME', 6, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(7)', '', '', 'select', ''),
('def', 'information_schema', 'PROCESSLIST', 'STATE', 7, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'PROCESSLIST', 'INFO', 8, NULL, 'YES', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'QUERY_ID', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'SEQ', 2, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'STATE', 3, '', 'NO', 'varchar', 30, 90, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(30)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'DURATION', 4, '0.000000', 'NO', 'decimal', NULL, NULL, 9, 6, NULL, NULL, 'decimal(9,6)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'CPU_USER', 5, NULL, 'YES', 'decimal', NULL, NULL, 9, 6, NULL, NULL, 'decimal(9,6)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'CPU_SYSTEM', 6, NULL, 'YES', 'decimal', NULL, NULL, 9, 6, NULL, NULL, 'decimal(9,6)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'CONTEXT_VOLUNTARY', 7, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'CONTEXT_INVOLUNTARY', 8, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'BLOCK_OPS_IN', 9, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'BLOCK_OPS_OUT', 10, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'MESSAGES_SENT', 11, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'MESSAGES_RECEIVED', 12, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'PAGE_FAULTS_MAJOR', 13, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'PAGE_FAULTS_MINOR', 14, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'SWAPS', 15, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'SOURCE_FUNCTION', 16, NULL, 'YES', 'varchar', 30, 90, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(30)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'SOURCE_FILE', 17, NULL, 'YES', 'varchar', 20, 60, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(20)', '', '', 'select', ''),
('def', 'information_schema', 'PROFILING', 'SOURCE_LINE', 18, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(20)', '', '', 'select', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'CONSTRAINT_CATALOG', 1, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'CONSTRAINT_SCHEMA', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'CONSTRAINT_NAME', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'UNIQUE_CONSTRAINT_CATALOG', 4, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'UNIQUE_CONSTRAINT_SCHEMA', 5, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'UNIQUE_CONSTRAINT_NAME', 6, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'MATCH_OPTION', 7, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'UPDATE_RULE', 8, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'DELETE_RULE', 9, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'TABLE_NAME', 10, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'REFERENCED_TABLE_NAME', 11, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'SPECIFIC_NAME', 1, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'ROUTINE_CATALOG', 2, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'ROUTINE_SCHEMA', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'ROUTINE_NAME', 4, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'ROUTINE_TYPE', 5, '', 'NO', 'varchar', 9, 27, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(9)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'DATA_TYPE', 6, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'CHARACTER_MAXIMUM_LENGTH', 7, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(21)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'CHARACTER_OCTET_LENGTH', 8, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(21)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'NUMERIC_PRECISION', 9, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(21)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'NUMERIC_SCALE', 10, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(21)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'CHARACTER_SET_NAME', 11, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'COLLATION_NAME', 12, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'DTD_IDENTIFIER', 13, NULL, 'YES', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'ROUTINE_BODY', 14, '', 'NO', 'varchar', 8, 24, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(8)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'ROUTINE_DEFINITION', 15, NULL, 'YES', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'EXTERNAL_NAME', 16, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'EXTERNAL_LANGUAGE', 17, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'PARAMETER_STYLE', 18, '', 'NO', 'varchar', 8, 24, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(8)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'IS_DETERMINISTIC', 19, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'SQL_DATA_ACCESS', 20, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'SQL_PATH', 21, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'SECURITY_TYPE', 22, '', 'NO', 'varchar', 7, 21, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(7)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'CREATED', 23, '0000-00-00 00:00:00', 'NO', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'LAST_ALTERED', 24, '0000-00-00 00:00:00', 'NO', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'SQL_MODE', 25, '', 'NO', 'varchar', 8192, 24576, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(8192)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'ROUTINE_COMMENT', 26, NULL, 'NO', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'DEFINER', 27, '', 'NO', 'varchar', 77, 231, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(77)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'CHARACTER_SET_CLIENT', 28, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'COLLATION_CONNECTION', 29, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'ROUTINES', 'DATABASE_COLLATION', 30, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'SCHEMATA', 'CATALOG_NAME', 1, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'SCHEMATA', 'SCHEMA_NAME', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'SCHEMATA', 'DEFAULT_CHARACTER_SET_NAME', 3, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'SCHEMATA', 'DEFAULT_COLLATION_NAME', 4, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'SCHEMATA', 'SQL_PATH', 5, NULL, 'YES', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'SCHEMA_PRIVILEGES', 'GRANTEE', 1, '', 'NO', 'varchar', 81, 243, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(81)', '', '', 'select', ''),
('def', 'information_schema', 'SCHEMA_PRIVILEGES', 'TABLE_CATALOG', 2, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'SCHEMA_PRIVILEGES', 'TABLE_SCHEMA', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'SCHEMA_PRIVILEGES', 'PRIVILEGE_TYPE', 4, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'SCHEMA_PRIVILEGES', 'IS_GRANTABLE', 5, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'SESSION_STATUS', 'VARIABLE_NAME', 1, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'SESSION_STATUS', 'VARIABLE_VALUE', 2, NULL, 'YES', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'SESSION_VARIABLES', 'VARIABLE_NAME', 1, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'SESSION_VARIABLES', 'VARIABLE_VALUE', 2, NULL, 'YES', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'TABLE_CATALOG', 1, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'TABLE_SCHEMA', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'TABLE_NAME', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'NON_UNIQUE', 4, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(1)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'INDEX_SCHEMA', 5, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'INDEX_NAME', 6, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'SEQ_IN_INDEX', 7, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(2)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'COLUMN_NAME', 8, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'COLLATION', 9, NULL, 'YES', 'varchar', 1, 3, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'CARDINALITY', 10, NULL, 'YES', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(21)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'SUB_PART', 11, NULL, 'YES', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(3)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'PACKED', 12, NULL, 'YES', 'varchar', 10, 30, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(10)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'NULLABLE', 13, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'INDEX_TYPE', 14, '', 'NO', 'varchar', 16, 48, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(16)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'COMMENT', 15, NULL, 'YES', 'varchar', 16, 48, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(16)', '', '', 'select', ''),
('def', 'information_schema', 'STATISTICS', 'INDEX_COMMENT', 16, '', 'NO', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'TABLE_CATALOG', 1, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'TABLE_SCHEMA', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'TABLE_NAME', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'TABLE_TYPE', 4, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'ENGINE', 5, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'VERSION', 6, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'ROW_FORMAT', 7, NULL, 'YES', 'varchar', 10, 30, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(10)', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'TABLE_ROWS', 8, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'AVG_ROW_LENGTH', 9, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'DATA_LENGTH', 10, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'MAX_DATA_LENGTH', 11, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'INDEX_LENGTH', 12, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'DATA_FREE', 13, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'AUTO_INCREMENT', 14, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'CREATE_TIME', 15, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'UPDATE_TIME', 16, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'CHECK_TIME', 17, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'TABLE_COLLATION', 18, NULL, 'YES', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'CHECKSUM', 19, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'CREATE_OPTIONS', 20, NULL, 'YES', 'varchar', 255, 765, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(255)', '', '', 'select', ''),
('def', 'information_schema', 'TABLES', 'TABLE_COMMENT', 21, '', 'NO', 'varchar', 2048, 6144, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(2048)', '', '', 'select', ''),
('def', 'information_schema', 'TABLESPACES', 'TABLESPACE_NAME', 1, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLESPACES', 'ENGINE', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLESPACES', 'TABLESPACE_TYPE', 3, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLESPACES', 'LOGFILE_GROUP_NAME', 4, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLESPACES', 'EXTENT_SIZE', 5, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLESPACES', 'AUTOEXTEND_SIZE', 6, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLESPACES', 'MAXIMUM_SIZE', 7, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'TABLESPACES', 'NODEGROUP_ID', 8, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', '');
INSERT INTO `COLUMNS` (`TABLE_CATALOG`, `TABLE_SCHEMA`, `TABLE_NAME`, `COLUMN_NAME`, `ORDINAL_POSITION`, `COLUMN_DEFAULT`, `IS_NULLABLE`, `DATA_TYPE`, `CHARACTER_MAXIMUM_LENGTH`, `CHARACTER_OCTET_LENGTH`, `NUMERIC_PRECISION`, `NUMERIC_SCALE`, `CHARACTER_SET_NAME`, `COLLATION_NAME`, `COLUMN_TYPE`, `COLUMN_KEY`, `EXTRA`, `PRIVILEGES`, `COLUMN_COMMENT`) VALUES
('def', 'information_schema', 'TABLESPACES', 'TABLESPACE_COMMENT', 9, NULL, 'YES', 'varchar', 2048, 6144, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(2048)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_CONSTRAINTS', 'CONSTRAINT_CATALOG', 1, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_CONSTRAINTS', 'CONSTRAINT_SCHEMA', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_CONSTRAINTS', 'CONSTRAINT_NAME', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_CONSTRAINTS', 'TABLE_SCHEMA', 4, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_CONSTRAINTS', 'TABLE_NAME', 5, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_CONSTRAINTS', 'CONSTRAINT_TYPE', 6, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_PRIVILEGES', 'GRANTEE', 1, '', 'NO', 'varchar', 81, 243, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(81)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_PRIVILEGES', 'TABLE_CATALOG', 2, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_PRIVILEGES', 'TABLE_SCHEMA', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_PRIVILEGES', 'TABLE_NAME', 4, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_PRIVILEGES', 'PRIVILEGE_TYPE', 5, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TABLE_PRIVILEGES', 'IS_GRANTABLE', 6, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'TRIGGER_CATALOG', 1, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'TRIGGER_SCHEMA', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'TRIGGER_NAME', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'EVENT_MANIPULATION', 4, '', 'NO', 'varchar', 6, 18, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(6)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'EVENT_OBJECT_CATALOG', 5, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'EVENT_OBJECT_SCHEMA', 6, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'EVENT_OBJECT_TABLE', 7, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'ACTION_ORDER', 8, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(4)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'ACTION_CONDITION', 9, NULL, 'YES', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'ACTION_STATEMENT', 10, NULL, 'NO', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'ACTION_ORIENTATION', 11, '', 'NO', 'varchar', 9, 27, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(9)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'ACTION_TIMING', 12, '', 'NO', 'varchar', 6, 18, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(6)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'ACTION_REFERENCE_OLD_TABLE', 13, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'ACTION_REFERENCE_NEW_TABLE', 14, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'ACTION_REFERENCE_OLD_ROW', 15, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'ACTION_REFERENCE_NEW_ROW', 16, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'CREATED', 17, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'SQL_MODE', 18, '', 'NO', 'varchar', 8192, 24576, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(8192)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'DEFINER', 19, '', 'NO', 'varchar', 77, 231, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(77)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'CHARACTER_SET_CLIENT', 20, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'COLLATION_CONNECTION', 21, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'TRIGGERS', 'DATABASE_COLLATION', 22, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'USER_PRIVILEGES', 'GRANTEE', 1, '', 'NO', 'varchar', 81, 243, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(81)', '', '', 'select', ''),
('def', 'information_schema', 'USER_PRIVILEGES', 'TABLE_CATALOG', 2, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'USER_PRIVILEGES', 'PRIVILEGE_TYPE', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'USER_PRIVILEGES', 'IS_GRANTABLE', 4, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'VIEWS', 'TABLE_CATALOG', 1, '', 'NO', 'varchar', 512, 1536, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(512)', '', '', 'select', ''),
('def', 'information_schema', 'VIEWS', 'TABLE_SCHEMA', 2, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'VIEWS', 'TABLE_NAME', 3, '', 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'VIEWS', 'VIEW_DEFINITION', 4, NULL, 'NO', 'longtext', 4294967295, 4294967295, NULL, NULL, 'utf8', 'utf8_general_ci', 'longtext', '', '', 'select', ''),
('def', 'information_schema', 'VIEWS', 'CHECK_OPTION', 5, '', 'NO', 'varchar', 8, 24, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(8)', '', '', 'select', ''),
('def', 'information_schema', 'VIEWS', 'IS_UPDATABLE', 6, '', 'NO', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'VIEWS', 'DEFINER', 7, '', 'NO', 'varchar', 77, 231, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(77)', '', '', 'select', ''),
('def', 'information_schema', 'VIEWS', 'SECURITY_TYPE', 8, '', 'NO', 'varchar', 7, 21, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(7)', '', '', 'select', ''),
('def', 'information_schema', 'VIEWS', 'CHARACTER_SET_CLIENT', 9, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'VIEWS', 'COLLATION_CONNECTION', 10, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'POOL_ID', 1, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'BLOCK_ID', 2, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'SPACE', 3, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'PAGE_NUMBER', 4, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'PAGE_TYPE', 5, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'FLUSH_TYPE', 6, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'FIX_COUNT', 7, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'IS_HASHED', 8, NULL, 'YES', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'NEWEST_MODIFICATION', 9, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'OLDEST_MODIFICATION', 10, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'ACCESS_TIME', 11, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'TABLE_NAME', 12, NULL, 'YES', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'INDEX_NAME', 13, NULL, 'YES', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'NUMBER_RECORDS', 14, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'DATA_SIZE', 15, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'COMPRESSED_SIZE', 16, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'PAGE_STATE', 17, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'IO_FIX', 18, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'IS_OLD', 19, NULL, 'YES', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'FREE_PAGE_CLOCK', 20, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_id', 1, '', 'NO', 'varchar', 18, 54, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(18)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_state', 2, '', 'NO', 'varchar', 13, 39, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(13)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_started', 3, '0000-00-00 00:00:00', 'NO', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_requested_lock_id', 4, NULL, 'YES', 'varchar', 81, 243, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(81)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_wait_started', 5, NULL, 'YES', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_weight', 6, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_mysql_thread_id', 7, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_query', 8, NULL, 'YES', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_operation_state', 9, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_tables_in_use', 10, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_tables_locked', 11, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_lock_structs', 12, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_lock_memory_bytes', 13, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_rows_locked', 14, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_rows_modified', 15, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_concurrency_tickets', 16, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_isolation_level', 17, '', 'NO', 'varchar', 16, 48, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(16)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_unique_checks', 18, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(1)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_foreign_key_checks', 19, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(1)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_last_foreign_key_error', 20, NULL, 'YES', 'varchar', 256, 768, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(256)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_adaptive_hash_latched', 21, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(1)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_TRX', 'trx_adaptive_hash_timeout', 22, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'POOL_ID', 1, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'POOL_SIZE', 2, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'FREE_BUFFERS', 3, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'DATABASE_PAGES', 4, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'OLD_DATABASE_PAGES', 5, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'MODIFIED_DATABASE_PAGES', 6, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'PENDING_DECOMPRESS', 7, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'PENDING_READS', 8, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'PENDING_FLUSH_LRU', 9, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'PENDING_FLUSH_LIST', 10, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'PAGES_MADE_YOUNG', 11, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'PAGES_NOT_MADE_YOUNG', 12, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'PAGES_MADE_YOUNG_RATE', 13, '0', 'NO', 'double', NULL, NULL, 12, NULL, NULL, NULL, 'double', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'PAGES_MADE_NOT_YOUNG_RATE', 14, '0', 'NO', 'double', NULL, NULL, 12, NULL, NULL, NULL, 'double', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'NUMBER_PAGES_READ', 15, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'NUMBER_PAGES_CREATED', 16, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'NUMBER_PAGES_WRITTEN', 17, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'PAGES_READ_RATE', 18, '0', 'NO', 'double', NULL, NULL, 12, NULL, NULL, NULL, 'double', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'PAGES_CREATE_RATE', 19, '0', 'NO', 'double', NULL, NULL, 12, NULL, NULL, NULL, 'double', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'PAGES_WRITTEN_RATE', 20, '0', 'NO', 'double', NULL, NULL, 12, NULL, NULL, NULL, 'double', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'NUMBER_PAGES_GET', 21, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'HIT_RATE', 22, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'YOUNG_MAKE_PER_THOUSAND_GETS', 23, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'NOT_YOUNG_MAKE_PER_THOUSAND_GETS', 24, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'NUMBER_PAGES_READ_AHEAD', 25, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'NUMBER_READ_AHEAD_EVICTED', 26, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'READ_AHEAD_RATE', 27, '0', 'NO', 'double', NULL, NULL, 12, NULL, NULL, NULL, 'double', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'READ_AHEAD_EVICTED_RATE', 28, '0', 'NO', 'double', NULL, NULL, 12, NULL, NULL, NULL, 'double', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'LRU_IO_TOTAL', 29, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'LRU_IO_CURRENT', 30, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'UNCOMPRESS_TOTAL', 31, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'UNCOMPRESS_CURRENT', 32, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCK_WAITS', 'requesting_trx_id', 1, '', 'NO', 'varchar', 18, 54, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(18)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCK_WAITS', 'requested_lock_id', 2, '', 'NO', 'varchar', 81, 243, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(81)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCK_WAITS', 'blocking_trx_id', 3, '', 'NO', 'varchar', 18, 54, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(18)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCK_WAITS', 'blocking_lock_id', 4, '', 'NO', 'varchar', 81, 243, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(81)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM', 'page_size', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(5)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM', 'buffer_pool_instance', 2, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM', 'pages_used', 3, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM', 'pages_free', 4, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM', 'relocation_ops', 5, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(21)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM', 'relocation_time', 6, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP', 'page_size', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(5)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP', 'compress_ops', 2, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP', 'compress_ops_ok', 3, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP', 'compress_time', 4, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP', 'uncompress_ops', 5, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP', 'uncompress_time', 6, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCKS', 'lock_id', 1, '', 'NO', 'varchar', 81, 243, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(81)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCKS', 'lock_trx_id', 2, '', 'NO', 'varchar', 18, 54, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(18)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCKS', 'lock_mode', 3, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCKS', 'lock_type', 4, '', 'NO', 'varchar', 32, 96, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(32)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCKS', 'lock_table', 5, '', 'NO', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCKS', 'lock_index', 6, NULL, 'YES', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCKS', 'lock_space', 7, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCKS', 'lock_page', 8, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCKS', 'lock_rec', 9, NULL, 'YES', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_LOCKS', 'lock_data', 10, NULL, 'YES', 'varchar', 8192, 24576, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(8192)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM_RESET', 'page_size', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(5)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM_RESET', 'buffer_pool_instance', 2, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM_RESET', 'pages_used', 3, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM_RESET', 'pages_free', 4, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM_RESET', 'relocation_ops', 5, '0', 'NO', 'bigint', NULL, NULL, 19, 0, NULL, NULL, 'bigint(21)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMPMEM_RESET', 'relocation_time', 6, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP_RESET', 'page_size', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(5)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP_RESET', 'compress_ops', 2, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP_RESET', 'compress_ops_ok', 3, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP_RESET', 'compress_time', 4, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP_RESET', 'uncompress_ops', 5, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_CMP_RESET', 'uncompress_time', 6, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'POOL_ID', 1, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'LRU_POSITION', 2, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'SPACE', 3, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'PAGE_NUMBER', 4, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'PAGE_TYPE', 5, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'FLUSH_TYPE', 6, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'FIX_COUNT', 7, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'IS_HASHED', 8, NULL, 'YES', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'NEWEST_MODIFICATION', 9, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'OLDEST_MODIFICATION', 10, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'ACCESS_TIME', 11, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'TABLE_NAME', 12, NULL, 'YES', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'INDEX_NAME', 13, NULL, 'YES', 'varchar', 1024, 3072, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(1024)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'NUMBER_RECORDS', 14, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'DATA_SIZE', 15, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'COMPRESSED_SIZE', 16, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'COMPRESSED', 17, NULL, 'YES', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'IO_FIX', 18, NULL, 'YES', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'IS_OLD', 19, NULL, 'YES', 'varchar', 3, 9, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(3)', '', '', 'select', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'FREE_PAGE_CLOCK', 20, '0', 'NO', 'bigint', NULL, NULL, 20, 0, NULL, NULL, 'bigint(21) unsigned', '', '', 'select', ''),
('def', 'c9mosh', 'answers', 'a_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'answers', 'q_id', 2, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'answers', 'answer', 3, NULL, 'YES', 'text', 65535, 65535, NULL, NULL, 'utf8', 'utf8_general_ci', 'text', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'campus', 'c_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'campus', 'c_name', 2, NULL, 'NO', 'varchar', 30, 90, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(30)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'campus', 'c_lat', 3, NULL, 'YES', 'double', NULL, NULL, 22, NULL, NULL, NULL, 'double', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'campus', 'c_lng', 4, NULL, 'YES', 'double', NULL, NULL, 22, NULL, NULL, NULL, 'double', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'clue', 'clue_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'clue', 'clue_typ_id', 2, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'clue', 'clue_text', 3, NULL, 'YES', 'text', 65535, 65535, NULL, NULL, 'utf8', 'utf8_general_ci', 'text', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'clue', 'clue_audio', 4, NULL, 'YES', 'text', 65535, 65535, NULL, NULL, 'utf8', 'utf8_general_ci', 'text', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'clue', 'clue_image', 5, NULL, 'YES', 'text', 65535, 65535, NULL, NULL, 'utf8', 'utf8_general_ci', 'text', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'clue_question', 'clue_id', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'clue_question', 'q_id', 2, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'clue_type', 'clue_typ_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'clue_type', 'typ_desc', 2, NULL, 'YES', 'text', 65535, 65535, NULL, NULL, 'utf8', 'utf8_general_ci', 'text', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'dic', 'td_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'dic', 'direction', 2, NULL, 'YES', 'text', 65535, 65535, NULL, NULL, 'utf8', 'utf8_general_ci', 'text', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'dic', 'audio', 3, NULL, 'YES', 'text', 65535, 65535, NULL, NULL, 'utf8', 'utf8_general_ci', 'text', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'dic', 'image', 4, NULL, 'YES', 'text', 65535, 65535, NULL, NULL, 'utf8', 'utf8_general_ci', 'text', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'dic', 'td_lat', 5, NULL, 'YES', 'double', NULL, NULL, 22, NULL, NULL, NULL, 'double', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'dic', 'td_lng', 6, NULL, 'YES', 'double', NULL, NULL, 22, NULL, NULL, NULL, 'double', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'dic_question', 'td_id', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'dic_question', 'q_id', 2, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'game', 'g_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'game', 'start_time', 2, '0000-00-00 00:00:00', 'NO', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'game', 'finis_time', 3, '0000-00-00 00:00:00', 'NO', 'datetime', NULL, NULL, NULL, NULL, NULL, NULL, 'datetime', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'game_task', 'tsk_id', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'game_task', 'g_id', 2, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'game_task', 'prv_tsk_id', 3, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'login', 'login_name', 1, NULL, 'NO', 'varchar', 30, 90, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(30)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'login', 'login_pass', 2, NULL, 'NO', 'varchar', 64, 192, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(64)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'login', 'u_id', 3, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'UNI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'login', 'p_id', 4, '0', 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'permissions', 'p_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'permissions', 'p_desc', 2, NULL, 'YES', 'varchar', 100, 300, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(100)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'progress', 't_id', 1, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'progress', 'u_id', 2, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'progress', 'tsk_id', 3, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'progress', 'status', 4, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'progress', 'currenttime', 5, 'CURRENT_TIMESTAMP', 'NO', 'timestamp', NULL, NULL, NULL, NULL, NULL, NULL, 'timestamp', '', 'on update CURRENT_TIMESTAMP', 'select,insert,update,references', ''),
('def', 'c9mosh', 'question_type', 'q_typ_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'question_type', 'typ_desc', 2, NULL, 'YES', 'text', 65535, 65535, NULL, NULL, 'utf8', 'utf8_general_ci', 'text', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'questions', 'q_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'questions', 'q_typ_id', 2, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'questions', 'q_text', 3, NULL, 'YES', 'text', 65535, 65535, NULL, NULL, 'utf8', 'utf8_general_ci', 'text', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'responses', 'r_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'responses', 't_id', 2, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'responses', 'u_id', 3, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'responses', 'tsk_id', 4, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'responses', 'q_id', 5, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'responses', 'q_status', 6, '0', 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'responses', 'response', 7, NULL, 'YES', 'varchar', 150, 450, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(150)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'responses', 'location', 8, NULL, 'YES', 'text', 65535, 65535, NULL, NULL, 'utf8', 'utf8_general_ci', 'text', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'task_dic', 'tsk_id', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'task_dic', 'td_id', 2, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'tasks', 'tsk_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'tasks', 'tsk_name', 2, NULL, 'YES', 'varchar', 100, 300, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(100)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'tasks', 'secret_id', 3, NULL, 'NO', 'varchar', 30, 90, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(30)', 'UNI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'tasks', 'c_id', 4, NULL, 'YES', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'MUL', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'team_game', 't_id', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'team_game', 'g_id', 2, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'team_user', 't_id', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'team_user', 'u_id', 2, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'teams', 't_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'teams', 't_name', 2, NULL, 'NO', 'varchar', 30, 90, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(30)', 'UNI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'teams', 't_chat_id', 3, NULL, 'NO', 'varchar', 24, 72, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(24)', 'UNI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'user_options', 'u_id', 1, '0', 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'user_options', 'p_vsbl_tm', 2, '1', 'YES', 'tinyint', NULL, NULL, 3, 0, NULL, NULL, 'tinyint(1)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'user_options', 'e_vsbl_tm', 3, '1', 'YES', 'tinyint', NULL, NULL, 3, 0, NULL, NULL, 'tinyint(1)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'users', 'u_id', 1, NULL, 'NO', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PRI', 'auto_increment', 'select,insert,update,references', ''),
('def', 'c9mosh', 'users', 'u_nickname', 2, NULL, 'YES', 'varchar', 30, 90, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(30)', 'UNI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'users', 'u_fname', 3, NULL, 'YES', 'varchar', 30, 90, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(30)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'users', 'u_lastname', 4, NULL, 'YES', 'varchar', 30, 90, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(30)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'users', 'u_email', 5, NULL, 'YES', 'varchar', 100, 300, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(100)', 'UNI', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'users', 'u_phone', 6, NULL, 'YES', 'varchar', 10, 30, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(10)', '', '', 'select,insert,update,references', ''),
('def', 'c9mosh', 'users', 's_num', 7, NULL, 'NO', 'varchar', 9, 27, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(9)', 'UNI', '', 'select,insert,update,references', '');

-- --------------------------------------------------------

--
-- Table structure for table `COLUMN_PRIVILEGES`
--

CREATE TEMPORARY TABLE `COLUMN_PRIVILEGES` (
  `GRANTEE` varchar(81) NOT NULL DEFAULT '',
  `TABLE_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `TABLE_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `TABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `COLUMN_NAME` varchar(64) NOT NULL DEFAULT '',
  `PRIVILEGE_TYPE` varchar(64) NOT NULL DEFAULT '',
  `IS_GRANTABLE` varchar(3) NOT NULL DEFAULT ''
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ENGINES`
--

CREATE TEMPORARY TABLE `ENGINES` (
  `ENGINE` varchar(64) NOT NULL DEFAULT '',
  `SUPPORT` varchar(8) NOT NULL DEFAULT '',
  `COMMENT` varchar(80) NOT NULL DEFAULT '',
  `TRANSACTIONS` varchar(3) DEFAULT NULL,
  `XA` varchar(3) DEFAULT NULL,
  `SAVEPOINTS` varchar(3) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ENGINES`
--

INSERT INTO `ENGINES` (`ENGINE`, `SUPPORT`, `COMMENT`, `TRANSACTIONS`, `XA`, `SAVEPOINTS`) VALUES
('MyISAM', 'YES', 'MyISAM storage engine', 'NO', 'NO', 'NO'),
('MRG_MYISAM', 'YES', 'Collection of identical MyISAM tables', 'NO', 'NO', 'NO'),
('MEMORY', 'YES', 'Hash based, stored in memory, useful for temporary tables', 'NO', 'NO', 'NO'),
('BLACKHOLE', 'YES', '/dev/null storage engine (anything you write to it disappears)', 'NO', 'NO', 'NO'),
('CSV', 'YES', 'CSV storage engine', 'NO', 'NO', 'NO'),
('FEDERATED', 'NO', 'Federated MySQL storage engine', NULL, NULL, NULL),
('ARCHIVE', 'YES', 'Archive storage engine', 'NO', 'NO', 'NO'),
('InnoDB', 'DEFAULT', 'Supports transactions, row-level locking, and foreign keys', 'YES', 'YES', 'YES'),
('PERFORMANCE_SCHEMA', 'YES', 'Performance Schema', 'NO', 'NO', 'NO');

-- --------------------------------------------------------

--
-- Table structure for table `EVENTS`
--

CREATE TEMPORARY TABLE `EVENTS` (
  `EVENT_CATALOG` varchar(64) NOT NULL DEFAULT '',
  `EVENT_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `EVENT_NAME` varchar(64) NOT NULL DEFAULT '',
  `DEFINER` varchar(77) NOT NULL DEFAULT '',
  `TIME_ZONE` varchar(64) NOT NULL DEFAULT '',
  `EVENT_BODY` varchar(8) NOT NULL DEFAULT '',
  `EVENT_DEFINITION` longtext NOT NULL,
  `EVENT_TYPE` varchar(9) NOT NULL DEFAULT '',
  `EXECUTE_AT` datetime DEFAULT NULL,
  `INTERVAL_VALUE` varchar(256) DEFAULT NULL,
  `INTERVAL_FIELD` varchar(18) DEFAULT NULL,
  `SQL_MODE` varchar(8192) NOT NULL DEFAULT '',
  `STARTS` datetime DEFAULT NULL,
  `ENDS` datetime DEFAULT NULL,
  `STATUS` varchar(18) NOT NULL DEFAULT '',
  `ON_COMPLETION` varchar(12) NOT NULL DEFAULT '',
  `CREATED` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `LAST_ALTERED` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `LAST_EXECUTED` datetime DEFAULT NULL,
  `EVENT_COMMENT` varchar(64) NOT NULL DEFAULT '',
  `ORIGINATOR` bigint(10) NOT NULL DEFAULT '0',
  `CHARACTER_SET_CLIENT` varchar(32) NOT NULL DEFAULT '',
  `COLLATION_CONNECTION` varchar(32) NOT NULL DEFAULT '',
  `DATABASE_COLLATION` varchar(32) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `FILES`
--

CREATE TEMPORARY TABLE `FILES` (
  `FILE_ID` bigint(4) NOT NULL DEFAULT '0',
  `FILE_NAME` varchar(64) DEFAULT NULL,
  `FILE_TYPE` varchar(20) NOT NULL DEFAULT '',
  `TABLESPACE_NAME` varchar(64) DEFAULT NULL,
  `TABLE_CATALOG` varchar(64) NOT NULL DEFAULT '',
  `TABLE_SCHEMA` varchar(64) DEFAULT NULL,
  `TABLE_NAME` varchar(64) DEFAULT NULL,
  `LOGFILE_GROUP_NAME` varchar(64) DEFAULT NULL,
  `LOGFILE_GROUP_NUMBER` bigint(4) DEFAULT NULL,
  `ENGINE` varchar(64) NOT NULL DEFAULT '',
  `FULLTEXT_KEYS` varchar(64) DEFAULT NULL,
  `DELETED_ROWS` bigint(4) DEFAULT NULL,
  `UPDATE_COUNT` bigint(4) DEFAULT NULL,
  `FREE_EXTENTS` bigint(4) DEFAULT NULL,
  `TOTAL_EXTENTS` bigint(4) DEFAULT NULL,
  `EXTENT_SIZE` bigint(4) NOT NULL DEFAULT '0',
  `INITIAL_SIZE` bigint(21) unsigned DEFAULT NULL,
  `MAXIMUM_SIZE` bigint(21) unsigned DEFAULT NULL,
  `AUTOEXTEND_SIZE` bigint(21) unsigned DEFAULT NULL,
  `CREATION_TIME` datetime DEFAULT NULL,
  `LAST_UPDATE_TIME` datetime DEFAULT NULL,
  `LAST_ACCESS_TIME` datetime DEFAULT NULL,
  `RECOVER_TIME` bigint(4) DEFAULT NULL,
  `TRANSACTION_COUNTER` bigint(4) DEFAULT NULL,
  `VERSION` bigint(21) unsigned DEFAULT NULL,
  `ROW_FORMAT` varchar(10) DEFAULT NULL,
  `TABLE_ROWS` bigint(21) unsigned DEFAULT NULL,
  `AVG_ROW_LENGTH` bigint(21) unsigned DEFAULT NULL,
  `DATA_LENGTH` bigint(21) unsigned DEFAULT NULL,
  `MAX_DATA_LENGTH` bigint(21) unsigned DEFAULT NULL,
  `INDEX_LENGTH` bigint(21) unsigned DEFAULT NULL,
  `DATA_FREE` bigint(21) unsigned DEFAULT NULL,
  `CREATE_TIME` datetime DEFAULT NULL,
  `UPDATE_TIME` datetime DEFAULT NULL,
  `CHECK_TIME` datetime DEFAULT NULL,
  `CHECKSUM` bigint(21) unsigned DEFAULT NULL,
  `STATUS` varchar(20) NOT NULL DEFAULT '',
  `EXTRA` varchar(255) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `GLOBAL_STATUS`
--

CREATE TEMPORARY TABLE `GLOBAL_STATUS` (
  `VARIABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `GLOBAL_STATUS`
--

INSERT INTO `GLOBAL_STATUS` (`VARIABLE_NAME`, `VARIABLE_VALUE`) VALUES
('ABORTED_CLIENTS', '18'),
('ABORTED_CONNECTS', '11024'),
('BINLOG_CACHE_DISK_USE', '0'),
('BINLOG_CACHE_USE', '0'),
('BINLOG_STMT_CACHE_DISK_USE', '0'),
('BINLOG_STMT_CACHE_USE', '0'),
('BYTES_RECEIVED', '4190783134'),
('BYTES_SENT', '61286105288'),
('COM_ADMIN_COMMANDS', '424982'),
('COM_ASSIGN_TO_KEYCACHE', '0'),
('COM_ALTER_DB', '0'),
('COM_ALTER_DB_UPGRADE', '0'),
('COM_ALTER_EVENT', '0'),
('COM_ALTER_FUNCTION', '0'),
('COM_ALTER_PROCEDURE', '0'),
('COM_ALTER_SERVER', '0'),
('COM_ALTER_TABLE', '349'),
('COM_ALTER_TABLESPACE', '0'),
('COM_ANALYZE', '0'),
('COM_BEGIN', '821'),
('COM_BINLOG', '0'),
('COM_CALL_PROCEDURE', '181'),
('COM_CHANGE_DB', '1149117'),
('COM_CHANGE_MASTER', '0'),
('COM_CHECK', '0'),
('COM_CHECKSUM', '0'),
('COM_COMMIT', '1282'),
('COM_CREATE_DB', '2'),
('COM_CREATE_EVENT', '0'),
('COM_CREATE_FUNCTION', '0'),
('COM_CREATE_INDEX', '0'),
('COM_CREATE_PROCEDURE', '33'),
('COM_CREATE_SERVER', '0'),
('COM_CREATE_TABLE', '1223'),
('COM_CREATE_TRIGGER', '0'),
('COM_CREATE_UDF', '0'),
('COM_CREATE_USER', '0'),
('COM_CREATE_VIEW', '0'),
('COM_DEALLOC_SQL', '0'),
('COM_DELETE', '188972'),
('COM_DELETE_MULTI', '2'),
('COM_DO', '0'),
('COM_DROP_DB', '0'),
('COM_DROP_EVENT', '0'),
('COM_DROP_FUNCTION', '0'),
('COM_DROP_INDEX', '0'),
('COM_DROP_PROCEDURE', '24'),
('COM_DROP_SERVER', '0'),
('COM_DROP_TABLE', '1741'),
('COM_DROP_TRIGGER', '0'),
('COM_DROP_USER', '0'),
('COM_DROP_VIEW', '0'),
('COM_EMPTY_QUERY', '2'),
('COM_EXECUTE_SQL', '0'),
('COM_FLUSH', '38'),
('COM_GRANT', '4'),
('COM_HA_CLOSE', '0'),
('COM_HA_OPEN', '0'),
('COM_HA_READ', '0'),
('COM_HELP', '1'),
('COM_INSERT', '192240'),
('COM_INSERT_SELECT', '0'),
('COM_INSTALL_PLUGIN', '0'),
('COM_KILL', '0'),
('COM_LOAD', '0'),
('COM_LOCK_TABLES', '0'),
('COM_OPTIMIZE', '0'),
('COM_PRELOAD_KEYS', '0'),
('COM_PREPARE_SQL', '0'),
('COM_PURGE', '0'),
('COM_PURGE_BEFORE_DATE', '0'),
('COM_RELEASE_SAVEPOINT', '0'),
('COM_RENAME_TABLE', '0'),
('COM_RENAME_USER', '0'),
('COM_REPAIR', '0'),
('COM_REPLACE', '0'),
('COM_REPLACE_SELECT', '0'),
('COM_RESET', '0'),
('COM_RESIGNAL', '0'),
('COM_REVOKE', '0'),
('COM_REVOKE_ALL', '0'),
('COM_ROLLBACK', '24'),
('COM_ROLLBACK_TO_SAVEPOINT', '0'),
('COM_SAVEPOINT', '0'),
('COM_SELECT', '2515758'),
('COM_SET_OPTION', '567611'),
('COM_SIGNAL', '0'),
('COM_SHOW_AUTHORS', '0'),
('COM_SHOW_BINLOG_EVENTS', '0'),
('COM_SHOW_BINLOGS', '154'),
('COM_SHOW_CHARSETS', '0'),
('COM_SHOW_COLLATIONS', '135'),
('COM_SHOW_CONTRIBUTORS', '0'),
('COM_SHOW_CREATE_DB', '0'),
('COM_SHOW_CREATE_EVENT', '0'),
('COM_SHOW_CREATE_FUNC', '0'),
('COM_SHOW_CREATE_PROC', '322'),
('COM_SHOW_CREATE_TABLE', '2141'),
('COM_SHOW_CREATE_TRIGGER', '0'),
('COM_SHOW_DATABASES', '342'),
('COM_SHOW_ENGINE_LOGS', '0'),
('COM_SHOW_ENGINE_MUTEX', '0'),
('COM_SHOW_ENGINE_STATUS', '0'),
('COM_SHOW_EVENTS', '0'),
('COM_SHOW_ERRORS', '0'),
('COM_SHOW_FIELDS', '3981'),
('COM_SHOW_FUNCTION_STATUS', '8'),
('COM_SHOW_GRANTS', '131'),
('COM_SHOW_KEYS', '1474'),
('COM_SHOW_MASTER_STATUS', '134'),
('COM_SHOW_OPEN_TABLES', '0'),
('COM_SHOW_PLUGINS', '3803'),
('COM_SHOW_PRIVILEGES', '0'),
('COM_SHOW_PROCEDURE_STATUS', '11'),
('COM_SHOW_PROCESSLIST', '0'),
('COM_SHOW_PROFILE', '0'),
('COM_SHOW_PROFILES', '0'),
('COM_SHOW_RELAYLOG_EVENTS', '0'),
('COM_SHOW_SLAVE_HOSTS', '0'),
('COM_SHOW_SLAVE_STATUS', '133'),
('COM_SHOW_STATUS', '1'),
('COM_SHOW_STORAGE_ENGINES', '1'),
('COM_SHOW_TABLE_STATUS', '5565'),
('COM_SHOW_TABLES', '1205'),
('COM_SHOW_TRIGGERS', '306'),
('COM_SHOW_VARIABLES', '1674'),
('COM_SHOW_WARNINGS', '52'),
('COM_SLAVE_START', '0'),
('COM_SLAVE_STOP', '0'),
('COM_STMT_CLOSE', '0'),
('COM_STMT_EXECUTE', '0'),
('COM_STMT_FETCH', '0'),
('COM_STMT_PREPARE', '0'),
('COM_STMT_REPREPARE', '0'),
('COM_STMT_RESET', '0'),
('COM_STMT_SEND_LONG_DATA', '0'),
('COM_TRUNCATE', '0'),
('COM_UNINSTALL_PLUGIN', '0'),
('COM_UNLOCK_TABLES', '0'),
('COM_UPDATE', '69465'),
('COM_UPDATE_MULTI', '0'),
('COM_XA_COMMIT', '0'),
('COM_XA_END', '0'),
('COM_XA_PREPARE', '0'),
('COM_XA_RECOVER', '0'),
('COM_XA_ROLLBACK', '0'),
('COM_XA_START', '0'),
('COMPRESSION', 'OFF'),
('CONNECTIONS', '278621'),
('CREATED_TMP_DISK_TABLES', '410052'),
('CREATED_TMP_FILES', '461'),
('CREATED_TMP_TABLES', '712442'),
('DELAYED_ERRORS', '0'),
('DELAYED_INSERT_THREADS', '0'),
('DELAYED_WRITES', '0'),
('FLUSH_COMMANDS', '1'),
('HANDLER_COMMIT', '2323591'),
('HANDLER_DELETE', '196736'),
('HANDLER_DISCOVER', '0'),
('HANDLER_PREPARE', '0'),
('HANDLER_READ_FIRST', '22611'),
('HANDLER_READ_KEY', '491832855'),
('HANDLER_READ_LAST', '135'),
('HANDLER_READ_NEXT', '1035707567'),
('HANDLER_READ_PREV', '7445021'),
('HANDLER_READ_RND', '15943476'),
('HANDLER_READ_RND_NEXT', '1567047061'),
('HANDLER_ROLLBACK', '442'),
('HANDLER_SAVEPOINT', '0'),
('HANDLER_SAVEPOINT_ROLLBACK', '0'),
('HANDLER_UPDATE', '69826'),
('HANDLER_WRITE', '944104302'),
('INNODB_BUFFER_POOL_PAGES_DATA', '4394'),
('INNODB_BUFFER_POOL_PAGES_DIRTY', '1'),
('INNODB_BUFFER_POOL_PAGES_FLUSHED', '280215'),
('INNODB_BUFFER_POOL_PAGES_FREE', '3575'),
('INNODB_BUFFER_POOL_PAGES_MISC', '223'),
('INNODB_BUFFER_POOL_PAGES_TOTAL', '8192'),
('INNODB_BUFFER_POOL_READ_AHEAD_RND', '0'),
('INNODB_BUFFER_POOL_READ_AHEAD', '1251'),
('INNODB_BUFFER_POOL_READ_AHEAD_EVICTED', '0'),
('INNODB_BUFFER_POOL_READ_REQUESTS', '3304736131'),
('INNODB_BUFFER_POOL_READS', '2627'),
('INNODB_BUFFER_POOL_WAIT_FREE', '0'),
('INNODB_BUFFER_POOL_WRITE_REQUESTS', '949044'),
('INNODB_DATA_FSYNCS', '253684'),
('INNODB_DATA_PENDING_FSYNCS', '0'),
('INNODB_DATA_PENDING_READS', '0'),
('INNODB_DATA_PENDING_WRITES', '0'),
('INNODB_DATA_READ', '65753088'),
('INNODB_DATA_READS', '2745'),
('INNODB_DATA_WRITES', '457995'),
('INNODB_DATA_WRITTEN', '9328371200'),
('INNODB_DBLWR_PAGES_WRITTEN', '280215'),
('INNODB_DBLWR_WRITES', '50821'),
('INNODB_HAVE_ATOMIC_BUILTINS', 'ON'),
('INNODB_LOG_WAITS', '0'),
('INNODB_LOG_WRITE_REQUESTS', '175058'),
('INNODB_LOG_WRITES', '103322'),
('INNODB_OS_LOG_FSYNCS', '152200'),
('INNODB_OS_LOG_PENDING_FSYNCS', '0'),
('INNODB_OS_LOG_PENDING_WRITES', '0'),
('INNODB_OS_LOG_WRITTEN', '121351168'),
('INNODB_PAGE_SIZE', '16384'),
('INNODB_PAGES_CREATED', '515'),
('INNODB_PAGES_READ', '3879'),
('INNODB_PAGES_WRITTEN', '280215'),
('INNODB_ROW_LOCK_CURRENT_WAITS', '0'),
('INNODB_ROW_LOCK_TIME', '621'),
('INNODB_ROW_LOCK_TIME_AVG', '19'),
('INNODB_ROW_LOCK_TIME_MAX', '51'),
('INNODB_ROW_LOCK_WAITS', '32'),
('INNODB_ROWS_DELETED', '20862'),
('INNODB_ROWS_INSERTED', '20316'),
('INNODB_ROWS_READ', '2143134374'),
('INNODB_ROWS_UPDATED', '69345'),
('INNODB_TRUNCATED_STATUS_WRITES', '0'),
('KEY_BLOCKS_NOT_FLUSHED', '0'),
('KEY_BLOCKS_UNUSED', '13340'),
('KEY_BLOCKS_USED', '230'),
('KEY_READ_REQUESTS', '1789660326'),
('KEY_READS', '46'),
('KEY_WRITE_REQUESTS', '502456742'),
('KEY_WRITES', '1406826'),
('LAST_QUERY_COST', '0.000000'),
('MAX_USED_CONNECTIONS', '41'),
('NOT_FLUSHED_DELAYED_ROWS', '0'),
('OPEN_FILES', '176'),
('OPEN_STREAMS', '0'),
('OPEN_TABLE_DEFINITIONS', '306'),
('OPEN_TABLES', '354'),
('OPENED_FILES', '1648635'),
('OPENED_TABLE_DEFINITIONS', '3205'),
('OPENED_TABLES', '6282'),
('PERFORMANCE_SCHEMA_COND_CLASSES_LOST', '0'),
('PERFORMANCE_SCHEMA_COND_INSTANCES_LOST', '0'),
('PERFORMANCE_SCHEMA_FILE_CLASSES_LOST', '0'),
('PERFORMANCE_SCHEMA_FILE_HANDLES_LOST', '0'),
('PERFORMANCE_SCHEMA_FILE_INSTANCES_LOST', '0'),
('PERFORMANCE_SCHEMA_LOCKER_LOST', '0'),
('PERFORMANCE_SCHEMA_MUTEX_CLASSES_LOST', '0'),
('PERFORMANCE_SCHEMA_MUTEX_INSTANCES_LOST', '0'),
('PERFORMANCE_SCHEMA_RWLOCK_CLASSES_LOST', '0'),
('PERFORMANCE_SCHEMA_RWLOCK_INSTANCES_LOST', '0'),
('PERFORMANCE_SCHEMA_TABLE_HANDLES_LOST', '0'),
('PERFORMANCE_SCHEMA_TABLE_INSTANCES_LOST', '0'),
('PERFORMANCE_SCHEMA_THREAD_CLASSES_LOST', '0'),
('PERFORMANCE_SCHEMA_THREAD_INSTANCES_LOST', '0'),
('PREPARED_STMT_COUNT', '0'),
('QCACHE_FREE_BLOCKS', '1041'),
('QCACHE_FREE_MEMORY', '3370520'),
('QCACHE_HITS', '17372122'),
('QCACHE_INSERTS', '2075265'),
('QCACHE_LOWMEM_PRUNES', '1049740'),
('QCACHE_NOT_CACHED', '440229'),
('QCACHE_QUERIES_IN_CACHE', '3656'),
('QCACHE_TOTAL_BLOCKS', '8815'),
('QUERIES', '22350534'),
('QUESTIONS', '22350357'),
('RPL_STATUS', 'AUTH_MASTER'),
('SELECT_FULL_JOIN', '831'),
('SELECT_FULL_RANGE_JOIN', '3'),
('SELECT_RANGE', '857638'),
('SELECT_RANGE_CHECK', '0'),
('SELECT_SCAN', '31858'),
('SLAVE_HEARTBEAT_PERIOD', '0.000'),
('SLAVE_OPEN_TEMP_TABLES', '0'),
('SLAVE_RECEIVED_HEARTBEATS', '0'),
('SLAVE_RETRIED_TRANSACTIONS', '0'),
('SLAVE_RUNNING', 'OFF'),
('SLOW_LAUNCH_THREADS', '0'),
('SLOW_QUERIES', '5'),
('SORT_MERGE_PASSES', '167'),
('SORT_RANGE', '134126'),
('SORT_ROWS', '497187613'),
('SORT_SCAN', '680045'),
('SSL_ACCEPT_RENEGOTIATES', '0'),
('SSL_ACCEPTS', '0'),
('SSL_CALLBACK_CACHE_HITS', '0'),
('SSL_CIPHER', ''),
('SSL_CIPHER_LIST', ''),
('SSL_CLIENT_CONNECTS', '0'),
('SSL_CONNECT_RENEGOTIATES', '0'),
('SSL_CTX_VERIFY_DEPTH', '0'),
('SSL_CTX_VERIFY_MODE', '0'),
('SSL_DEFAULT_TIMEOUT', '0'),
('SSL_FINISHED_ACCEPTS', '0'),
('SSL_FINISHED_CONNECTS', '0'),
('SSL_SESSION_CACHE_HITS', '0'),
('SSL_SESSION_CACHE_MISSES', '0'),
('SSL_SESSION_CACHE_MODE', 'NONE'),
('SSL_SESSION_CACHE_OVERFLOWS', '0'),
('SSL_SESSION_CACHE_SIZE', '0'),
('SSL_SESSION_CACHE_TIMEOUTS', '0'),
('SSL_SESSIONS_REUSED', '0'),
('SSL_USED_SESSION_CACHE_ENTRIES', '0'),
('SSL_VERIFY_DEPTH', '0'),
('SSL_VERIFY_MODE', '0'),
('SSL_VERSION', ''),
('TABLE_LOCKS_IMMEDIATE', '3702857'),
('TABLE_LOCKS_WAITED', '1'),
('TC_LOG_MAX_PAGES_USED', '0'),
('TC_LOG_PAGE_SIZE', '0'),
('TC_LOG_PAGE_WAITS', '0'),
('THREADS_CACHED', '5'),
('THREADS_CONNECTED', '3'),
('THREADS_CREATED', '588'),
('THREADS_RUNNING', '1'),
('UPTIME', '2480530'),
('UPTIME_SINCE_FLUSH_STATUS', '2480530');

-- --------------------------------------------------------

--
-- Table structure for table `GLOBAL_VARIABLES`
--

CREATE TEMPORARY TABLE `GLOBAL_VARIABLES` (
  `VARIABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `GLOBAL_VARIABLES`
--

INSERT INTO `GLOBAL_VARIABLES` (`VARIABLE_NAME`, `VARIABLE_VALUE`) VALUES
('MAX_PREPARED_STMT_COUNT', '16382'),
('INNODB_FILE_PER_TABLE', 'OFF'),
('HAVE_CRYPT', 'YES'),
('PERFORMANCE_SCHEMA_EVENTS_WAITS_HISTORY_LONG_SIZE', '10000'),
('INNODB_VERSION', '1.1.8'),
('QUERY_PREALLOC_SIZE', '8192'),
('DELAYED_QUEUE_SIZE', '1000'),
('PERFORMANCE_SCHEMA_MAX_COND_INSTANCES', '1000'),
('HAVE_SSL', 'DISABLED'),
('COLLATION_SERVER', 'latin1_swedish_ci'),
('SECURE_FILE_PRIV', ''),
('TIMED_MUTEXES', 'OFF'),
('DELAYED_INSERT_TIMEOUT', '300'),
('PERFORMANCE_SCHEMA_MAX_MUTEX_INSTANCES', '1000000'),
('PLUGIN_DIR', '/usr/lib/mysql/plugin/'),
('PERFORMANCE_SCHEMA_MAX_RWLOCK_INSTANCES', '1000000'),
('LOG_SLOW_QUERIES', 'OFF'),
('PERFORMANCE_SCHEMA_MAX_RWLOCK_CLASSES', '30'),
('BASEDIR', '/usr'),
('PERFORMANCE_SCHEMA_MAX_MUTEX_CLASSES', '200'),
('UPDATABLE_VIEWS_WITH_LIMIT', 'YES'),
('BACK_LOG', '50'),
('SLOW_LAUNCH_TIME', '2'),
('EVENT_SCHEDULER', 'OFF'),
('MAX_SEEKS_FOR_KEY', '18446744073709551615'),
('PERFORMANCE_SCHEMA_MAX_THREAD_CLASSES', '50'),
('RELAY_LOG_INDEX', ''),
('FT_STOPWORD_FILE', '(built-in)'),
('SQL_QUOTE_SHOW_CREATE', 'ON'),
('PERFORMANCE_SCHEMA', 'OFF'),
('QUERY_CACHE_SIZE', '16777216'),
('BINLOG_FORMAT', 'STATEMENT'),
('WAIT_TIMEOUT', '28800'),
('LONG_QUERY_TIME', '10.000000'),
('PERFORMANCE_SCHEMA_MAX_TABLE_HANDLES', '100000'),
('CHARACTER_SETS_DIR', '/usr/share/mysql/charsets/'),
('LOWER_CASE_TABLE_NAMES', '0'),
('BINLOG_CACHE_SIZE', '32768'),
('REPORT_HOST', ''),
('CHARACTER_SET_RESULTS', 'latin1'),
('MYISAM_SORT_BUFFER_SIZE', '8388608'),
('CHARACTER_SET_CONNECTION', 'latin1'),
('INNODB_ROLLBACK_SEGMENTS', '128'),
('PRELOAD_BUFFER_SIZE', '32768'),
('LARGE_FILES_SUPPORT', 'ON'),
('MAX_WRITE_LOCK_COUNT', '18446744073709551615'),
('LOG_SLAVE_UPDATES', 'OFF'),
('SYNC_MASTER_INFO', '0'),
('NET_BUFFER_LENGTH', '16384'),
('FT_QUERY_EXPANSION_LIMIT', '20'),
('SKIP_SHOW_DATABASE', 'OFF'),
('FT_MAX_WORD_LEN', '84'),
('GROUP_CONCAT_MAX_LEN', '1024'),
('MAX_SP_RECURSION_DEPTH', '0'),
('RANGE_ALLOC_BLOCK_SIZE', '4096'),
('RELAY_LOG', ''),
('OPTIMIZER_PRUNE_LEVEL', '1'),
('INNODB_FLUSH_METHOD', ''),
('INNODB_LOG_FILE_SIZE', '5242880'),
('DELAY_KEY_WRITE', 'ON'),
('TRANSACTION_PREALLOC_SIZE', '4096'),
('INTERACTIVE_TIMEOUT', '28800'),
('MYISAM_RECOVER_OPTIONS', 'BACKUP'),
('AUTOMATIC_SP_PRIVILEGES', 'ON'),
('INNODB_USE_SYS_MALLOC', 'ON'),
('DELAYED_INSERT_LIMIT', '100'),
('LOW_PRIORITY_UPDATES', 'OFF'),
('COMPLETION_TYPE', 'NO_CHAIN'),
('REPORT_PASSWORD', ''),
('BINLOG_DIRECT_NON_TRANSACTIONAL_UPDATES', 'OFF'),
('MAX_INSERT_DELAYED_THREADS', '20'),
('VERSION_COMMENT', '(Ubuntu)'),
('HAVE_COMPRESS', 'YES'),
('AUTO_INCREMENT_OFFSET', '1'),
('TRANSACTION_ALLOC_BLOCK_SIZE', '8192'),
('JOIN_BUFFER_SIZE', '131072'),
('THREAD_CACHE_SIZE', '8'),
('CONNECT_TIMEOUT', '10'),
('INNODB_DOUBLEWRITE', 'ON'),
('SQL_LOW_PRIORITY_UPDATES', 'OFF'),
('IGNORE_BUILTIN_INNODB', 'OFF'),
('INIT_FILE', ''),
('DEFAULT_WEEK_FORMAT', '0'),
('LARGE_PAGES', 'OFF'),
('LOG_OUTPUT', 'FILE'),
('LARGE_PAGE_SIZE', '0'),
('INNODB_IO_CAPACITY', '200'),
('INIT_SLAVE', ''),
('INNODB_USE_NATIVE_AIO', 'OFF'),
('MAX_BINLOG_SIZE', '104857600'),
('HAVE_SYMLINK', 'YES'),
('MAX_ERROR_COUNT', '64'),
('TIME_ZONE', 'SYSTEM'),
('MAX_CONNECTIONS', '151'),
('INNODB_TABLE_LOCKS', 'ON'),
('INNODB_AUTOEXTEND_INCREMENT', '8'),
('READ_BUFFER_SIZE', '131072'),
('MYISAM_DATA_POINTER_SIZE', '6'),
('INNODB_THREAD_SLEEP_DELAY', '10000'),
('LOG_QUERIES_NOT_USING_INDEXES', 'OFF'),
('SQL_AUTO_IS_NULL', 'OFF'),
('LOWER_CASE_FILE_SYSTEM', 'OFF'),
('SLAVE_TRANSACTION_RETRIES', '10'),
('SORT_BUFFER_SIZE', '2097152'),
('KEEP_FILES_ON_CREATE', 'OFF'),
('MAX_HEAP_TABLE_SIZE', '16777216'),
('SYNC_RELAY_LOG_INFO', '0'),
('LOCK_WAIT_TIMEOUT', '31536000'),
('INNODB_REPLICATION_DELAY', '0'),
('KEY_CACHE_AGE_THRESHOLD', '300'),
('QUERY_CACHE_MIN_RES_UNIT', '4096'),
('NET_RETRY_COUNT', '10'),
('INNODB_STATS_ON_METADATA', 'ON'),
('LOG_WARNINGS', '1'),
('INNODB_ROLLBACK_ON_TIMEOUT', 'OFF'),
('FLUSH', 'OFF'),
('PROFILING_HISTORY_SIZE', '15'),
('MAX_LONG_DATA_SIZE', '16777216'),
('INNODB_CHANGE_BUFFERING', 'all'),
('CHARACTER_SET_SERVER', 'latin1'),
('READ_RND_BUFFER_SIZE', '262144'),
('SLAVE_MAX_ALLOWED_PACKET', '1073741824'),
('INNODB_FILE_FORMAT', 'Antelope'),
('FLUSH_TIME', '0'),
('BIG_TABLES', 'OFF'),
('CHARACTER_SET_DATABASE', 'latin1'),
('SQL_SELECT_LIMIT', '18446744073709551615'),
('BULK_INSERT_BUFFER_SIZE', '8388608'),
('DATE_FORMAT', '%Y-%m-%d'),
('CHARACTER_SET_FILESYSTEM', 'binary'),
('READ_ONLY', 'OFF'),
('BINLOG_STMT_CACHE_SIZE', '32768'),
('MAX_BINLOG_CACHE_SIZE', '18446744073709547520'),
('INNODB_DATA_FILE_PATH', 'ibdata1:10M:autoextend'),
('PERFORMANCE_SCHEMA_MAX_FILE_CLASSES', '50'),
('INNODB_PURGE_THREADS', '0'),
('MAX_SORT_LENGTH', '1024'),
('PROFILING', 'OFF'),
('PERFORMANCE_SCHEMA_EVENTS_WAITS_HISTORY_SIZE', '10'),
('INNODB_STRICT_MODE', 'OFF'),
('SLAVE_COMPRESSED_PROTOCOL', 'OFF'),
('KEY_CACHE_DIVISION_LIMIT', '100'),
('OLD_PASSWORDS', 'OFF'),
('GENERAL_LOG_FILE', '/var/lib/mysql/wpshell.log'),
('NET_WRITE_TIMEOUT', '60'),
('PERFORMANCE_SCHEMA_MAX_COND_CLASSES', '80'),
('QUERY_CACHE_TYPE', 'ON'),
('AUTO_INCREMENT_INCREMENT', '1'),
('METADATA_LOCKS_CACHE_SIZE', '1024'),
('TMPDIR', '/tmp'),
('QUERY_CACHE_LIMIT', '1048576'),
('EXPIRE_LOGS_DAYS', '10'),
('TX_ISOLATION', 'REPEATABLE-READ'),
('HAVE_PARTITIONING', 'YES'),
('LOG_ERROR', ''),
('FOREIGN_KEY_CHECKS', 'ON'),
('MAX_LENGTH_FOR_SORT_DATA', '1024'),
('RELAY_LOG_INFO_FILE', 'relay-log.info'),
('THREAD_STACK', '196608'),
('INNODB_AUTOINC_LOCK_MODE', '1'),
('NEW', 'OFF'),
('INNODB_COMMIT_CONCURRENCY', '0'),
('SKIP_NAME_RESOLVE', 'OFF'),
('INNODB_MIRRORED_LOG_GROUPS', '1'),
('PID_FILE', '/var/run/mysqld/mysqld.pid'),
('INNODB_PURGE_BATCH_SIZE', '20'),
('MAX_CONNECT_ERRORS', '10'),
('VERSION', '5.5.29-0ubuntu0.12.04.1'),
('CONCURRENT_INSERT', 'AUTO'),
('INNODB_SUPPORT_XA', 'ON'),
('TABLE_DEFINITION_CACHE', '400'),
('INNODB_SYNC_SPIN_LOOPS', '30'),
('QUERY_ALLOC_BLOCK_SIZE', '8192'),
('COLLATION_CONNECTION', 'latin1_swedish_ci'),
('INNODB_ADDITIONAL_MEM_POOL_SIZE', '8388608'),
('INNODB_ADAPTIVE_FLUSHING', 'ON'),
('FT_BOOLEAN_SYNTAX', '+ -><()~*:""&|'),
('INNODB_ADAPTIVE_HASH_INDEX', 'ON'),
('VERSION_COMPILE_MACHINE', 'x86_64'),
('SYSTEM_TIME_ZONE', 'EST'),
('QUERY_CACHE_WLOCK_INVALIDATE', 'OFF'),
('DIV_PRECISION_INCREMENT', '4'),
('SLOW_QUERY_LOG_FILE', '/var/lib/mysql/wpshell-slow.log'),
('STORED_PROGRAM_CACHE', '256'),
('TMP_TABLE_SIZE', '16777216'),
('INNODB_DATA_HOME_DIR', ''),
('PERFORMANCE_SCHEMA_MAX_THREAD_INSTANCES', '1000'),
('INNODB_READ_IO_THREADS', '4'),
('SECURE_AUTH', 'OFF'),
('INNODB_WRITE_IO_THREADS', '4'),
('SERVER_ID', '0'),
('INNODB_BUFFER_POOL_INSTANCES', '1'),
('SKIP_NETWORKING', 'OFF'),
('INNODB_FORCE_RECOVERY', '0'),
('CHARACTER_SET_SYSTEM', 'utf8'),
('INNODB_LOG_FILES_IN_GROUP', '2'),
('INIT_CONNECT', ''),
('OPTIMIZER_SEARCH_DEPTH', '62'),
('HAVE_DYNAMIC_LOADING', 'YES'),
('AUTOCOMMIT', 'ON'),
('SYNC_BINLOG', '0'),
('SSL_CAPATH', ''),
('RELAY_LOG_SPACE_LIMIT', '0'),
('SLAVE_EXEC_MODE', 'STRICT'),
('INNODB_OPEN_FILES', '300'),
('GENERAL_LOG', 'OFF'),
('INNODB_FILE_FORMAT_CHECK', 'ON'),
('INNODB_READ_AHEAD_THRESHOLD', '56'),
('HOSTNAME', 'wpshell.sytes.net'),
('KEY_CACHE_BLOCK_SIZE', '1024'),
('SQL_LOG_OFF', 'OFF'),
('KEY_BUFFER_SIZE', '16777216'),
('REPORT_PORT', '3306'),
('HAVE_NDBCLUSTER', 'NO'),
('SQL_LOG_BIN', 'ON'),
('SSL_CIPHER', ''),
('THREAD_HANDLING', 'one-thread-per-connection'),
('INNODB_STATS_METHOD', 'nulls_equal'),
('LOG_BIN', 'OFF'),
('INNODB_FAST_SHUTDOWN', '1'),
('SQL_BIG_SELECTS', 'ON'),
('SSL_CA', ''),
('MAX_USER_CONNECTIONS', '0'),
('INNODB_THREAD_CONCURRENCY', '0'),
('SQL_MAX_JOIN_SIZE', '18446744073709551615'),
('SLAVE_NET_TIMEOUT', '3600'),
('TABLE_OPEN_CACHE', '400'),
('INNODB_STATS_SAMPLE_PAGES', '8'),
('SQL_BIG_TABLES', 'OFF'),
('LOCAL_INFILE', 'ON'),
('SQL_BUFFER_RESULT', 'OFF'),
('HAVE_RTREE_KEYS', 'YES'),
('ENGINE_CONDITION_PUSHDOWN', 'ON'),
('HAVE_PROFILING', 'YES'),
('LC_MESSAGES_DIR', '/usr/share/mysql/'),
('OLD_ALTER_TABLE', 'OFF'),
('HAVE_INNODB', 'YES'),
('MYISAM_MMAP_SIZE', '18446744073709551615'),
('SQL_MODE', ''),
('PERFORMANCE_SCHEMA_MAX_FILE_HANDLES', '32768'),
('RELAY_LOG_RECOVERY', 'OFF'),
('REPORT_USER', ''),
('MAX_DELAYED_THREADS', '20'),
('HAVE_GEOMETRY', 'YES'),
('DATETIME_FORMAT', '%Y-%m-%d %H:%i:%s'),
('SLOW_QUERY_LOG', 'OFF'),
('INNODB_FLUSH_LOG_AT_TRX_COMMIT', '1'),
('MAX_TMP_TABLES', '32'),
('MAX_RELAY_LOG_SIZE', '0'),
('LOG', 'OFF'),
('INNODB_RANDOM_READ_AHEAD', 'OFF'),
('OPEN_FILES_LIMIT', '1024'),
('HAVE_CSV', 'YES'),
('DATADIR', '/var/lib/mysql/'),
('PORT', '3306'),
('SLAVE_LOAD_TMPDIR', '/tmp'),
('VERSION_COMPILE_OS', 'debian-linux-gnu'),
('FT_MIN_WORD_LEN', '4'),
('LOG_BIN_TRUST_FUNCTION_CREATORS', 'OFF'),
('HAVE_QUERY_CACHE', 'YES'),
('INNODB_FORCE_LOAD_CORRUPTED', 'OFF'),
('SYNC_RELAY_LOG', '0'),
('HAVE_OPENSSL', 'DISABLED'),
('LC_TIME_NAMES', 'en_US'),
('MAX_BINLOG_STMT_CACHE_SIZE', '18446744073709547520'),
('TIME_FORMAT', '%H:%i:%s'),
('PERFORMANCE_SCHEMA_MAX_FILE_INSTANCES', '10000'),
('LC_MESSAGES', 'en_US'),
('INNODB_SPIN_WAIT_DELAY', '6'),
('NET_READ_TIMEOUT', '30'),
('INNODB_FILE_FORMAT_MAX', 'Antelope'),
('SYNC_FRM', 'ON'),
('DEFAULT_STORAGE_ENGINE', 'InnoDB'),
('INNODB_LOCK_WAIT_TIMEOUT', '50'),
('MULTI_RANGE_COUNT', '256'),
('INNODB_OLD_BLOCKS_TIME', '0'),
('OLD', 'OFF'),
('RPL_RECOVERY_RANK', '0'),
('MYISAM_STATS_METHOD', 'nulls_unequal'),
('MAX_ALLOWED_PACKET', '16777216'),
('OPTIMIZER_SWITCH', 'index_merge=on,index_merge_union=on,index_merge_sort_union=on,index_merge_intersection=on,engine_condition_pushdown=on'),
('SQL_WARNINGS', 'OFF'),
('LOCKED_IN_MEMORY', 'OFF'),
('SQL_SLAVE_SKIP_COUNTER', '0'),
('SOCKET', '/var/run/mysqld/mysqld.sock'),
('INNODB_CHECKSUMS', 'ON'),
('STORAGE_ENGINE', 'InnoDB'),
('INNODB_LOCKS_UNSAFE_FOR_BINLOG', 'OFF'),
('SSL_KEY', ''),
('MYISAM_USE_MMAP', 'OFF'),
('SKIP_EXTERNAL_LOCKING', 'ON'),
('INNODB_CONCURRENCY_TICKETS', '500'),
('SLAVE_SKIP_ERRORS', 'OFF'),
('SQL_SAFE_UPDATES', 'OFF'),
('MAX_JOIN_SIZE', '18446744073709551615'),
('RELAY_LOG_PURGE', 'ON'),
('INNODB_BUFFER_POOL_SIZE', '134217728'),
('COLLATION_DATABASE', 'latin1_swedish_ci'),
('INNODB_LOG_GROUP_HOME_DIR', './'),
('SSL_CERT', ''),
('INNODB_LARGE_PREFIX', 'OFF'),
('INNODB_LOG_BUFFER_SIZE', '8388608'),
('CHARACTER_SET_CLIENT', 'latin1'),
('INNODB_MAX_PURGE_LAG', '0'),
('MIN_EXAMINED_ROW_LIMIT', '0'),
('MYISAM_MAX_SORT_FILE_SIZE', '9223372036853727232'),
('MYISAM_REPAIR_THREADS', '1'),
('SLAVE_TYPE_CONVERSIONS', ''),
('PROTOCOL_VERSION', '10'),
('SQL_NOTES', 'ON'),
('LICENSE', 'GPL'),
('INNODB_MAX_DIRTY_PAGES_PCT', '75'),
('PERFORMANCE_SCHEMA_MAX_TABLE_INSTANCES', '50000'),
('THREAD_CONCURRENCY', '10'),
('UNIQUE_CHECKS', 'ON'),
('INNODB_OLD_BLOCKS_PCT', '37');

-- --------------------------------------------------------

--
-- Table structure for table `KEY_COLUMN_USAGE`
--

CREATE TEMPORARY TABLE `KEY_COLUMN_USAGE` (
  `CONSTRAINT_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `CONSTRAINT_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `CONSTRAINT_NAME` varchar(64) NOT NULL DEFAULT '',
  `TABLE_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `TABLE_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `TABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `COLUMN_NAME` varchar(64) NOT NULL DEFAULT '',
  `ORDINAL_POSITION` bigint(10) NOT NULL DEFAULT '0',
  `POSITION_IN_UNIQUE_CONSTRAINT` bigint(10) DEFAULT NULL,
  `REFERENCED_TABLE_SCHEMA` varchar(64) DEFAULT NULL,
  `REFERENCED_TABLE_NAME` varchar(64) DEFAULT NULL,
  `REFERENCED_COLUMN_NAME` varchar(64) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `KEY_COLUMN_USAGE`
--

INSERT INTO `KEY_COLUMN_USAGE` (`CONSTRAINT_CATALOG`, `CONSTRAINT_SCHEMA`, `CONSTRAINT_NAME`, `TABLE_CATALOG`, `TABLE_SCHEMA`, `TABLE_NAME`, `COLUMN_NAME`, `ORDINAL_POSITION`, `POSITION_IN_UNIQUE_CONSTRAINT`, `REFERENCED_TABLE_SCHEMA`, `REFERENCED_TABLE_NAME`, `REFERENCED_COLUMN_NAME`) VALUES
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'answers', 'a_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'answers_ibfk_1', 'def', 'c9mosh', 'answers', 'q_id', 1, 1, 'c9mosh', 'questions', 'q_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'campus', 'c_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'clue', 'clue_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'clue_ibfk_1', 'def', 'c9mosh', 'clue', 'clue_typ_id', 1, 1, 'c9mosh', 'clue_type', 'clue_typ_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'clue_question', 'clue_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'clue_question', 'q_id', 2, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'clue_question_ibfk_1', 'def', 'c9mosh', 'clue_question', 'clue_id', 1, 1, 'c9mosh', 'clue', 'clue_id'),
('def', 'c9mosh', 'clue_question_ibfk_2', 'def', 'c9mosh', 'clue_question', 'q_id', 1, 1, 'c9mosh', 'questions', 'q_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'clue_type', 'clue_typ_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'dic', 'td_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'dic_question', 'td_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'dic_question', 'q_id', 2, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'dic_question_ibfk_1', 'def', 'c9mosh', 'dic_question', 'td_id', 1, 1, 'c9mosh', 'dic', 'td_id'),
('def', 'c9mosh', 'dic_question_ibfk_2', 'def', 'c9mosh', 'dic_question', 'q_id', 1, 1, 'c9mosh', 'questions', 'q_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'game', 'g_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'game_task', 'tsk_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'game_task', 'g_id', 2, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'game_task_ibfk_1', 'def', 'c9mosh', 'game_task', 'tsk_id', 1, 1, 'c9mosh', 'tasks', 'tsk_id'),
('def', 'c9mosh', 'game_task_ibfk_2', 'def', 'c9mosh', 'game_task', 'prv_tsk_id', 1, 1, 'c9mosh', 'tasks', 'tsk_id'),
('def', 'c9mosh', 'game_task_ibfk_3', 'def', 'c9mosh', 'game_task', 'g_id', 1, 1, 'c9mosh', 'game', 'g_id'),
('def', 'c9mosh', 'login_name', 'def', 'c9mosh', 'login', 'login_name', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'u_id', 'def', 'c9mosh', 'login', 'u_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'login_ibfk_1', 'def', 'c9mosh', 'login', 'u_id', 1, 1, 'c9mosh', 'users', 'u_id'),
('def', 'c9mosh', 'login_ibfk_2', 'def', 'c9mosh', 'login', 'p_id', 1, 1, 'c9mosh', 'permissions', 'p_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'permissions', 'p_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'pk_progress_rule', 'def', 'c9mosh', 'progress', 't_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'pk_progress_rule', 'def', 'c9mosh', 'progress', 'u_id', 2, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'pk_progress_rule', 'def', 'c9mosh', 'progress', 'tsk_id', 3, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'pk_progress_rule', 'def', 'c9mosh', 'progress', 'status', 4, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'progress_ibfk_1', 'def', 'c9mosh', 'progress', 't_id', 1, 1, 'c9mosh', 'teams', 't_id'),
('def', 'c9mosh', 'progress_ibfk_2', 'def', 'c9mosh', 'progress', 'tsk_id', 1, 1, 'c9mosh', 'tasks', 'tsk_id'),
('def', 'c9mosh', 'progress_ibfk_3', 'def', 'c9mosh', 'progress', 'u_id', 1, 1, 'c9mosh', 'users', 'u_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'question_type', 'q_typ_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'questions', 'q_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'questions_ibfk_1', 'def', 'c9mosh', 'questions', 'q_typ_id', 1, 1, 'c9mosh', 'question_type', 'q_typ_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'responses', 'r_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'pk_response_rule', 'def', 'c9mosh', 'responses', 'u_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'pk_response_rule', 'def', 'c9mosh', 'responses', 'tsk_id', 2, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'pk_response_rule', 'def', 'c9mosh', 'responses', 'q_id', 3, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'pk_response_rule', 'def', 'c9mosh', 'responses', 'response', 4, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'responses_ibfk_1', 'def', 'c9mosh', 'responses', 't_id', 1, 1, 'c9mosh', 'teams', 't_id'),
('def', 'c9mosh', 'responses_ibfk_2', 'def', 'c9mosh', 'responses', 'tsk_id', 1, 1, 'c9mosh', 'tasks', 'tsk_id'),
('def', 'c9mosh', 'responses_ibfk_3', 'def', 'c9mosh', 'responses', 'u_id', 1, 1, 'c9mosh', 'users', 'u_id'),
('def', 'c9mosh', 'responses_ibfk_4', 'def', 'c9mosh', 'responses', 'q_id', 1, 1, 'c9mosh', 'questions', 'q_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'task_dic', 'tsk_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'task_dic', 'td_id', 2, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'task_dic_ibfk_1', 'def', 'c9mosh', 'task_dic', 'tsk_id', 1, 1, 'c9mosh', 'tasks', 'tsk_id'),
('def', 'c9mosh', 'task_dic_ibfk_2', 'def', 'c9mosh', 'task_dic', 'td_id', 1, 1, 'c9mosh', 'dic', 'td_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'tasks', 'tsk_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'secret_id', 'def', 'c9mosh', 'tasks', 'secret_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'tasks_ibfk_1', 'def', 'c9mosh', 'tasks', 'c_id', 1, 1, 'c9mosh', 'campus', 'c_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'team_game', 't_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'team_game', 'g_id', 2, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'team_game_ibfk_1', 'def', 'c9mosh', 'team_game', 't_id', 1, 1, 'c9mosh', 'teams', 't_id'),
('def', 'c9mosh', 'team_game_ibfk_2', 'def', 'c9mosh', 'team_game', 'g_id', 1, 1, 'c9mosh', 'game', 'g_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'team_user', 't_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'team_user', 'u_id', 2, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'team_user_ibfk_1', 'def', 'c9mosh', 'team_user', 't_id', 1, 1, 'c9mosh', 'teams', 't_id'),
('def', 'c9mosh', 'team_user_ibfk_2', 'def', 'c9mosh', 'team_user', 'u_id', 1, 1, 'c9mosh', 'users', 'u_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'teams', 't_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 't_name', 'def', 'c9mosh', 'teams', 't_name', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 't_chat_id', 'def', 'c9mosh', 'teams', 't_chat_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'user_options', 'u_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'u_id', 'def', 'c9mosh', 'user_options', 'u_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'user_options_ibfk_1', 'def', 'c9mosh', 'user_options', 'u_id', 1, 1, 'c9mosh', 'users', 'u_id'),
('def', 'c9mosh', 'PRIMARY', 'def', 'c9mosh', 'users', 'u_id', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 's_num', 'def', 'c9mosh', 'users', 's_num', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'u_nickname', 'def', 'c9mosh', 'users', 'u_nickname', 1, NULL, NULL, NULL, NULL),
('def', 'c9mosh', 'u_email', 'def', 'c9mosh', 'users', 'u_email', 1, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `PARAMETERS`
--

CREATE TEMPORARY TABLE `PARAMETERS` (
  `SPECIFIC_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `SPECIFIC_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `SPECIFIC_NAME` varchar(64) NOT NULL DEFAULT '',
  `ORDINAL_POSITION` int(21) NOT NULL DEFAULT '0',
  `PARAMETER_MODE` varchar(5) DEFAULT NULL,
  `PARAMETER_NAME` varchar(64) DEFAULT NULL,
  `DATA_TYPE` varchar(64) NOT NULL DEFAULT '',
  `CHARACTER_MAXIMUM_LENGTH` int(21) DEFAULT NULL,
  `CHARACTER_OCTET_LENGTH` int(21) DEFAULT NULL,
  `NUMERIC_PRECISION` int(21) DEFAULT NULL,
  `NUMERIC_SCALE` int(21) DEFAULT NULL,
  `CHARACTER_SET_NAME` varchar(64) DEFAULT NULL,
  `COLLATION_NAME` varchar(64) DEFAULT NULL,
  `DTD_IDENTIFIER` longtext NOT NULL,
  `ROUTINE_TYPE` varchar(9) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `PARAMETERS`
--

INSERT INTO `PARAMETERS` (`SPECIFIC_CATALOG`, `SPECIFIC_SCHEMA`, `SPECIFIC_NAME`, `ORDINAL_POSITION`, `PARAMETER_MODE`, `PARAMETER_NAME`, `DATA_TYPE`, `CHARACTER_MAXIMUM_LENGTH`, `CHARACTER_OCTET_LENGTH`, `NUMERIC_PRECISION`, `NUMERIC_SCALE`, `CHARACTER_SET_NAME`, `COLLATION_NAME`, `DTD_IDENTIFIER`, `ROUTINE_TYPE`) VALUES
('def', 'c9mosh', 'GetLoginUser', 1, 'IN', 'LoginName', 'varchar', 30, 90, NULL, NULL, 'utf8', 'utf8_general_ci', 'varchar(30)', 'PROCEDURE'),
('def', 'c9mosh', 'GetTeam', 1, 'IN', 'TeamId', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PROCEDURE'),
('def', 'c9mosh', 'GetTeamWithUser', 1, 'IN', 'UserId', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PROCEDURE'),
('def', 'c9mosh', 'GetUser', 1, 'IN', 'UserId', 'int', NULL, NULL, 10, 0, NULL, NULL, 'int(11)', 'PROCEDURE');

-- --------------------------------------------------------

--
-- Table structure for table `PARTITIONS`
--

CREATE TEMPORARY TABLE `PARTITIONS` (
  `TABLE_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `TABLE_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `TABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `PARTITION_NAME` varchar(64) DEFAULT NULL,
  `SUBPARTITION_NAME` varchar(64) DEFAULT NULL,
  `PARTITION_ORDINAL_POSITION` bigint(21) unsigned DEFAULT NULL,
  `SUBPARTITION_ORDINAL_POSITION` bigint(21) unsigned DEFAULT NULL,
  `PARTITION_METHOD` varchar(18) DEFAULT NULL,
  `SUBPARTITION_METHOD` varchar(12) DEFAULT NULL,
  `PARTITION_EXPRESSION` longtext,
  `SUBPARTITION_EXPRESSION` longtext,
  `PARTITION_DESCRIPTION` longtext,
  `TABLE_ROWS` bigint(21) unsigned NOT NULL DEFAULT '0',
  `AVG_ROW_LENGTH` bigint(21) unsigned NOT NULL DEFAULT '0',
  `DATA_LENGTH` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MAX_DATA_LENGTH` bigint(21) unsigned DEFAULT NULL,
  `INDEX_LENGTH` bigint(21) unsigned NOT NULL DEFAULT '0',
  `DATA_FREE` bigint(21) unsigned NOT NULL DEFAULT '0',
  `CREATE_TIME` datetime DEFAULT NULL,
  `UPDATE_TIME` datetime DEFAULT NULL,
  `CHECK_TIME` datetime DEFAULT NULL,
  `CHECKSUM` bigint(21) unsigned DEFAULT NULL,
  `PARTITION_COMMENT` varchar(80) NOT NULL DEFAULT '',
  `NODEGROUP` varchar(12) NOT NULL DEFAULT '',
  `TABLESPACE_NAME` varchar(64) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `PARTITIONS`
--

INSERT INTO `PARTITIONS` (`TABLE_CATALOG`, `TABLE_SCHEMA`, `TABLE_NAME`, `PARTITION_NAME`, `SUBPARTITION_NAME`, `PARTITION_ORDINAL_POSITION`, `SUBPARTITION_ORDINAL_POSITION`, `PARTITION_METHOD`, `SUBPARTITION_METHOD`, `PARTITION_EXPRESSION`, `SUBPARTITION_EXPRESSION`, `PARTITION_DESCRIPTION`, `TABLE_ROWS`, `AVG_ROW_LENGTH`, `DATA_LENGTH`, `MAX_DATA_LENGTH`, `INDEX_LENGTH`, `DATA_FREE`, `CREATE_TIME`, `UPDATE_TIME`, `CHECK_TIME`, `CHECKSUM`, `PARTITION_COMMENT`, `NODEGROUP`, `TABLESPACE_NAME`) VALUES
('def', 'information_schema', 'CHARACTER_SETS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 384, 0, 16434816, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'COLLATIONS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 231, 0, 16704765, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'COLLATION_CHARACTER_SET_APPLICABILITY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 195, 0, 16357770, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'COLUMNS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 281474976710655, 1024, 0, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, NULL, '', '', NULL),
('def', 'information_schema', 'COLUMN_PRIVILEGES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2565, 0, 16757145, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'ENGINES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 490, 0, 16574250, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'EVENTS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 281474976710655, 1024, 0, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, NULL, '', '', NULL),
('def', 'information_schema', 'FILES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2677, 0, 16758020, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'GLOBAL_STATUS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3268, 0, 16755036, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'GLOBAL_VARIABLES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3268, 0, 16755036, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'KEY_COLUMN_USAGE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4637, 0, 16762755, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'PARAMETERS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 281474976710655, 1024, 0, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, NULL, '', '', NULL),
('def', 'information_schema', 'PARTITIONS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 281474976710655, 1024, 0, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, NULL, '', '', NULL),
('def', 'information_schema', 'PLUGINS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 281474976710655, 1024, 0, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, NULL, '', '', NULL),
('def', 'information_schema', 'PROCESSLIST', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 281474976710655, 1024, 0, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, NULL, '', '', NULL),
('def', 'information_schema', 'PROFILING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 308, 0, 16562084, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4814, 0, 16767162, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'ROUTINES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 281474976710655, 1024, 0, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, NULL, '', '', NULL),
('def', 'information_schema', 'SCHEMATA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3464, 0, 16738048, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'SCHEMA_PRIVILEGES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2179, 0, 16736899, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'SESSION_STATUS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3268, 0, 16755036, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'SESSION_VARIABLES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3268, 0, 16755036, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'STATISTICS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 5753, 0, 16752736, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'TABLES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 9450, 0, 16764300, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'TABLESPACES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 6951, 0, 16772763, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'TABLE_CONSTRAINTS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2504, 0, 16721712, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'TABLE_PRIVILEGES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2372, 0, 16748692, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'TRIGGERS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 281474976710655, 1024, 0, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, NULL, '', '', NULL),
('def', 'information_schema', 'USER_PRIVILEGES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1986, 0, 16726092, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'VIEWS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 281474976710655, 1024, 0, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, NULL, '', '', NULL),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 6852, 0, 16766844, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'INNODB_TRX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4534, 0, 16766732, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 257, 0, 16332350, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'INNODB_LOCK_WAITS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 599, 0, 16749238, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'INNODB_CMPMEM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 29, 0, 15204352, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'INNODB_CMP', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 25, 0, 13107200, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'INNODB_LOCKS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 31244, 0, 16746784, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'INNODB_CMPMEM_RESET', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 29, 0, 15204352, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'INNODB_CMP_RESET', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 25, 0, 13107200, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 6669, 0, 16765866, 0, 0, '2013-02-25 04:09:07', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'answers', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13, 1260, 16384, NULL, 16384, 4194304, '2013-02-17 16:31:48', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'campus', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 5461, 16384, NULL, 0, 4194304, '2013-02-17 16:31:47', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'clue', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 16384, NULL, 16384, 4194304, '2013-02-17 16:31:49', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'clue_question', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 16384, NULL, 16384, 4194304, '2013-02-17 16:31:49', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'clue_type', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 16384, NULL, 0, 4194304, '2013-02-17 16:31:49', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'dic', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14, 1170, 16384, NULL, 0, 4194304, '2013-02-17 16:31:47', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'dic_question', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20, 819, 16384, NULL, 16384, 4194304, '2013-02-17 16:31:49', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'game', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 16384, 16384, NULL, 0, 4194304, '2013-02-17 16:31:49', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'game_task', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 5461, 16384, NULL, 32768, 4194304, '2013-02-17 16:31:50', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'login', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18, 910, 16384, NULL, 32768, 4194304, '2013-02-17 16:31:47', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'permissions', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5, 3276, 16384, NULL, 0, 4194304, '2013-02-17 16:31:47', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'progress', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27, 606, 16384, NULL, 49152, 4194304, '2013-02-17 16:31:51', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'question_type', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 8192, 16384, NULL, 0, 4194304, '2013-02-17 16:31:48', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'questions', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20, 819, 16384, NULL, 16384, 4194304, '2013-02-17 16:31:48', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'responses', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32, 512, 16384, NULL, 65536, 4194304, '2013-02-17 16:31:51', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'task_dic', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14, 1170, 16384, NULL, 16384, 4194304, '2013-02-17 16:31:48', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'tasks', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, 1638, 16384, NULL, 32768, 4194304, '2013-02-17 16:31:48', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'team_game', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5, 3276, 16384, NULL, 16384, 4194304, '2013-02-17 16:31:50', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'team_user', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18, 910, 16384, NULL, 16384, 4194304, '2013-02-17 16:31:47', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'teams', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6, 2730, 16384, NULL, 32768, 4194304, '2013-02-17 16:31:47', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'user_options', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18, 910, 16384, NULL, 16384, 4194304, '2013-02-23 18:47:08', NULL, NULL, NULL, '', '', NULL),
('def', 'c9mosh', 'users', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18, 910, 16384, NULL, 49152, 4194304, '2013-02-17 16:31:46', NULL, NULL, NULL, '', '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `PLUGINS`
--

CREATE TEMPORARY TABLE `PLUGINS` (
  `PLUGIN_NAME` varchar(64) NOT NULL DEFAULT '',
  `PLUGIN_VERSION` varchar(20) NOT NULL DEFAULT '',
  `PLUGIN_STATUS` varchar(10) NOT NULL DEFAULT '',
  `PLUGIN_TYPE` varchar(80) NOT NULL DEFAULT '',
  `PLUGIN_TYPE_VERSION` varchar(20) NOT NULL DEFAULT '',
  `PLUGIN_LIBRARY` varchar(64) DEFAULT NULL,
  `PLUGIN_LIBRARY_VERSION` varchar(20) DEFAULT NULL,
  `PLUGIN_AUTHOR` varchar(64) DEFAULT NULL,
  `PLUGIN_DESCRIPTION` longtext,
  `PLUGIN_LICENSE` varchar(80) DEFAULT NULL,
  `LOAD_OPTION` varchar(64) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `PLUGINS`
--

INSERT INTO `PLUGINS` (`PLUGIN_NAME`, `PLUGIN_VERSION`, `PLUGIN_STATUS`, `PLUGIN_TYPE`, `PLUGIN_TYPE_VERSION`, `PLUGIN_LIBRARY`, `PLUGIN_LIBRARY_VERSION`, `PLUGIN_AUTHOR`, `PLUGIN_DESCRIPTION`, `PLUGIN_LICENSE`, `LOAD_OPTION`) VALUES
('binlog', '1.0', 'ACTIVE', 'STORAGE ENGINE', '50529.0', NULL, NULL, 'MySQL AB', 'This is a pseudo storage engine to represent the binlog in a transaction', 'GPL', 'FORCE'),
('mysql_native_password', '1.0', 'ACTIVE', 'AUTHENTICATION', '1.0', NULL, NULL, 'R.J.Silk, Sergei Golubchik', 'Native MySQL authentication', 'GPL', 'FORCE'),
('mysql_old_password', '1.0', 'ACTIVE', 'AUTHENTICATION', '1.0', NULL, NULL, 'R.J.Silk, Sergei Golubchik', 'Old MySQL-4.0 authentication', 'GPL', 'FORCE'),
('MyISAM', '1.0', 'ACTIVE', 'STORAGE ENGINE', '50529.0', NULL, NULL, 'MySQL AB', 'MyISAM storage engine', 'GPL', 'FORCE'),
('MEMORY', '1.0', 'ACTIVE', 'STORAGE ENGINE', '50529.0', NULL, NULL, 'MySQL AB', 'Hash based, stored in memory, useful for temporary tables', 'GPL', 'FORCE'),
('CSV', '1.0', 'ACTIVE', 'STORAGE ENGINE', '50529.0', NULL, NULL, 'Brian Aker, MySQL AB', 'CSV storage engine', 'GPL', 'FORCE'),
('MRG_MYISAM', '1.0', 'ACTIVE', 'STORAGE ENGINE', '50529.0', NULL, NULL, 'MySQL AB', 'Collection of identical MyISAM tables', 'GPL', 'FORCE'),
('BLACKHOLE', '1.0', 'ACTIVE', 'STORAGE ENGINE', '50529.0', NULL, NULL, 'MySQL AB', '/dev/null storage engine (anything you write to it disappears)', 'GPL', 'ON'),
('FEDERATED', '1.0', 'DISABLED', 'STORAGE ENGINE', '50529.0', NULL, NULL, 'Patrick Galbraith and Brian Aker, MySQL AB', 'Federated MySQL storage engine', 'GPL', 'OFF'),
('InnoDB', '1.1', 'ACTIVE', 'STORAGE ENGINE', '50529.0', NULL, NULL, 'Oracle Corporation', 'Supports transactions, row-level locking, and foreign keys', 'GPL', 'ON'),
('INNODB_TRX', '1.1', 'ACTIVE', 'INFORMATION SCHEMA', '50529.0', NULL, NULL, 'Oracle Corporation', 'InnoDB transactions', 'GPL', 'ON'),
('INNODB_LOCKS', '1.1', 'ACTIVE', 'INFORMATION SCHEMA', '50529.0', NULL, NULL, 'Oracle Corporation', 'InnoDB conflicting locks', 'GPL', 'ON'),
('INNODB_LOCK_WAITS', '1.1', 'ACTIVE', 'INFORMATION SCHEMA', '50529.0', NULL, NULL, 'Oracle Corporation', 'InnoDB which lock is blocking which', 'GPL', 'ON'),
('INNODB_CMP', '1.1', 'ACTIVE', 'INFORMATION SCHEMA', '50529.0', NULL, NULL, 'Oracle Corporation', 'Statistics for the InnoDB compression', 'GPL', 'ON'),
('INNODB_CMP_RESET', '1.1', 'ACTIVE', 'INFORMATION SCHEMA', '50529.0', NULL, NULL, 'Oracle Corporation', 'Statistics for the InnoDB compression; reset cumulated counts', 'GPL', 'ON'),
('INNODB_CMPMEM', '1.1', 'ACTIVE', 'INFORMATION SCHEMA', '50529.0', NULL, NULL, 'Oracle Corporation', 'Statistics for the InnoDB compressed buffer pool', 'GPL', 'ON'),
('INNODB_CMPMEM_RESET', '1.1', 'ACTIVE', 'INFORMATION SCHEMA', '50529.0', NULL, NULL, 'Oracle Corporation', 'Statistics for the InnoDB compressed buffer pool; reset cumulated counts', 'GPL', 'ON'),
('INNODB_BUFFER_PAGE', '1.1', 'ACTIVE', 'INFORMATION SCHEMA', '50529.0', NULL, NULL, 'Oracle Corporation', 'InnoDB Buffer Page Information', 'GPL', 'ON'),
('INNODB_BUFFER_PAGE_LRU', '1.1', 'ACTIVE', 'INFORMATION SCHEMA', '50529.0', NULL, NULL, 'Oracle Corporation', 'InnoDB Buffer Page in LRU', 'GPL', 'ON'),
('INNODB_BUFFER_POOL_STATS', '1.1', 'ACTIVE', 'INFORMATION SCHEMA', '50529.0', NULL, NULL, 'Oracle Corporation', 'InnoDB Buffer Pool Statistics Information ', 'GPL', 'ON'),
('PERFORMANCE_SCHEMA', '0.1', 'ACTIVE', 'STORAGE ENGINE', '50529.0', NULL, NULL, 'Marc Alff, Oracle', 'Performance Schema', 'GPL', 'FORCE'),
('ARCHIVE', '3.0', 'ACTIVE', 'STORAGE ENGINE', '50529.0', NULL, NULL, 'Brian Aker, MySQL AB', 'Archive storage engine', 'GPL', 'ON'),
('partition', '1.0', 'ACTIVE', 'STORAGE ENGINE', '50529.0', NULL, NULL, 'Mikael Ronstrom, MySQL AB', 'Partition Storage Engine Helper', 'GPL', 'ON');

-- --------------------------------------------------------

--
-- Table structure for table `PROCESSLIST`
--

CREATE TEMPORARY TABLE `PROCESSLIST` (
  `ID` bigint(4) NOT NULL DEFAULT '0',
  `USER` varchar(16) NOT NULL DEFAULT '',
  `HOST` varchar(64) NOT NULL DEFAULT '',
  `DB` varchar(64) DEFAULT NULL,
  `COMMAND` varchar(16) NOT NULL DEFAULT '',
  `TIME` int(7) NOT NULL DEFAULT '0',
  `STATE` varchar(64) DEFAULT NULL,
  `INFO` longtext
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `PROCESSLIST`
--

INSERT INTO `PROCESSLIST` (`ID`, `USER`, `HOST`, `DB`, `COMMAND`, `TIME`, `STATE`, `INFO`) VALUES
(278620, 'c9mosh', 'localhost', 'c9mosh', 'Query', 0, 'executing', 'SELECT * FROM `information_schema`.`PROCESSLIST`');

-- --------------------------------------------------------

--
-- Table structure for table `PROFILING`
--

CREATE TEMPORARY TABLE `PROFILING` (
  `QUERY_ID` int(20) NOT NULL DEFAULT '0',
  `SEQ` int(20) NOT NULL DEFAULT '0',
  `STATE` varchar(30) NOT NULL DEFAULT '',
  `DURATION` decimal(9,6) NOT NULL DEFAULT '0.000000',
  `CPU_USER` decimal(9,6) DEFAULT NULL,
  `CPU_SYSTEM` decimal(9,6) DEFAULT NULL,
  `CONTEXT_VOLUNTARY` int(20) DEFAULT NULL,
  `CONTEXT_INVOLUNTARY` int(20) DEFAULT NULL,
  `BLOCK_OPS_IN` int(20) DEFAULT NULL,
  `BLOCK_OPS_OUT` int(20) DEFAULT NULL,
  `MESSAGES_SENT` int(20) DEFAULT NULL,
  `MESSAGES_RECEIVED` int(20) DEFAULT NULL,
  `PAGE_FAULTS_MAJOR` int(20) DEFAULT NULL,
  `PAGE_FAULTS_MINOR` int(20) DEFAULT NULL,
  `SWAPS` int(20) DEFAULT NULL,
  `SOURCE_FUNCTION` varchar(30) DEFAULT NULL,
  `SOURCE_FILE` varchar(20) DEFAULT NULL,
  `SOURCE_LINE` int(20) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `REFERENTIAL_CONSTRAINTS`
--

CREATE TEMPORARY TABLE `REFERENTIAL_CONSTRAINTS` (
  `CONSTRAINT_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `CONSTRAINT_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `CONSTRAINT_NAME` varchar(64) NOT NULL DEFAULT '',
  `UNIQUE_CONSTRAINT_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `UNIQUE_CONSTRAINT_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `UNIQUE_CONSTRAINT_NAME` varchar(64) DEFAULT NULL,
  `MATCH_OPTION` varchar(64) NOT NULL DEFAULT '',
  `UPDATE_RULE` varchar(64) NOT NULL DEFAULT '',
  `DELETE_RULE` varchar(64) NOT NULL DEFAULT '',
  `TABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `REFERENCED_TABLE_NAME` varchar(64) NOT NULL DEFAULT ''
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `REFERENTIAL_CONSTRAINTS`
--

INSERT INTO `REFERENTIAL_CONSTRAINTS` (`CONSTRAINT_CATALOG`, `CONSTRAINT_SCHEMA`, `CONSTRAINT_NAME`, `UNIQUE_CONSTRAINT_CATALOG`, `UNIQUE_CONSTRAINT_SCHEMA`, `UNIQUE_CONSTRAINT_NAME`, `MATCH_OPTION`, `UPDATE_RULE`, `DELETE_RULE`, `TABLE_NAME`, `REFERENCED_TABLE_NAME`) VALUES
('def', 'c9mosh', 'answers_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'answers', 'questions'),
('def', 'c9mosh', 'clue_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'clue', 'clue_type'),
('def', 'c9mosh', 'clue_question_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'clue_question', 'clue'),
('def', 'c9mosh', 'clue_question_ibfk_2', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'clue_question', 'questions'),
('def', 'c9mosh', 'dic_question_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'dic_question', 'dic'),
('def', 'c9mosh', 'dic_question_ibfk_2', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'dic_question', 'questions'),
('def', 'c9mosh', 'game_task_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'game_task', 'tasks'),
('def', 'c9mosh', 'game_task_ibfk_2', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'game_task', 'tasks'),
('def', 'c9mosh', 'game_task_ibfk_3', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'game_task', 'game'),
('def', 'c9mosh', 'login_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'login', 'users'),
('def', 'c9mosh', 'login_ibfk_2', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'login', 'permissions'),
('def', 'c9mosh', 'progress_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'progress', 'teams'),
('def', 'c9mosh', 'progress_ibfk_2', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'progress', 'tasks'),
('def', 'c9mosh', 'progress_ibfk_3', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'progress', 'users'),
('def', 'c9mosh', 'questions_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'questions', 'question_type'),
('def', 'c9mosh', 'responses_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'responses', 'teams'),
('def', 'c9mosh', 'responses_ibfk_2', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'responses', 'tasks'),
('def', 'c9mosh', 'responses_ibfk_3', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'responses', 'users'),
('def', 'c9mosh', 'responses_ibfk_4', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'responses', 'questions'),
('def', 'c9mosh', 'task_dic_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'task_dic', 'tasks'),
('def', 'c9mosh', 'task_dic_ibfk_2', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'task_dic', 'dic'),
('def', 'c9mosh', 'tasks_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'tasks', 'campus'),
('def', 'c9mosh', 'team_game_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'team_game', 'teams'),
('def', 'c9mosh', 'team_game_ibfk_2', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'team_game', 'game'),
('def', 'c9mosh', 'team_user_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'team_user', 'teams'),
('def', 'c9mosh', 'team_user_ibfk_2', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'team_user', 'users'),
('def', 'c9mosh', 'user_options_ibfk_1', 'def', 'c9mosh', 'PRIMARY', 'NONE', 'RESTRICT', 'RESTRICT', 'user_options', 'users');

-- --------------------------------------------------------

--
-- Table structure for table `ROUTINES`
--

CREATE TEMPORARY TABLE `ROUTINES` (
  `SPECIFIC_NAME` varchar(64) NOT NULL DEFAULT '',
  `ROUTINE_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `ROUTINE_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `ROUTINE_NAME` varchar(64) NOT NULL DEFAULT '',
  `ROUTINE_TYPE` varchar(9) NOT NULL DEFAULT '',
  `DATA_TYPE` varchar(64) NOT NULL DEFAULT '',
  `CHARACTER_MAXIMUM_LENGTH` int(21) DEFAULT NULL,
  `CHARACTER_OCTET_LENGTH` int(21) DEFAULT NULL,
  `NUMERIC_PRECISION` int(21) DEFAULT NULL,
  `NUMERIC_SCALE` int(21) DEFAULT NULL,
  `CHARACTER_SET_NAME` varchar(64) DEFAULT NULL,
  `COLLATION_NAME` varchar(64) DEFAULT NULL,
  `DTD_IDENTIFIER` longtext,
  `ROUTINE_BODY` varchar(8) NOT NULL DEFAULT '',
  `ROUTINE_DEFINITION` longtext,
  `EXTERNAL_NAME` varchar(64) DEFAULT NULL,
  `EXTERNAL_LANGUAGE` varchar(64) DEFAULT NULL,
  `PARAMETER_STYLE` varchar(8) NOT NULL DEFAULT '',
  `IS_DETERMINISTIC` varchar(3) NOT NULL DEFAULT '',
  `SQL_DATA_ACCESS` varchar(64) NOT NULL DEFAULT '',
  `SQL_PATH` varchar(64) DEFAULT NULL,
  `SECURITY_TYPE` varchar(7) NOT NULL DEFAULT '',
  `CREATED` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `LAST_ALTERED` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `SQL_MODE` varchar(8192) NOT NULL DEFAULT '',
  `ROUTINE_COMMENT` longtext NOT NULL,
  `DEFINER` varchar(77) NOT NULL DEFAULT '',
  `CHARACTER_SET_CLIENT` varchar(32) NOT NULL DEFAULT '',
  `COLLATION_CONNECTION` varchar(32) NOT NULL DEFAULT '',
  `DATABASE_COLLATION` varchar(32) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ROUTINES`
--

INSERT INTO `ROUTINES` (`SPECIFIC_NAME`, `ROUTINE_CATALOG`, `ROUTINE_SCHEMA`, `ROUTINE_NAME`, `ROUTINE_TYPE`, `DATA_TYPE`, `CHARACTER_MAXIMUM_LENGTH`, `CHARACTER_OCTET_LENGTH`, `NUMERIC_PRECISION`, `NUMERIC_SCALE`, `CHARACTER_SET_NAME`, `COLLATION_NAME`, `DTD_IDENTIFIER`, `ROUTINE_BODY`, `ROUTINE_DEFINITION`, `EXTERNAL_NAME`, `EXTERNAL_LANGUAGE`, `PARAMETER_STYLE`, `IS_DETERMINISTIC`, `SQL_DATA_ACCESS`, `SQL_PATH`, `SECURITY_TYPE`, `CREATED`, `LAST_ALTERED`, `SQL_MODE`, `ROUTINE_COMMENT`, `DEFINER`, `CHARACTER_SET_CLIENT`, `COLLATION_CONNECTION`, `DATABASE_COLLATION`) VALUES
('GetLoginUser', 'def', 'c9mosh', 'GetLoginUser', 'PROCEDURE', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SQL', 'BEGIN\n  SELECT\n    users.*,\n    user_options.p_vsbl_tm, user_options.e_vsbl_tm,\n    login.login_name, login.login_pass\n  FROM\n    login\n      INNER JOIN users ON login.u_id = users.u_id\n      INNER JOIN user_options ON users.u_id = user_options.u_id\n  WHERE\n    login.login_name = LoginName;\nEND', NULL, NULL, 'SQL', 'NO', 'CONTAINS SQL', NULL, 'DEFINER', '2013-02-13 05:56:10', '2013-02-13 05:56:10', '', '', 'c9mosh@localhost', 'utf8', 'utf8_general_ci', 'utf8_general_ci'),
('GetTeam', 'def', 'c9mosh', 'GetTeam', 'PROCEDURE', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SQL', 'BEGIN\n  SELECT\n    teams.*, users.*, user_options.*\n  FROM\n    users\n      INNER JOIN user_options ON users.u_id = user_options.u_id\n      INNER JOIN team_user ON team_user.u_id = users.u_id\n      INNER JOIN teams ON team_user.t_id = teams.t_id\n  WHERE\n    teams.t_id = TeamId;\nEND', NULL, NULL, 'SQL', 'NO', 'CONTAINS SQL', NULL, 'DEFINER', '2013-02-13 05:56:10', '2013-02-13 05:56:10', '', '', 'c9mosh@localhost', 'utf8', 'utf8_general_ci', 'utf8_general_ci'),
('GetTeamWithUser', 'def', 'c9mosh', 'GetTeamWithUser', 'PROCEDURE', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SQL', 'BEGIN\n  SELECT\n    users.*, teams.*, user_options.*\n  FROM\n    team_user\n      INNER JOIN teams ON team_user.t_id = teams.t_id\n      INNER JOIN users ON team_user.u_id = users.u_id\n      INNER JOIN user_options ON users.u_id = user_options.u_id,\n        (SELECT\n           team_user.t_id AS Team,\n           team_user.u_id AS User\n         FROM\n           team_user) TeamMember\n  WHERE\n    TeamMember.Team = team_user.t_id AND\n    TeamMember.User = UserId;\nEND', NULL, NULL, 'SQL', 'NO', 'CONTAINS SQL', NULL, 'DEFINER', '2013-02-13 05:56:10', '2013-02-13 05:56:10', '', '', 'c9mosh@localhost', 'utf8', 'utf8_general_ci', 'utf8_general_ci'),
('GetUser', 'def', 'c9mosh', 'GetUser', 'PROCEDURE', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SQL', 'BEGIN\n  SELECT\n    users.*,\n    user_options.p_vsbl_tm, user_options.e_vsbl_tm\n  FROM\n    users\n      INNER JOIN user_options ON users.u_id = user_options.u_id\n  WHERE users.u_id = UserId;\nEND', NULL, NULL, 'SQL', 'NO', 'CONTAINS SQL', NULL, 'DEFINER', '2013-02-13 05:56:10', '2013-02-13 05:56:10', '', '', 'c9mosh@localhost', 'utf8', 'utf8_general_ci', 'utf8_general_ci');

-- --------------------------------------------------------

--
-- Table structure for table `SCHEMATA`
--

CREATE TEMPORARY TABLE `SCHEMATA` (
  `CATALOG_NAME` varchar(512) NOT NULL DEFAULT '',
  `SCHEMA_NAME` varchar(64) NOT NULL DEFAULT '',
  `DEFAULT_CHARACTER_SET_NAME` varchar(32) NOT NULL DEFAULT '',
  `DEFAULT_COLLATION_NAME` varchar(32) NOT NULL DEFAULT '',
  `SQL_PATH` varchar(512) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `SCHEMATA`
--

INSERT INTO `SCHEMATA` (`CATALOG_NAME`, `SCHEMA_NAME`, `DEFAULT_CHARACTER_SET_NAME`, `DEFAULT_COLLATION_NAME`, `SQL_PATH`) VALUES
('def', 'information_schema', 'utf8', 'utf8_general_ci', NULL),
('def', 'c9mosh', 'utf8', 'utf8_general_ci', NULL),
('def', 'test', 'latin1', 'latin1_swedish_ci', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `SCHEMA_PRIVILEGES`
--

CREATE TEMPORARY TABLE `SCHEMA_PRIVILEGES` (
  `GRANTEE` varchar(81) NOT NULL DEFAULT '',
  `TABLE_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `TABLE_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `PRIVILEGE_TYPE` varchar(64) NOT NULL DEFAULT '',
  `IS_GRANTABLE` varchar(3) NOT NULL DEFAULT ''
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `SCHEMA_PRIVILEGES`
--

INSERT INTO `SCHEMA_PRIVILEGES` (`GRANTEE`, `TABLE_CATALOG`, `TABLE_SCHEMA`, `PRIVILEGE_TYPE`, `IS_GRANTABLE`) VALUES
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'SELECT', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'INSERT', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'UPDATE', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'DELETE', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'CREATE', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'DROP', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'REFERENCES', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'INDEX', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'ALTER', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'CREATE TEMPORARY TABLES', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'LOCK TABLES', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'EXECUTE', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'CREATE VIEW', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'SHOW VIEW', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'CREATE ROUTINE', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'ALTER ROUTINE', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'EVENT', 'NO'),
('''c9mosh''@''localhost''', 'def', 'c9mosh', 'TRIGGER', 'NO');

-- --------------------------------------------------------

--
-- Table structure for table `SESSION_STATUS`
--

CREATE TEMPORARY TABLE `SESSION_STATUS` (
  `VARIABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `SESSION_STATUS`
--

INSERT INTO `SESSION_STATUS` (`VARIABLE_NAME`, `VARIABLE_VALUE`) VALUES
('ABORTED_CLIENTS', '18'),
('ABORTED_CONNECTS', '11024'),
('BINLOG_CACHE_DISK_USE', '0'),
('BINLOG_CACHE_USE', '0'),
('BINLOG_STMT_CACHE_DISK_USE', '0'),
('BINLOG_STMT_CACHE_USE', '0'),
('BYTES_RECEIVED', '13790'),
('BYTES_SENT', '362320'),
('COM_ADMIN_COMMANDS', '0'),
('COM_ASSIGN_TO_KEYCACHE', '0'),
('COM_ALTER_DB', '0'),
('COM_ALTER_DB_UPGRADE', '0'),
('COM_ALTER_EVENT', '0'),
('COM_ALTER_FUNCTION', '0'),
('COM_ALTER_PROCEDURE', '0'),
('COM_ALTER_SERVER', '0'),
('COM_ALTER_TABLE', '0'),
('COM_ALTER_TABLESPACE', '0'),
('COM_ANALYZE', '0'),
('COM_BEGIN', '0'),
('COM_BINLOG', '0'),
('COM_CALL_PROCEDURE', '0'),
('COM_CHANGE_DB', '2'),
('COM_CHANGE_MASTER', '0'),
('COM_CHECK', '0'),
('COM_CHECKSUM', '0'),
('COM_COMMIT', '0'),
('COM_CREATE_DB', '0'),
('COM_CREATE_EVENT', '0'),
('COM_CREATE_FUNCTION', '0'),
('COM_CREATE_INDEX', '0'),
('COM_CREATE_PROCEDURE', '0'),
('COM_CREATE_SERVER', '0'),
('COM_CREATE_TABLE', '0'),
('COM_CREATE_TRIGGER', '0'),
('COM_CREATE_UDF', '0'),
('COM_CREATE_USER', '0'),
('COM_CREATE_VIEW', '0'),
('COM_DEALLOC_SQL', '0'),
('COM_DELETE', '0'),
('COM_DELETE_MULTI', '0'),
('COM_DO', '0'),
('COM_DROP_DB', '0'),
('COM_DROP_EVENT', '0'),
('COM_DROP_FUNCTION', '0'),
('COM_DROP_INDEX', '0'),
('COM_DROP_PROCEDURE', '0'),
('COM_DROP_SERVER', '0'),
('COM_DROP_TABLE', '0'),
('COM_DROP_TRIGGER', '0'),
('COM_DROP_USER', '0'),
('COM_DROP_VIEW', '0'),
('COM_EMPTY_QUERY', '0'),
('COM_EXECUTE_SQL', '0'),
('COM_FLUSH', '0'),
('COM_GRANT', '0'),
('COM_HA_CLOSE', '0'),
('COM_HA_OPEN', '0'),
('COM_HA_READ', '0'),
('COM_HELP', '0'),
('COM_INSERT', '0'),
('COM_INSERT_SELECT', '0'),
('COM_INSTALL_PLUGIN', '0'),
('COM_KILL', '0'),
('COM_LOAD', '0'),
('COM_LOCK_TABLES', '0'),
('COM_OPTIMIZE', '0'),
('COM_PRELOAD_KEYS', '0'),
('COM_PREPARE_SQL', '0'),
('COM_PURGE', '0'),
('COM_PURGE_BEFORE_DATE', '0'),
('COM_RELEASE_SAVEPOINT', '0'),
('COM_RENAME_TABLE', '0'),
('COM_RENAME_USER', '0'),
('COM_REPAIR', '0'),
('COM_REPLACE', '0'),
('COM_REPLACE_SELECT', '0'),
('COM_RESET', '0'),
('COM_RESIGNAL', '0'),
('COM_REVOKE', '0'),
('COM_REVOKE_ALL', '0'),
('COM_ROLLBACK', '0'),
('COM_ROLLBACK_TO_SAVEPOINT', '0'),
('COM_SAVEPOINT', '0'),
('COM_SELECT', '45'),
('COM_SET_OPTION', '47'),
('COM_SIGNAL', '0'),
('COM_SHOW_AUTHORS', '0'),
('COM_SHOW_BINLOG_EVENTS', '0'),
('COM_SHOW_BINLOGS', '0'),
('COM_SHOW_CHARSETS', '0'),
('COM_SHOW_COLLATIONS', '0'),
('COM_SHOW_CONTRIBUTORS', '0'),
('COM_SHOW_CREATE_DB', '0'),
('COM_SHOW_CREATE_EVENT', '0'),
('COM_SHOW_CREATE_FUNC', '0'),
('COM_SHOW_CREATE_PROC', '4'),
('COM_SHOW_CREATE_TABLE', '43'),
('COM_SHOW_CREATE_TRIGGER', '0'),
('COM_SHOW_DATABASES', '1'),
('COM_SHOW_ENGINE_LOGS', '0'),
('COM_SHOW_ENGINE_MUTEX', '0'),
('COM_SHOW_ENGINE_STATUS', '0'),
('COM_SHOW_EVENTS', '0'),
('COM_SHOW_ERRORS', '0'),
('COM_SHOW_FIELDS', '0'),
('COM_SHOW_FUNCTION_STATUS', '2'),
('COM_SHOW_GRANTS', '0'),
('COM_SHOW_KEYS', '0'),
('COM_SHOW_MASTER_STATUS', '0'),
('COM_SHOW_OPEN_TABLES', '0'),
('COM_SHOW_PLUGINS', '1'),
('COM_SHOW_PRIVILEGES', '0'),
('COM_SHOW_PROCEDURE_STATUS', '2'),
('COM_SHOW_PROCESSLIST', '0'),
('COM_SHOW_PROFILE', '0'),
('COM_SHOW_PROFILES', '0'),
('COM_SHOW_RELAYLOG_EVENTS', '0'),
('COM_SHOW_SLAVE_HOSTS', '0'),
('COM_SHOW_SLAVE_STATUS', '0'),
('COM_SHOW_STATUS', '0'),
('COM_SHOW_STORAGE_ENGINES', '0'),
('COM_SHOW_TABLE_STATUS', '82'),
('COM_SHOW_TABLES', '2'),
('COM_SHOW_TRIGGERS', '42'),
('COM_SHOW_VARIABLES', '1'),
('COM_SHOW_WARNINGS', '0'),
('COM_SLAVE_START', '0'),
('COM_SLAVE_STOP', '0'),
('COM_STMT_CLOSE', '0'),
('COM_STMT_EXECUTE', '0'),
('COM_STMT_FETCH', '0'),
('COM_STMT_PREPARE', '0'),
('COM_STMT_REPREPARE', '0'),
('COM_STMT_RESET', '0'),
('COM_STMT_SEND_LONG_DATA', '0'),
('COM_TRUNCATE', '0'),
('COM_UNINSTALL_PLUGIN', '0'),
('COM_UNLOCK_TABLES', '0'),
('COM_UPDATE', '0'),
('COM_UPDATE_MULTI', '0'),
('COM_XA_COMMIT', '0'),
('COM_XA_END', '0'),
('COM_XA_PREPARE', '0'),
('COM_XA_RECOVER', '0'),
('COM_XA_ROLLBACK', '0'),
('COM_XA_START', '0'),
('COMPRESSION', 'OFF'),
('CONNECTIONS', '278621'),
('CREATED_TMP_DISK_TABLES', '119'),
('CREATED_TMP_FILES', '461'),
('CREATED_TMP_TABLES', '398'),
('DELAYED_ERRORS', '0'),
('DELAYED_INSERT_THREADS', '0'),
('DELAYED_WRITES', '0'),
('FLUSH_COMMANDS', '1'),
('HANDLER_COMMIT', '22'),
('HANDLER_DELETE', '0'),
('HANDLER_DISCOVER', '0'),
('HANDLER_PREPARE', '0'),
('HANDLER_READ_FIRST', '28'),
('HANDLER_READ_KEY', '26'),
('HANDLER_READ_LAST', '0'),
('HANDLER_READ_NEXT', '84'),
('HANDLER_READ_PREV', '0'),
('HANDLER_READ_RND', '0'),
('HANDLER_READ_RND_NEXT', '2379'),
('HANDLER_ROLLBACK', '0'),
('HANDLER_SAVEPOINT', '0'),
('HANDLER_SAVEPOINT_ROLLBACK', '0'),
('HANDLER_UPDATE', '0'),
('HANDLER_WRITE', '2191'),
('INNODB_BUFFER_POOL_PAGES_DATA', '4394'),
('INNODB_BUFFER_POOL_PAGES_DIRTY', '1'),
('INNODB_BUFFER_POOL_PAGES_FLUSHED', '280215'),
('INNODB_BUFFER_POOL_PAGES_FREE', '3575'),
('INNODB_BUFFER_POOL_PAGES_MISC', '223'),
('INNODB_BUFFER_POOL_PAGES_TOTAL', '8192'),
('INNODB_BUFFER_POOL_READ_AHEAD_RND', '0'),
('INNODB_BUFFER_POOL_READ_AHEAD', '1251'),
('INNODB_BUFFER_POOL_READ_AHEAD_EVICTED', '0'),
('INNODB_BUFFER_POOL_READ_REQUESTS', '3304737160'),
('INNODB_BUFFER_POOL_READS', '2627'),
('INNODB_BUFFER_POOL_WAIT_FREE', '0'),
('INNODB_BUFFER_POOL_WRITE_REQUESTS', '949044'),
('INNODB_DATA_FSYNCS', '253684'),
('INNODB_DATA_PENDING_FSYNCS', '0'),
('INNODB_DATA_PENDING_READS', '0'),
('INNODB_DATA_PENDING_WRITES', '0'),
('INNODB_DATA_READ', '65753088'),
('INNODB_DATA_READS', '2745'),
('INNODB_DATA_WRITES', '457995'),
('INNODB_DATA_WRITTEN', '9328371200'),
('INNODB_DBLWR_PAGES_WRITTEN', '280215'),
('INNODB_DBLWR_WRITES', '50821'),
('INNODB_HAVE_ATOMIC_BUILTINS', 'ON'),
('INNODB_LOG_WAITS', '0'),
('INNODB_LOG_WRITE_REQUESTS', '175058'),
('INNODB_LOG_WRITES', '103322'),
('INNODB_OS_LOG_FSYNCS', '152200'),
('INNODB_OS_LOG_PENDING_FSYNCS', '0'),
('INNODB_OS_LOG_PENDING_WRITES', '0'),
('INNODB_OS_LOG_WRITTEN', '121351168'),
('INNODB_PAGE_SIZE', '16384'),
('INNODB_PAGES_CREATED', '515'),
('INNODB_PAGES_READ', '3879'),
('INNODB_PAGES_WRITTEN', '280215'),
('INNODB_ROW_LOCK_CURRENT_WAITS', '0'),
('INNODB_ROW_LOCK_TIME', '621'),
('INNODB_ROW_LOCK_TIME_AVG', '19'),
('INNODB_ROW_LOCK_TIME_MAX', '51'),
('INNODB_ROW_LOCK_WAITS', '32'),
('INNODB_ROWS_DELETED', '20862'),
('INNODB_ROWS_INSERTED', '20316'),
('INNODB_ROWS_READ', '2143134374'),
('INNODB_ROWS_UPDATED', '69345'),
('INNODB_TRUNCATED_STATUS_WRITES', '0'),
('KEY_BLOCKS_NOT_FLUSHED', '0'),
('KEY_BLOCKS_UNUSED', '13340'),
('KEY_BLOCKS_USED', '230'),
('KEY_READ_REQUESTS', '1789660334'),
('KEY_READS', '46'),
('KEY_WRITE_REQUESTS', '502456742'),
('KEY_WRITES', '1406826'),
('LAST_QUERY_COST', '10.499000'),
('MAX_USED_CONNECTIONS', '41'),
('NOT_FLUSHED_DELAYED_ROWS', '0'),
('OPEN_FILES', '176'),
('OPEN_STREAMS', '0'),
('OPEN_TABLE_DEFINITIONS', '306'),
('OPEN_TABLES', '354'),
('OPENED_FILES', '1648891'),
('OPENED_TABLE_DEFINITIONS', '0'),
('OPENED_TABLES', '22'),
('PERFORMANCE_SCHEMA_COND_CLASSES_LOST', '0'),
('PERFORMANCE_SCHEMA_COND_INSTANCES_LOST', '0'),
('PERFORMANCE_SCHEMA_FILE_CLASSES_LOST', '0'),
('PERFORMANCE_SCHEMA_FILE_HANDLES_LOST', '0'),
('PERFORMANCE_SCHEMA_FILE_INSTANCES_LOST', '0'),
('PERFORMANCE_SCHEMA_LOCKER_LOST', '0'),
('PERFORMANCE_SCHEMA_MUTEX_CLASSES_LOST', '0'),
('PERFORMANCE_SCHEMA_MUTEX_INSTANCES_LOST', '0'),
('PERFORMANCE_SCHEMA_RWLOCK_CLASSES_LOST', '0'),
('PERFORMANCE_SCHEMA_RWLOCK_INSTANCES_LOST', '0'),
('PERFORMANCE_SCHEMA_TABLE_HANDLES_LOST', '0'),
('PERFORMANCE_SCHEMA_TABLE_INSTANCES_LOST', '0'),
('PERFORMANCE_SCHEMA_THREAD_CLASSES_LOST', '0'),
('PERFORMANCE_SCHEMA_THREAD_INSTANCES_LOST', '0'),
('PREPARED_STMT_COUNT', '0'),
('QCACHE_FREE_BLOCKS', '1041'),
('QCACHE_FREE_MEMORY', '3370520'),
('QCACHE_HITS', '17372122'),
('QCACHE_INSERTS', '2075265'),
('QCACHE_LOWMEM_PRUNES', '1049740'),
('QCACHE_NOT_CACHED', '440241'),
('QCACHE_QUERIES_IN_CACHE', '3656'),
('QCACHE_TOTAL_BLOCKS', '8815'),
('QUERIES', '22350606'),
('QUESTIONS', '274'),
('RPL_STATUS', 'AUTH_MASTER'),
('SELECT_FULL_JOIN', '0'),
('SELECT_FULL_RANGE_JOIN', '0'),
('SELECT_RANGE', '0'),
('SELECT_RANGE_CHECK', '0'),
('SELECT_SCAN', '177'),
('SLAVE_HEARTBEAT_PERIOD', '0.000'),
('SLAVE_OPEN_TEMP_TABLES', '0'),
('SLAVE_RECEIVED_HEARTBEATS', '0'),
('SLAVE_RETRIED_TRANSACTIONS', '0'),
('SLAVE_RUNNING', 'OFF'),
('SLOW_LAUNCH_THREADS', '0'),
('SLOW_QUERIES', '0'),
('SORT_MERGE_PASSES', '0'),
('SORT_RANGE', '0'),
('SORT_ROWS', '0'),
('SORT_SCAN', '0'),
('SSL_ACCEPT_RENEGOTIATES', '0'),
('SSL_ACCEPTS', '0'),
('SSL_CALLBACK_CACHE_HITS', '0'),
('SSL_CIPHER', ''),
('SSL_CIPHER_LIST', ''),
('SSL_CLIENT_CONNECTS', '0'),
('SSL_CONNECT_RENEGOTIATES', '0'),
('SSL_CTX_VERIFY_DEPTH', '0'),
('SSL_CTX_VERIFY_MODE', '0'),
('SSL_DEFAULT_TIMEOUT', '0'),
('SSL_FINISHED_ACCEPTS', '0'),
('SSL_FINISHED_CONNECTS', '0'),
('SSL_SESSION_CACHE_HITS', '0'),
('SSL_SESSION_CACHE_MISSES', '0'),
('SSL_SESSION_CACHE_MODE', 'NONE'),
('SSL_SESSION_CACHE_OVERFLOWS', '0'),
('SSL_SESSION_CACHE_SIZE', '0'),
('SSL_SESSION_CACHE_TIMEOUTS', '0'),
('SSL_SESSIONS_REUSED', '0'),
('SSL_USED_SESSION_CACHE_ENTRIES', '0'),
('SSL_VERIFY_DEPTH', '0'),
('SSL_VERIFY_MODE', '0'),
('SSL_VERSION', ''),
('TABLE_LOCKS_IMMEDIATE', '3702859'),
('TABLE_LOCKS_WAITED', '1'),
('TC_LOG_MAX_PAGES_USED', '0'),
('TC_LOG_PAGE_SIZE', '0'),
('TC_LOG_PAGE_WAITS', '0'),
('THREADS_CACHED', '5'),
('THREADS_CONNECTED', '3'),
('THREADS_CREATED', '588'),
('THREADS_RUNNING', '1'),
('UPTIME', '2480530'),
('UPTIME_SINCE_FLUSH_STATUS', '2480530');

-- --------------------------------------------------------

--
-- Table structure for table `SESSION_VARIABLES`
--

CREATE TEMPORARY TABLE `SESSION_VARIABLES` (
  `VARIABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `SESSION_VARIABLES`
--

INSERT INTO `SESSION_VARIABLES` (`VARIABLE_NAME`, `VARIABLE_VALUE`) VALUES
('MAX_PREPARED_STMT_COUNT', '16382'),
('INNODB_FILE_PER_TABLE', 'OFF'),
('HAVE_CRYPT', 'YES'),
('PERFORMANCE_SCHEMA_EVENTS_WAITS_HISTORY_LONG_SIZE', '10000'),
('INNODB_VERSION', '1.1.8'),
('QUERY_PREALLOC_SIZE', '8192'),
('DELAYED_QUEUE_SIZE', '1000'),
('PERFORMANCE_SCHEMA_MAX_COND_INSTANCES', '1000'),
('HAVE_SSL', 'DISABLED'),
('COLLATION_SERVER', 'latin1_swedish_ci'),
('SECURE_FILE_PRIV', ''),
('TIMED_MUTEXES', 'OFF'),
('DELAYED_INSERT_TIMEOUT', '300'),
('PERFORMANCE_SCHEMA_MAX_MUTEX_INSTANCES', '1000000'),
('PLUGIN_DIR', '/usr/lib/mysql/plugin/'),
('PERFORMANCE_SCHEMA_MAX_RWLOCK_INSTANCES', '1000000'),
('LOG_SLOW_QUERIES', 'OFF'),
('PERFORMANCE_SCHEMA_MAX_RWLOCK_CLASSES', '30'),
('BASEDIR', '/usr'),
('PERFORMANCE_SCHEMA_MAX_MUTEX_CLASSES', '200'),
('UPDATABLE_VIEWS_WITH_LIMIT', 'YES'),
('BACK_LOG', '50'),
('SLOW_LAUNCH_TIME', '2'),
('EVENT_SCHEDULER', 'OFF'),
('MAX_SEEKS_FOR_KEY', '18446744073709551615'),
('PERFORMANCE_SCHEMA_MAX_THREAD_CLASSES', '50'),
('RELAY_LOG_INDEX', ''),
('FT_STOPWORD_FILE', '(built-in)'),
('SQL_QUOTE_SHOW_CREATE', 'ON'),
('PERFORMANCE_SCHEMA', 'OFF'),
('QUERY_CACHE_SIZE', '16777216'),
('BINLOG_FORMAT', 'STATEMENT'),
('WAIT_TIMEOUT', '28800'),
('LONG_QUERY_TIME', '10.000000'),
('PERFORMANCE_SCHEMA_MAX_TABLE_HANDLES', '100000'),
('CHARACTER_SETS_DIR', '/usr/share/mysql/charsets/'),
('LOWER_CASE_TABLE_NAMES', '0'),
('BINLOG_CACHE_SIZE', '32768'),
('REPORT_HOST', ''),
('CHARACTER_SET_RESULTS', 'utf8'),
('MYISAM_SORT_BUFFER_SIZE', '8388608'),
('CHARACTER_SET_CONNECTION', 'utf8'),
('INNODB_ROLLBACK_SEGMENTS', '128'),
('PRELOAD_BUFFER_SIZE', '32768'),
('LARGE_FILES_SUPPORT', 'ON'),
('MAX_WRITE_LOCK_COUNT', '18446744073709551615'),
('LOG_SLAVE_UPDATES', 'OFF'),
('SYNC_MASTER_INFO', '0'),
('NET_BUFFER_LENGTH', '16384'),
('FT_QUERY_EXPANSION_LIMIT', '20'),
('SKIP_SHOW_DATABASE', 'OFF'),
('FT_MAX_WORD_LEN', '84'),
('GROUP_CONCAT_MAX_LEN', '1024'),
('MAX_SP_RECURSION_DEPTH', '0'),
('RANGE_ALLOC_BLOCK_SIZE', '4096'),
('RELAY_LOG', ''),
('OPTIMIZER_PRUNE_LEVEL', '1'),
('INNODB_FLUSH_METHOD', ''),
('INNODB_LOG_FILE_SIZE', '5242880'),
('DELAY_KEY_WRITE', 'ON'),
('TRANSACTION_PREALLOC_SIZE', '4096'),
('INTERACTIVE_TIMEOUT', '28800'),
('MYISAM_RECOVER_OPTIONS', 'BACKUP'),
('AUTOMATIC_SP_PRIVILEGES', 'ON'),
('INNODB_USE_SYS_MALLOC', 'ON'),
('DELAYED_INSERT_LIMIT', '100'),
('LOW_PRIORITY_UPDATES', 'OFF'),
('COMPLETION_TYPE', 'NO_CHAIN'),
('REPORT_PASSWORD', ''),
('BINLOG_DIRECT_NON_TRANSACTIONAL_UPDATES', 'OFF'),
('MAX_INSERT_DELAYED_THREADS', '20'),
('VERSION_COMMENT', '(Ubuntu)'),
('HAVE_COMPRESS', 'YES'),
('AUTO_INCREMENT_OFFSET', '1'),
('TRANSACTION_ALLOC_BLOCK_SIZE', '8192'),
('JOIN_BUFFER_SIZE', '131072'),
('THREAD_CACHE_SIZE', '8'),
('CONNECT_TIMEOUT', '10'),
('INNODB_DOUBLEWRITE', 'ON'),
('SQL_LOW_PRIORITY_UPDATES', 'OFF'),
('IGNORE_BUILTIN_INNODB', 'OFF'),
('INIT_FILE', ''),
('DEFAULT_WEEK_FORMAT', '0'),
('LARGE_PAGES', 'OFF'),
('LOG_OUTPUT', 'FILE'),
('LARGE_PAGE_SIZE', '0'),
('INNODB_IO_CAPACITY', '200'),
('INIT_SLAVE', ''),
('INNODB_USE_NATIVE_AIO', 'OFF'),
('MAX_BINLOG_SIZE', '104857600'),
('HAVE_SYMLINK', 'YES'),
('MAX_ERROR_COUNT', '64'),
('TIME_ZONE', '+00:00'),
('MAX_CONNECTIONS', '151'),
('INNODB_TABLE_LOCKS', 'ON'),
('PROXY_USER', ''),
('INNODB_AUTOEXTEND_INCREMENT', '8'),
('READ_BUFFER_SIZE', '131072'),
('MYISAM_DATA_POINTER_SIZE', '6'),
('PSEUDO_THREAD_ID', '278620'),
('INNODB_THREAD_SLEEP_DELAY', '10000'),
('LOG_QUERIES_NOT_USING_INDEXES', 'OFF'),
('SQL_AUTO_IS_NULL', 'OFF'),
('LOWER_CASE_FILE_SYSTEM', 'OFF'),
('SLAVE_TRANSACTION_RETRIES', '10'),
('SORT_BUFFER_SIZE', '2097152'),
('KEEP_FILES_ON_CREATE', 'OFF'),
('MAX_HEAP_TABLE_SIZE', '16777216'),
('SYNC_RELAY_LOG_INFO', '0'),
('LOCK_WAIT_TIMEOUT', '31536000'),
('INNODB_REPLICATION_DELAY', '0'),
('KEY_CACHE_AGE_THRESHOLD', '300'),
('QUERY_CACHE_MIN_RES_UNIT', '4096'),
('NET_RETRY_COUNT', '10'),
('INNODB_STATS_ON_METADATA', 'ON'),
('LOG_WARNINGS', '1'),
('INNODB_ROLLBACK_ON_TIMEOUT', 'OFF'),
('FLUSH', 'OFF'),
('PROFILING_HISTORY_SIZE', '15'),
('MAX_LONG_DATA_SIZE', '16777216'),
('INNODB_CHANGE_BUFFERING', 'all'),
('CHARACTER_SET_SERVER', 'latin1'),
('READ_RND_BUFFER_SIZE', '262144'),
('SLAVE_MAX_ALLOWED_PACKET', '1073741824'),
('INNODB_FILE_FORMAT', 'Antelope'),
('FLUSH_TIME', '0'),
('BIG_TABLES', 'OFF'),
('CHARACTER_SET_DATABASE', 'utf8'),
('SQL_SELECT_LIMIT', '18446744073709551615'),
('BULK_INSERT_BUFFER_SIZE', '8388608'),
('DATE_FORMAT', '%Y-%m-%d'),
('CHARACTER_SET_FILESYSTEM', 'binary'),
('READ_ONLY', 'OFF'),
('BINLOG_STMT_CACHE_SIZE', '32768'),
('RAND_SEED1', '0'),
('MAX_BINLOG_CACHE_SIZE', '18446744073709547520'),
('INNODB_DATA_FILE_PATH', 'ibdata1:10M:autoextend'),
('PERFORMANCE_SCHEMA_MAX_FILE_CLASSES', '50'),
('INNODB_PURGE_THREADS', '0'),
('MAX_SORT_LENGTH', '1024'),
('PROFILING', 'OFF'),
('PERFORMANCE_SCHEMA_EVENTS_WAITS_HISTORY_SIZE', '10'),
('INNODB_STRICT_MODE', 'OFF'),
('SLAVE_COMPRESSED_PROTOCOL', 'OFF'),
('KEY_CACHE_DIVISION_LIMIT', '100'),
('OLD_PASSWORDS', 'OFF'),
('GENERAL_LOG_FILE', '/var/lib/mysql/wpshell.log'),
('NET_WRITE_TIMEOUT', '60'),
('PERFORMANCE_SCHEMA_MAX_COND_CLASSES', '80'),
('QUERY_CACHE_TYPE', 'ON'),
('AUTO_INCREMENT_INCREMENT', '1'),
('METADATA_LOCKS_CACHE_SIZE', '1024'),
('TMPDIR', '/tmp'),
('QUERY_CACHE_LIMIT', '1048576'),
('EXPIRE_LOGS_DAYS', '10'),
('TX_ISOLATION', 'REPEATABLE-READ'),
('HAVE_PARTITIONING', 'YES'),
('LOG_ERROR', ''),
('FOREIGN_KEY_CHECKS', 'ON'),
('MAX_LENGTH_FOR_SORT_DATA', '1024'),
('RELAY_LOG_INFO_FILE', 'relay-log.info'),
('THREAD_STACK', '196608'),
('INNODB_AUTOINC_LOCK_MODE', '1'),
('NEW', 'OFF'),
('INNODB_COMMIT_CONCURRENCY', '0'),
('SKIP_NAME_RESOLVE', 'OFF'),
('INNODB_MIRRORED_LOG_GROUPS', '1'),
('PID_FILE', '/var/run/mysqld/mysqld.pid'),
('INNODB_PURGE_BATCH_SIZE', '20'),
('MAX_CONNECT_ERRORS', '10'),
('VERSION', '5.5.29-0ubuntu0.12.04.1'),
('CONCURRENT_INSERT', 'AUTO'),
('INNODB_SUPPORT_XA', 'ON'),
('TABLE_DEFINITION_CACHE', '400'),
('INNODB_SYNC_SPIN_LOOPS', '30'),
('QUERY_ALLOC_BLOCK_SIZE', '8192'),
('COLLATION_CONNECTION', 'utf8_general_ci'),
('INNODB_ADDITIONAL_MEM_POOL_SIZE', '8388608'),
('INNODB_ADAPTIVE_FLUSHING', 'ON'),
('FT_BOOLEAN_SYNTAX', '+ -><()~*:""&|'),
('INNODB_ADAPTIVE_HASH_INDEX', 'ON'),
('VERSION_COMPILE_MACHINE', 'x86_64'),
('SYSTEM_TIME_ZONE', 'EST'),
('QUERY_CACHE_WLOCK_INVALIDATE', 'OFF'),
('DIV_PRECISION_INCREMENT', '4'),
('SLOW_QUERY_LOG_FILE', '/var/lib/mysql/wpshell-slow.log'),
('STORED_PROGRAM_CACHE', '256'),
('TMP_TABLE_SIZE', '16777216'),
('INNODB_DATA_HOME_DIR', ''),
('PERFORMANCE_SCHEMA_MAX_THREAD_INSTANCES', '1000'),
('INNODB_READ_IO_THREADS', '4'),
('SECURE_AUTH', 'OFF'),
('INNODB_WRITE_IO_THREADS', '4'),
('SERVER_ID', '0'),
('INNODB_BUFFER_POOL_INSTANCES', '1'),
('SKIP_NETWORKING', 'OFF'),
('INNODB_FORCE_RECOVERY', '0'),
('CHARACTER_SET_SYSTEM', 'utf8'),
('INNODB_LOG_FILES_IN_GROUP', '2'),
('INIT_CONNECT', ''),
('ERROR_COUNT', '0'),
('OPTIMIZER_SEARCH_DEPTH', '62'),
('HAVE_DYNAMIC_LOADING', 'YES'),
('AUTOCOMMIT', 'ON'),
('SYNC_BINLOG', '0'),
('SSL_CAPATH', ''),
('RELAY_LOG_SPACE_LIMIT', '0'),
('SLAVE_EXEC_MODE', 'STRICT'),
('INNODB_OPEN_FILES', '300'),
('GENERAL_LOG', 'OFF'),
('INNODB_FILE_FORMAT_CHECK', 'ON'),
('LAST_INSERT_ID', '0'),
('INNODB_READ_AHEAD_THRESHOLD', '56'),
('HOSTNAME', 'wpshell.sytes.net'),
('KEY_CACHE_BLOCK_SIZE', '1024'),
('SQL_LOG_OFF', 'OFF'),
('KEY_BUFFER_SIZE', '16777216'),
('REPORT_PORT', '3306'),
('HAVE_NDBCLUSTER', 'NO'),
('SQL_LOG_BIN', 'ON'),
('SSL_CIPHER', ''),
('THREAD_HANDLING', 'one-thread-per-connection'),
('INNODB_STATS_METHOD', 'nulls_equal'),
('LOG_BIN', 'OFF'),
('INNODB_FAST_SHUTDOWN', '1'),
('SQL_BIG_SELECTS', 'ON'),
('SSL_CA', ''),
('MAX_USER_CONNECTIONS', '0'),
('INNODB_THREAD_CONCURRENCY', '0'),
('SQL_MAX_JOIN_SIZE', '18446744073709551615'),
('SLAVE_NET_TIMEOUT', '3600'),
('TABLE_OPEN_CACHE', '400'),
('INNODB_STATS_SAMPLE_PAGES', '8'),
('SQL_BIG_TABLES', 'OFF'),
('LOCAL_INFILE', 'ON'),
('SQL_BUFFER_RESULT', 'OFF'),
('HAVE_RTREE_KEYS', 'YES'),
('ENGINE_CONDITION_PUSHDOWN', 'ON'),
('HAVE_PROFILING', 'YES'),
('LC_MESSAGES_DIR', '/usr/share/mysql/'),
('OLD_ALTER_TABLE', 'OFF'),
('HAVE_INNODB', 'YES'),
('MYISAM_MMAP_SIZE', '18446744073709551615'),
('SQL_MODE', ''),
('PERFORMANCE_SCHEMA_MAX_FILE_HANDLES', '32768'),
('TIMESTAMP', '1361765347'),
('RELAY_LOG_RECOVERY', 'OFF'),
('REPORT_USER', ''),
('MAX_DELAYED_THREADS', '20'),
('HAVE_GEOMETRY', 'YES'),
('DATETIME_FORMAT', '%Y-%m-%d %H:%i:%s'),
('SLOW_QUERY_LOG', 'OFF'),
('INNODB_FLUSH_LOG_AT_TRX_COMMIT', '1'),
('MAX_TMP_TABLES', '32'),
('MAX_RELAY_LOG_SIZE', '0'),
('LOG', 'OFF'),
('INNODB_RANDOM_READ_AHEAD', 'OFF'),
('OPEN_FILES_LIMIT', '1024'),
('HAVE_CSV', 'YES'),
('DATADIR', '/var/lib/mysql/'),
('PORT', '3306'),
('SLAVE_LOAD_TMPDIR', '/tmp'),
('VERSION_COMPILE_OS', 'debian-linux-gnu'),
('FT_MIN_WORD_LEN', '4'),
('LOG_BIN_TRUST_FUNCTION_CREATORS', 'OFF'),
('HAVE_QUERY_CACHE', 'YES'),
('INNODB_FORCE_LOAD_CORRUPTED', 'OFF'),
('SYNC_RELAY_LOG', '0'),
('HAVE_OPENSSL', 'DISABLED'),
('LC_TIME_NAMES', 'en_US'),
('MAX_BINLOG_STMT_CACHE_SIZE', '18446744073709547520'),
('TIME_FORMAT', '%H:%i:%s'),
('PERFORMANCE_SCHEMA_MAX_FILE_INSTANCES', '10000'),
('LC_MESSAGES', 'en_US'),
('INNODB_SPIN_WAIT_DELAY', '6'),
('NET_READ_TIMEOUT', '30'),
('INNODB_FILE_FORMAT_MAX', 'Antelope'),
('SYNC_FRM', 'ON'),
('DEFAULT_STORAGE_ENGINE', 'InnoDB'),
('EXTERNAL_USER', ''),
('INNODB_LOCK_WAIT_TIMEOUT', '50'),
('MULTI_RANGE_COUNT', '256'),
('INNODB_OLD_BLOCKS_TIME', '0'),
('OLD', 'OFF'),
('RPL_RECOVERY_RANK', '0'),
('WARNING_COUNT', '0'),
('MYISAM_STATS_METHOD', 'nulls_unequal'),
('MAX_ALLOWED_PACKET', '16777216'),
('OPTIMIZER_SWITCH', 'index_merge=on,index_merge_union=on,index_merge_sort_union=on,index_merge_intersection=on,engine_condition_pushdown=on'),
('SQL_WARNINGS', 'OFF'),
('LOCKED_IN_MEMORY', 'OFF'),
('SQL_SLAVE_SKIP_COUNTER', '0'),
('SOCKET', '/var/run/mysqld/mysqld.sock'),
('INNODB_CHECKSUMS', 'ON'),
('STORAGE_ENGINE', 'InnoDB'),
('INNODB_LOCKS_UNSAFE_FOR_BINLOG', 'OFF'),
('SSL_KEY', ''),
('MYISAM_USE_MMAP', 'OFF'),
('SKIP_EXTERNAL_LOCKING', 'ON'),
('INNODB_CONCURRENCY_TICKETS', '500'),
('SLAVE_SKIP_ERRORS', 'OFF'),
('SQL_SAFE_UPDATES', 'OFF'),
('INSERT_ID', '0'),
('MAX_JOIN_SIZE', '18446744073709551615'),
('RELAY_LOG_PURGE', 'ON'),
('INNODB_BUFFER_POOL_SIZE', '134217728'),
('COLLATION_DATABASE', 'utf8_general_ci'),
('INNODB_LOG_GROUP_HOME_DIR', './'),
('SSL_CERT', ''),
('INNODB_LARGE_PREFIX', 'OFF'),
('INNODB_LOG_BUFFER_SIZE', '8388608'),
('CHARACTER_SET_CLIENT', 'utf8'),
('IDENTITY', '0'),
('RAND_SEED2', '0'),
('INNODB_MAX_PURGE_LAG', '0'),
('MIN_EXAMINED_ROW_LIMIT', '0'),
('MYISAM_MAX_SORT_FILE_SIZE', '9223372036853727232'),
('MYISAM_REPAIR_THREADS', '1'),
('SLAVE_TYPE_CONVERSIONS', ''),
('PROTOCOL_VERSION', '10'),
('SQL_NOTES', 'ON'),
('LICENSE', 'GPL'),
('INNODB_MAX_DIRTY_PAGES_PCT', '75'),
('PERFORMANCE_SCHEMA_MAX_TABLE_INSTANCES', '50000'),
('THREAD_CONCURRENCY', '10'),
('UNIQUE_CHECKS', 'ON'),
('INNODB_OLD_BLOCKS_PCT', '37');

-- --------------------------------------------------------

--
-- Table structure for table `STATISTICS`
--

CREATE TEMPORARY TABLE `STATISTICS` (
  `TABLE_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `TABLE_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `TABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `NON_UNIQUE` bigint(1) NOT NULL DEFAULT '0',
  `INDEX_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `INDEX_NAME` varchar(64) NOT NULL DEFAULT '',
  `SEQ_IN_INDEX` bigint(2) NOT NULL DEFAULT '0',
  `COLUMN_NAME` varchar(64) NOT NULL DEFAULT '',
  `COLLATION` varchar(1) DEFAULT NULL,
  `CARDINALITY` bigint(21) DEFAULT NULL,
  `SUB_PART` bigint(3) DEFAULT NULL,
  `PACKED` varchar(10) DEFAULT NULL,
  `NULLABLE` varchar(3) NOT NULL DEFAULT '',
  `INDEX_TYPE` varchar(16) NOT NULL DEFAULT '',
  `COMMENT` varchar(16) DEFAULT NULL,
  `INDEX_COMMENT` varchar(1024) NOT NULL DEFAULT ''
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `STATISTICS`
--

INSERT INTO `STATISTICS` (`TABLE_CATALOG`, `TABLE_SCHEMA`, `TABLE_NAME`, `NON_UNIQUE`, `INDEX_SCHEMA`, `INDEX_NAME`, `SEQ_IN_INDEX`, `COLUMN_NAME`, `COLLATION`, `CARDINALITY`, `SUB_PART`, `PACKED`, `NULLABLE`, `INDEX_TYPE`, `COMMENT`, `INDEX_COMMENT`) VALUES
('def', 'c9mosh', 'answers', 0, 'c9mosh', 'PRIMARY', 1, 'a_id', 'A', 13, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'answers', 1, 'c9mosh', 'q_id', 1, 'q_id', 'A', 13, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'campus', 0, 'c9mosh', 'PRIMARY', 1, 'c_id', 'A', 3, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'clue', 0, 'c9mosh', 'PRIMARY', 1, 'clue_id', 'A', 0, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'clue', 1, 'c9mosh', 'clue_typ_id', 1, 'clue_typ_id', 'A', 0, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'clue_question', 0, 'c9mosh', 'PRIMARY', 1, 'clue_id', 'A', 0, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'clue_question', 0, 'c9mosh', 'PRIMARY', 2, 'q_id', 'A', 0, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'clue_question', 1, 'c9mosh', 'q_id', 1, 'q_id', 'A', 0, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'clue_type', 0, 'c9mosh', 'PRIMARY', 1, 'clue_typ_id', 'A', 0, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'dic', 0, 'c9mosh', 'PRIMARY', 1, 'td_id', 'A', 14, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'dic_question', 0, 'c9mosh', 'PRIMARY', 1, 'td_id', 'A', 20, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'dic_question', 0, 'c9mosh', 'PRIMARY', 2, 'q_id', 'A', 20, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'dic_question', 1, 'c9mosh', 'q_id', 1, 'q_id', 'A', 20, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'game', 0, 'c9mosh', 'PRIMARY', 1, 'g_id', 'A', 1, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'game_task', 0, 'c9mosh', 'PRIMARY', 1, 'tsk_id', 'A', 3, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'game_task', 0, 'c9mosh', 'PRIMARY', 2, 'g_id', 'A', 3, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'game_task', 1, 'c9mosh', 'prv_tsk_id', 1, 'prv_tsk_id', 'A', 3, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'game_task', 1, 'c9mosh', 'g_id', 1, 'g_id', 'A', 3, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'login', 0, 'c9mosh', 'login_name', 1, 'login_name', 'A', 18, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'login', 0, 'c9mosh', 'u_id', 1, 'u_id', 'A', 18, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'login', 1, 'c9mosh', 'p_id', 1, 'p_id', 'A', 2, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'permissions', 0, 'c9mosh', 'PRIMARY', 1, 'p_id', 'A', 5, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'progress', 0, 'c9mosh', 'pk_progress_rule', 1, 't_id', 'A', 13, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'progress', 0, 'c9mosh', 'pk_progress_rule', 2, 'u_id', 'A', 27, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'progress', 0, 'c9mosh', 'pk_progress_rule', 3, 'tsk_id', 'A', 27, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'progress', 0, 'c9mosh', 'pk_progress_rule', 4, 'status', 'A', 27, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'progress', 1, 'c9mosh', 'tsk_id', 1, 'tsk_id', 'A', 6, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'progress', 1, 'c9mosh', 'u_id', 1, 'u_id', 'A', 27, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'question_type', 0, 'c9mosh', 'PRIMARY', 1, 'q_typ_id', 'A', 2, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'questions', 0, 'c9mosh', 'PRIMARY', 1, 'q_id', 'A', 20, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'questions', 1, 'c9mosh', 'q_typ_id', 1, 'q_typ_id', 'A', 4, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'responses', 0, 'c9mosh', 'PRIMARY', 1, 'r_id', 'A', 32, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'responses', 0, 'c9mosh', 'pk_response_rule', 1, 'u_id', 'A', 8, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'responses', 0, 'c9mosh', 'pk_response_rule', 2, 'tsk_id', 'A', 32, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'responses', 0, 'c9mosh', 'pk_response_rule', 3, 'q_id', 'A', 32, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'responses', 0, 'c9mosh', 'pk_response_rule', 4, 'response', 'A', 32, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'responses', 1, 'c9mosh', 't_id', 1, 't_id', 'A', 6, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'responses', 1, 'c9mosh', 'tsk_id', 1, 'tsk_id', 'A', 6, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'responses', 1, 'c9mosh', 'q_id', 1, 'q_id', 'A', 16, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'task_dic', 0, 'c9mosh', 'PRIMARY', 1, 'tsk_id', 'A', 14, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'task_dic', 0, 'c9mosh', 'PRIMARY', 2, 'td_id', 'A', 14, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'task_dic', 1, 'c9mosh', 'td_id', 1, 'td_id', 'A', 14, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'tasks', 0, 'c9mosh', 'PRIMARY', 1, 'tsk_id', 'A', 10, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'tasks', 0, 'c9mosh', 'secret_id', 1, 'secret_id', 'A', 10, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'tasks', 1, 'c9mosh', 'c_id', 1, 'c_id', 'A', 2, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'team_game', 0, 'c9mosh', 'PRIMARY', 1, 't_id', 'A', 5, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'team_game', 0, 'c9mosh', 'PRIMARY', 2, 'g_id', 'A', 5, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'team_game', 1, 'c9mosh', 'g_id', 1, 'g_id', 'A', 2, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'team_user', 0, 'c9mosh', 'PRIMARY', 1, 't_id', 'A', 18, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'team_user', 0, 'c9mosh', 'PRIMARY', 2, 'u_id', 'A', 18, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'team_user', 1, 'c9mosh', 'u_id', 1, 'u_id', 'A', 18, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'teams', 0, 'c9mosh', 'PRIMARY', 1, 't_id', 'A', 6, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'teams', 0, 'c9mosh', 't_name', 1, 't_name', 'A', 6, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'teams', 0, 'c9mosh', 't_chat_id', 1, 't_chat_id', 'A', 6, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'user_options', 0, 'c9mosh', 'PRIMARY', 1, 'u_id', 'A', 18, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'user_options', 0, 'c9mosh', 'u_id', 1, 'u_id', 'A', 18, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'users', 0, 'c9mosh', 'PRIMARY', 1, 'u_id', 'A', 18, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'users', 0, 'c9mosh', 's_num', 1, 's_num', 'A', 18, NULL, NULL, '', 'BTREE', '', ''),
('def', 'c9mosh', 'users', 0, 'c9mosh', 'u_nickname', 1, 'u_nickname', 'A', 18, NULL, NULL, 'YES', 'BTREE', '', ''),
('def', 'c9mosh', 'users', 0, 'c9mosh', 'u_email', 1, 'u_email', 'A', 18, NULL, NULL, 'YES', 'BTREE', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `TABLES`
--

CREATE TEMPORARY TABLE `TABLES` (
  `TABLE_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `TABLE_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `TABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `TABLE_TYPE` varchar(64) NOT NULL DEFAULT '',
  `ENGINE` varchar(64) DEFAULT NULL,
  `VERSION` bigint(21) unsigned DEFAULT NULL,
  `ROW_FORMAT` varchar(10) DEFAULT NULL,
  `TABLE_ROWS` bigint(21) unsigned DEFAULT NULL,
  `AVG_ROW_LENGTH` bigint(21) unsigned DEFAULT NULL,
  `DATA_LENGTH` bigint(21) unsigned DEFAULT NULL,
  `MAX_DATA_LENGTH` bigint(21) unsigned DEFAULT NULL,
  `INDEX_LENGTH` bigint(21) unsigned DEFAULT NULL,
  `DATA_FREE` bigint(21) unsigned DEFAULT NULL,
  `AUTO_INCREMENT` bigint(21) unsigned DEFAULT NULL,
  `CREATE_TIME` datetime DEFAULT NULL,
  `UPDATE_TIME` datetime DEFAULT NULL,
  `CHECK_TIME` datetime DEFAULT NULL,
  `TABLE_COLLATION` varchar(32) DEFAULT NULL,
  `CHECKSUM` bigint(21) unsigned DEFAULT NULL,
  `CREATE_OPTIONS` varchar(255) DEFAULT NULL,
  `TABLE_COMMENT` varchar(2048) NOT NULL DEFAULT ''
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `TABLES`
--

INSERT INTO `TABLES` (`TABLE_CATALOG`, `TABLE_SCHEMA`, `TABLE_NAME`, `TABLE_TYPE`, `ENGINE`, `VERSION`, `ROW_FORMAT`, `TABLE_ROWS`, `AVG_ROW_LENGTH`, `DATA_LENGTH`, `MAX_DATA_LENGTH`, `INDEX_LENGTH`, `DATA_FREE`, `AUTO_INCREMENT`, `CREATE_TIME`, `UPDATE_TIME`, `CHECK_TIME`, `TABLE_COLLATION`, `CHECKSUM`, `CREATE_OPTIONS`, `TABLE_COMMENT`) VALUES
('def', 'information_schema', 'CHARACTER_SETS', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 384, 0, 16434816, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=43690', ''),
('def', 'information_schema', 'COLLATIONS', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 231, 0, 16704765, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=72628', ''),
('def', 'information_schema', 'COLLATION_CHARACTER_SET_APPLICABILITY', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 195, 0, 16357770, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=86037', ''),
('def', 'information_schema', 'COLUMNS', 'SYSTEM VIEW', 'MyISAM', 10, 'Dynamic', NULL, 0, 0, 281474976710655, 1024, 0, NULL, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, 'utf8_general_ci', NULL, 'max_rows=2802', ''),
('def', 'information_schema', 'COLUMN_PRIVILEGES', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 2565, 0, 16757145, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=6540', ''),
('def', 'information_schema', 'ENGINES', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 490, 0, 16574250, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=34239', ''),
('def', 'information_schema', 'EVENTS', 'SYSTEM VIEW', 'MyISAM', 10, 'Dynamic', NULL, 0, 0, 281474976710655, 1024, 0, NULL, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, 'utf8_general_ci', NULL, 'max_rows=618', ''),
('def', 'information_schema', 'FILES', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 2677, 0, 16758020, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=6267', ''),
('def', 'information_schema', 'GLOBAL_STATUS', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 3268, 0, 16755036, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=5133', ''),
('def', 'information_schema', 'GLOBAL_VARIABLES', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 3268, 0, 16755036, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=5133', ''),
('def', 'information_schema', 'KEY_COLUMN_USAGE', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 4637, 0, 16762755, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=3618', ''),
('def', 'information_schema', 'PARAMETERS', 'SYSTEM VIEW', 'MyISAM', 10, 'Dynamic', NULL, 0, 0, 281474976710655, 1024, 0, NULL, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, 'utf8_general_ci', NULL, 'max_rows=6050', ''),
('def', 'information_schema', 'PARTITIONS', 'SYSTEM VIEW', 'MyISAM', 10, 'Dynamic', NULL, 0, 0, 281474976710655, 1024, 0, NULL, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, 'utf8_general_ci', NULL, 'max_rows=5579', ''),
('def', 'information_schema', 'PLUGINS', 'SYSTEM VIEW', 'MyISAM', 10, 'Dynamic', NULL, 0, 0, 281474976710655, 1024, 0, NULL, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, 'utf8_general_ci', NULL, 'max_rows=11328', ''),
('def', 'information_schema', 'PROCESSLIST', 'SYSTEM VIEW', 'MyISAM', 10, 'Dynamic', NULL, 0, 0, 281474976710655, 1024, 0, NULL, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, 'utf8_general_ci', NULL, 'max_rows=23899', ''),
('def', 'information_schema', 'PROFILING', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 308, 0, 16562084, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=54471', ''),
('def', 'information_schema', 'REFERENTIAL_CONSTRAINTS', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 4814, 0, 16767162, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=3485', ''),
('def', 'information_schema', 'ROUTINES', 'SYSTEM VIEW', 'MyISAM', 10, 'Dynamic', NULL, 0, 0, 281474976710655, 1024, 0, NULL, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, 'utf8_general_ci', NULL, 'max_rows=583', ''),
('def', 'information_schema', 'SCHEMATA', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 3464, 0, 16738048, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=4843', ''),
('def', 'information_schema', 'SCHEMA_PRIVILEGES', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 2179, 0, 16736899, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=7699', ''),
('def', 'information_schema', 'SESSION_STATUS', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 3268, 0, 16755036, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=5133', ''),
('def', 'information_schema', 'SESSION_VARIABLES', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 3268, 0, 16755036, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=5133', ''),
('def', 'information_schema', 'STATISTICS', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 5753, 0, 16752736, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=2916', ''),
('def', 'information_schema', 'TABLES', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 9450, 0, 16764300, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=1775', ''),
('def', 'information_schema', 'TABLESPACES', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 6951, 0, 16772763, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=2413', ''),
('def', 'information_schema', 'TABLE_CONSTRAINTS', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 2504, 0, 16721712, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=6700', ''),
('def', 'information_schema', 'TABLE_PRIVILEGES', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 2372, 0, 16748692, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=7073', ''),
('def', 'information_schema', 'TRIGGERS', 'SYSTEM VIEW', 'MyISAM', 10, 'Dynamic', NULL, 0, 0, 281474976710655, 1024, 0, NULL, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, 'utf8_general_ci', NULL, 'max_rows=569', ''),
('def', 'information_schema', 'USER_PRIVILEGES', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 1986, 0, 16726092, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=8447', ''),
('def', 'information_schema', 'VIEWS', 'SYSTEM VIEW', 'MyISAM', 10, 'Dynamic', NULL, 0, 0, 281474976710655, 1024, 0, NULL, '2013-02-25 04:09:07', '2013-02-25 04:09:07', NULL, 'utf8_general_ci', NULL, 'max_rows=6935', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 6852, 0, 16766844, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=2448', ''),
('def', 'information_schema', 'INNODB_TRX', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 4534, 0, 16766732, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=3700', ''),
('def', 'information_schema', 'INNODB_BUFFER_POOL_STATS', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 257, 0, 16332350, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=65280', ''),
('def', 'information_schema', 'INNODB_LOCK_WAITS', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 599, 0, 16749238, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=28008', ''),
('def', 'information_schema', 'INNODB_CMPMEM', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 29, 0, 15204352, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=578524', ''),
('def', 'information_schema', 'INNODB_CMP', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 25, 0, 13107200, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=671088', ''),
('def', 'information_schema', 'INNODB_LOCKS', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 31244, 0, 16746784, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=536', ''),
('def', 'information_schema', 'INNODB_CMPMEM_RESET', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 29, 0, 15204352, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=578524', ''),
('def', 'information_schema', 'INNODB_CMP_RESET', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 25, 0, 13107200, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=671088', ''),
('def', 'information_schema', 'INNODB_BUFFER_PAGE_LRU', 'SYSTEM VIEW', 'MEMORY', 10, 'Fixed', NULL, 6669, 0, 16765866, 0, 0, NULL, '2013-02-25 04:09:07', NULL, NULL, 'utf8_general_ci', NULL, 'max_rows=2515', ''),
('def', 'c9mosh', 'answers', 'BASE TABLE', 'InnoDB', 10, 'Compact', 13, 1260, 16384, 0, 16384, 4194304, 14, '2013-02-17 16:31:48', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'campus', 'BASE TABLE', 'InnoDB', 10, 'Compact', 3, 5461, 16384, 0, 0, 4194304, 4, '2013-02-17 16:31:47', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'clue', 'BASE TABLE', 'InnoDB', 10, 'Compact', 0, 0, 16384, 0, 16384, 4194304, 1, '2013-02-17 16:31:49', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'clue_question', 'BASE TABLE', 'InnoDB', 10, 'Compact', 0, 0, 16384, 0, 16384, 4194304, NULL, '2013-02-17 16:31:49', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'clue_type', 'BASE TABLE', 'InnoDB', 10, 'Compact', 0, 0, 16384, 0, 0, 4194304, 1, '2013-02-17 16:31:49', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'dic', 'BASE TABLE', 'InnoDB', 10, 'Compact', 14, 1170, 16384, 0, 0, 4194304, 15, '2013-02-17 16:31:47', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'dic_question', 'BASE TABLE', 'InnoDB', 10, 'Compact', 20, 819, 16384, 0, 16384, 4194304, NULL, '2013-02-17 16:31:49', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'game', 'BASE TABLE', 'InnoDB', 10, 'Compact', 1, 16384, 16384, 0, 0, 4194304, 2, '2013-02-17 16:31:49', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'game_task', 'BASE TABLE', 'InnoDB', 10, 'Compact', 3, 5461, 16384, 0, 32768, 4194304, NULL, '2013-02-17 16:31:50', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'login', 'BASE TABLE', 'InnoDB', 10, 'Compact', 18, 910, 16384, 0, 32768, 4194304, NULL, '2013-02-17 16:31:47', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'permissions', 'BASE TABLE', 'InnoDB', 10, 'Compact', 5, 3276, 16384, 0, 0, 4194304, NULL, '2013-02-17 16:31:47', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'progress', 'BASE TABLE', 'InnoDB', 10, 'Compact', 27, 606, 16384, 0, 49152, 4194304, NULL, '2013-02-17 16:31:51', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'question_type', 'BASE TABLE', 'InnoDB', 10, 'Compact', 2, 8192, 16384, 0, 0, 4194304, 3, '2013-02-17 16:31:48', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'questions', 'BASE TABLE', 'InnoDB', 10, 'Compact', 20, 819, 16384, 0, 16384, 4194304, 21, '2013-02-17 16:31:48', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'responses', 'BASE TABLE', 'InnoDB', 10, 'Compact', 32, 512, 16384, 0, 65536, 4194304, 33, '2013-02-17 16:31:51', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'task_dic', 'BASE TABLE', 'InnoDB', 10, 'Compact', 14, 1170, 16384, 0, 16384, 4194304, NULL, '2013-02-17 16:31:48', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'tasks', 'BASE TABLE', 'InnoDB', 10, 'Compact', 10, 1638, 16384, 0, 32768, 4194304, 11, '2013-02-17 16:31:48', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'team_game', 'BASE TABLE', 'InnoDB', 10, 'Compact', 5, 3276, 16384, 0, 16384, 4194304, NULL, '2013-02-17 16:31:50', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'team_user', 'BASE TABLE', 'InnoDB', 10, 'Compact', 18, 910, 16384, 0, 16384, 4194304, NULL, '2013-02-17 16:31:47', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'teams', 'BASE TABLE', 'InnoDB', 10, 'Compact', 6, 2730, 16384, 0, 32768, 4194304, 7, '2013-02-17 16:31:47', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'user_options', 'BASE TABLE', 'InnoDB', 10, 'Compact', 18, 910, 16384, 0, 16384, 4194304, NULL, '2013-02-23 18:47:08', NULL, NULL, 'utf8_general_ci', NULL, '', ''),
('def', 'c9mosh', 'users', 'BASE TABLE', 'InnoDB', 10, 'Compact', 18, 910, 16384, 0, 49152, 4194304, 18, '2013-02-17 16:31:46', NULL, NULL, 'utf8_general_ci', NULL, '', '');

-- --------------------------------------------------------

--
-- Table structure for table `TABLESPACES`
--

CREATE TEMPORARY TABLE `TABLESPACES` (
  `TABLESPACE_NAME` varchar(64) NOT NULL DEFAULT '',
  `ENGINE` varchar(64) NOT NULL DEFAULT '',
  `TABLESPACE_TYPE` varchar(64) DEFAULT NULL,
  `LOGFILE_GROUP_NAME` varchar(64) DEFAULT NULL,
  `EXTENT_SIZE` bigint(21) unsigned DEFAULT NULL,
  `AUTOEXTEND_SIZE` bigint(21) unsigned DEFAULT NULL,
  `MAXIMUM_SIZE` bigint(21) unsigned DEFAULT NULL,
  `NODEGROUP_ID` bigint(21) unsigned DEFAULT NULL,
  `TABLESPACE_COMMENT` varchar(2048) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `TABLE_CONSTRAINTS`
--

CREATE TEMPORARY TABLE `TABLE_CONSTRAINTS` (
  `CONSTRAINT_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `CONSTRAINT_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `CONSTRAINT_NAME` varchar(64) NOT NULL DEFAULT '',
  `TABLE_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `TABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `CONSTRAINT_TYPE` varchar(64) NOT NULL DEFAULT ''
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `TABLE_CONSTRAINTS`
--

INSERT INTO `TABLE_CONSTRAINTS` (`CONSTRAINT_CATALOG`, `CONSTRAINT_SCHEMA`, `CONSTRAINT_NAME`, `TABLE_SCHEMA`, `TABLE_NAME`, `CONSTRAINT_TYPE`) VALUES
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'answers', 'PRIMARY KEY'),
('def', 'c9mosh', 'answers_ibfk_1', 'c9mosh', 'answers', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'campus', 'PRIMARY KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'clue', 'PRIMARY KEY'),
('def', 'c9mosh', 'clue_ibfk_1', 'c9mosh', 'clue', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'clue_question', 'PRIMARY KEY'),
('def', 'c9mosh', 'clue_question_ibfk_1', 'c9mosh', 'clue_question', 'FOREIGN KEY'),
('def', 'c9mosh', 'clue_question_ibfk_2', 'c9mosh', 'clue_question', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'clue_type', 'PRIMARY KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'dic', 'PRIMARY KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'dic_question', 'PRIMARY KEY'),
('def', 'c9mosh', 'dic_question_ibfk_1', 'c9mosh', 'dic_question', 'FOREIGN KEY'),
('def', 'c9mosh', 'dic_question_ibfk_2', 'c9mosh', 'dic_question', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'game', 'PRIMARY KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'game_task', 'PRIMARY KEY'),
('def', 'c9mosh', 'game_task_ibfk_1', 'c9mosh', 'game_task', 'FOREIGN KEY'),
('def', 'c9mosh', 'game_task_ibfk_2', 'c9mosh', 'game_task', 'FOREIGN KEY'),
('def', 'c9mosh', 'game_task_ibfk_3', 'c9mosh', 'game_task', 'FOREIGN KEY'),
('def', 'c9mosh', 'login_name', 'c9mosh', 'login', 'UNIQUE'),
('def', 'c9mosh', 'u_id', 'c9mosh', 'login', 'UNIQUE'),
('def', 'c9mosh', 'login_ibfk_1', 'c9mosh', 'login', 'FOREIGN KEY'),
('def', 'c9mosh', 'login_ibfk_2', 'c9mosh', 'login', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'permissions', 'PRIMARY KEY'),
('def', 'c9mosh', 'pk_progress_rule', 'c9mosh', 'progress', 'UNIQUE'),
('def', 'c9mosh', 'progress_ibfk_1', 'c9mosh', 'progress', 'FOREIGN KEY'),
('def', 'c9mosh', 'progress_ibfk_2', 'c9mosh', 'progress', 'FOREIGN KEY'),
('def', 'c9mosh', 'progress_ibfk_3', 'c9mosh', 'progress', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'question_type', 'PRIMARY KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'questions', 'PRIMARY KEY'),
('def', 'c9mosh', 'questions_ibfk_1', 'c9mosh', 'questions', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'responses', 'PRIMARY KEY'),
('def', 'c9mosh', 'pk_response_rule', 'c9mosh', 'responses', 'UNIQUE'),
('def', 'c9mosh', 'responses_ibfk_1', 'c9mosh', 'responses', 'FOREIGN KEY'),
('def', 'c9mosh', 'responses_ibfk_2', 'c9mosh', 'responses', 'FOREIGN KEY'),
('def', 'c9mosh', 'responses_ibfk_3', 'c9mosh', 'responses', 'FOREIGN KEY'),
('def', 'c9mosh', 'responses_ibfk_4', 'c9mosh', 'responses', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'task_dic', 'PRIMARY KEY'),
('def', 'c9mosh', 'task_dic_ibfk_1', 'c9mosh', 'task_dic', 'FOREIGN KEY'),
('def', 'c9mosh', 'task_dic_ibfk_2', 'c9mosh', 'task_dic', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'tasks', 'PRIMARY KEY'),
('def', 'c9mosh', 'secret_id', 'c9mosh', 'tasks', 'UNIQUE'),
('def', 'c9mosh', 'tasks_ibfk_1', 'c9mosh', 'tasks', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'team_game', 'PRIMARY KEY'),
('def', 'c9mosh', 'team_game_ibfk_1', 'c9mosh', 'team_game', 'FOREIGN KEY'),
('def', 'c9mosh', 'team_game_ibfk_2', 'c9mosh', 'team_game', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'team_user', 'PRIMARY KEY'),
('def', 'c9mosh', 'team_user_ibfk_1', 'c9mosh', 'team_user', 'FOREIGN KEY'),
('def', 'c9mosh', 'team_user_ibfk_2', 'c9mosh', 'team_user', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'teams', 'PRIMARY KEY'),
('def', 'c9mosh', 't_name', 'c9mosh', 'teams', 'UNIQUE'),
('def', 'c9mosh', 't_chat_id', 'c9mosh', 'teams', 'UNIQUE'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'user_options', 'PRIMARY KEY'),
('def', 'c9mosh', 'u_id', 'c9mosh', 'user_options', 'UNIQUE'),
('def', 'c9mosh', 'user_options_ibfk_1', 'c9mosh', 'user_options', 'FOREIGN KEY'),
('def', 'c9mosh', 'PRIMARY', 'c9mosh', 'users', 'PRIMARY KEY'),
('def', 'c9mosh', 's_num', 'c9mosh', 'users', 'UNIQUE'),
('def', 'c9mosh', 'u_nickname', 'c9mosh', 'users', 'UNIQUE'),
('def', 'c9mosh', 'u_email', 'c9mosh', 'users', 'UNIQUE');

-- --------------------------------------------------------

--
-- Table structure for table `TABLE_PRIVILEGES`
--

CREATE TEMPORARY TABLE `TABLE_PRIVILEGES` (
  `GRANTEE` varchar(81) NOT NULL DEFAULT '',
  `TABLE_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `TABLE_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `TABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `PRIVILEGE_TYPE` varchar(64) NOT NULL DEFAULT '',
  `IS_GRANTABLE` varchar(3) NOT NULL DEFAULT ''
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `TRIGGERS`
--

CREATE TEMPORARY TABLE `TRIGGERS` (
  `TRIGGER_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `TRIGGER_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `TRIGGER_NAME` varchar(64) NOT NULL DEFAULT '',
  `EVENT_MANIPULATION` varchar(6) NOT NULL DEFAULT '',
  `EVENT_OBJECT_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `EVENT_OBJECT_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `EVENT_OBJECT_TABLE` varchar(64) NOT NULL DEFAULT '',
  `ACTION_ORDER` bigint(4) NOT NULL DEFAULT '0',
  `ACTION_CONDITION` longtext,
  `ACTION_STATEMENT` longtext NOT NULL,
  `ACTION_ORIENTATION` varchar(9) NOT NULL DEFAULT '',
  `ACTION_TIMING` varchar(6) NOT NULL DEFAULT '',
  `ACTION_REFERENCE_OLD_TABLE` varchar(64) DEFAULT NULL,
  `ACTION_REFERENCE_NEW_TABLE` varchar(64) DEFAULT NULL,
  `ACTION_REFERENCE_OLD_ROW` varchar(3) NOT NULL DEFAULT '',
  `ACTION_REFERENCE_NEW_ROW` varchar(3) NOT NULL DEFAULT '',
  `CREATED` datetime DEFAULT NULL,
  `SQL_MODE` varchar(8192) NOT NULL DEFAULT '',
  `DEFINER` varchar(77) NOT NULL DEFAULT '',
  `CHARACTER_SET_CLIENT` varchar(32) NOT NULL DEFAULT '',
  `COLLATION_CONNECTION` varchar(32) NOT NULL DEFAULT '',
  `DATABASE_COLLATION` varchar(32) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `USER_PRIVILEGES`
--

CREATE TEMPORARY TABLE `USER_PRIVILEGES` (
  `GRANTEE` varchar(81) NOT NULL DEFAULT '',
  `TABLE_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `PRIVILEGE_TYPE` varchar(64) NOT NULL DEFAULT '',
  `IS_GRANTABLE` varchar(3) NOT NULL DEFAULT ''
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

--
-- Dumping data for table `USER_PRIVILEGES`
--

INSERT INTO `USER_PRIVILEGES` (`GRANTEE`, `TABLE_CATALOG`, `PRIVILEGE_TYPE`, `IS_GRANTABLE`) VALUES
('''c9mosh''@''localhost''', 'def', 'USAGE', 'NO');

-- --------------------------------------------------------

--
-- Table structure for table `VIEWS`
--

CREATE TEMPORARY TABLE `VIEWS` (
  `TABLE_CATALOG` varchar(512) NOT NULL DEFAULT '',
  `TABLE_SCHEMA` varchar(64) NOT NULL DEFAULT '',
  `TABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `VIEW_DEFINITION` longtext NOT NULL,
  `CHECK_OPTION` varchar(8) NOT NULL DEFAULT '',
  `IS_UPDATABLE` varchar(3) NOT NULL DEFAULT '',
  `DEFINER` varchar(77) NOT NULL DEFAULT '',
  `SECURITY_TYPE` varchar(7) NOT NULL DEFAULT '',
  `CHARACTER_SET_CLIENT` varchar(32) NOT NULL DEFAULT '',
  `COLLATION_CONNECTION` varchar(32) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `INNODB_BUFFER_PAGE`
--

CREATE TEMPORARY TABLE `INNODB_BUFFER_PAGE` (
  `POOL_ID` bigint(21) unsigned NOT NULL DEFAULT '0',
  `BLOCK_ID` bigint(21) unsigned NOT NULL DEFAULT '0',
  `SPACE` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PAGE_NUMBER` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PAGE_TYPE` varchar(64) DEFAULT NULL,
  `FLUSH_TYPE` bigint(21) unsigned NOT NULL DEFAULT '0',
  `FIX_COUNT` bigint(21) unsigned NOT NULL DEFAULT '0',
  `IS_HASHED` varchar(3) DEFAULT NULL,
  `NEWEST_MODIFICATION` bigint(21) unsigned NOT NULL DEFAULT '0',
  `OLDEST_MODIFICATION` bigint(21) unsigned NOT NULL DEFAULT '0',
  `ACCESS_TIME` bigint(21) unsigned NOT NULL DEFAULT '0',
  `TABLE_NAME` varchar(1024) DEFAULT NULL,
  `INDEX_NAME` varchar(1024) DEFAULT NULL,
  `NUMBER_RECORDS` bigint(21) unsigned NOT NULL DEFAULT '0',
  `DATA_SIZE` bigint(21) unsigned NOT NULL DEFAULT '0',
  `COMPRESSED_SIZE` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PAGE_STATE` varchar(64) DEFAULT NULL,
  `IO_FIX` varchar(64) DEFAULT NULL,
  `IS_OLD` varchar(3) DEFAULT NULL,
  `FREE_PAGE_CLOCK` bigint(21) unsigned NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
-- in use (#1227 - Access denied; you need (at least one of) the PROCESS privilege(s) for this operation)

-- --------------------------------------------------------

--
-- Table structure for table `INNODB_TRX`
--

CREATE TEMPORARY TABLE `INNODB_TRX` (
  `trx_id` varchar(18) NOT NULL DEFAULT '',
  `trx_state` varchar(13) NOT NULL DEFAULT '',
  `trx_started` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `trx_requested_lock_id` varchar(81) DEFAULT NULL,
  `trx_wait_started` datetime DEFAULT NULL,
  `trx_weight` bigint(21) unsigned NOT NULL DEFAULT '0',
  `trx_mysql_thread_id` bigint(21) unsigned NOT NULL DEFAULT '0',
  `trx_query` varchar(1024) DEFAULT NULL,
  `trx_operation_state` varchar(64) DEFAULT NULL,
  `trx_tables_in_use` bigint(21) unsigned NOT NULL DEFAULT '0',
  `trx_tables_locked` bigint(21) unsigned NOT NULL DEFAULT '0',
  `trx_lock_structs` bigint(21) unsigned NOT NULL DEFAULT '0',
  `trx_lock_memory_bytes` bigint(21) unsigned NOT NULL DEFAULT '0',
  `trx_rows_locked` bigint(21) unsigned NOT NULL DEFAULT '0',
  `trx_rows_modified` bigint(21) unsigned NOT NULL DEFAULT '0',
  `trx_concurrency_tickets` bigint(21) unsigned NOT NULL DEFAULT '0',
  `trx_isolation_level` varchar(16) NOT NULL DEFAULT '',
  `trx_unique_checks` int(1) NOT NULL DEFAULT '0',
  `trx_foreign_key_checks` int(1) NOT NULL DEFAULT '0',
  `trx_last_foreign_key_error` varchar(256) DEFAULT NULL,
  `trx_adaptive_hash_latched` int(1) NOT NULL DEFAULT '0',
  `trx_adaptive_hash_timeout` bigint(21) unsigned NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
-- in use (#1227 - Access denied; you need (at least one of) the PROCESS privilege(s) for this operation)

-- --------------------------------------------------------

--
-- Table structure for table `INNODB_BUFFER_POOL_STATS`
--

CREATE TEMPORARY TABLE `INNODB_BUFFER_POOL_STATS` (
  `POOL_ID` bigint(21) unsigned NOT NULL DEFAULT '0',
  `POOL_SIZE` bigint(21) unsigned NOT NULL DEFAULT '0',
  `FREE_BUFFERS` bigint(21) unsigned NOT NULL DEFAULT '0',
  `DATABASE_PAGES` bigint(21) unsigned NOT NULL DEFAULT '0',
  `OLD_DATABASE_PAGES` bigint(21) unsigned NOT NULL DEFAULT '0',
  `MODIFIED_DATABASE_PAGES` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PENDING_DECOMPRESS` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PENDING_READS` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PENDING_FLUSH_LRU` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PENDING_FLUSH_LIST` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PAGES_MADE_YOUNG` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PAGES_NOT_MADE_YOUNG` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PAGES_MADE_YOUNG_RATE` double NOT NULL DEFAULT '0',
  `PAGES_MADE_NOT_YOUNG_RATE` double NOT NULL DEFAULT '0',
  `NUMBER_PAGES_READ` bigint(21) unsigned NOT NULL DEFAULT '0',
  `NUMBER_PAGES_CREATED` bigint(21) unsigned NOT NULL DEFAULT '0',
  `NUMBER_PAGES_WRITTEN` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PAGES_READ_RATE` double NOT NULL DEFAULT '0',
  `PAGES_CREATE_RATE` double NOT NULL DEFAULT '0',
  `PAGES_WRITTEN_RATE` double NOT NULL DEFAULT '0',
  `NUMBER_PAGES_GET` bigint(21) unsigned NOT NULL DEFAULT '0',
  `HIT_RATE` bigint(21) unsigned NOT NULL DEFAULT '0',
  `YOUNG_MAKE_PER_THOUSAND_GETS` bigint(21) unsigned NOT NULL DEFAULT '0',
  `NOT_YOUNG_MAKE_PER_THOUSAND_GETS` bigint(21) unsigned NOT NULL DEFAULT '0',
  `NUMBER_PAGES_READ_AHEAD` bigint(21) unsigned NOT NULL DEFAULT '0',
  `NUMBER_READ_AHEAD_EVICTED` bigint(21) unsigned NOT NULL DEFAULT '0',
  `READ_AHEAD_RATE` double NOT NULL DEFAULT '0',
  `READ_AHEAD_EVICTED_RATE` double NOT NULL DEFAULT '0',
  `LRU_IO_TOTAL` bigint(21) unsigned NOT NULL DEFAULT '0',
  `LRU_IO_CURRENT` bigint(21) unsigned NOT NULL DEFAULT '0',
  `UNCOMPRESS_TOTAL` bigint(21) unsigned NOT NULL DEFAULT '0',
  `UNCOMPRESS_CURRENT` bigint(21) unsigned NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
-- in use (#1227 - Access denied; you need (at least one of) the PROCESS privilege(s) for this operation)

-- --------------------------------------------------------

--
-- Table structure for table `INNODB_LOCK_WAITS`
--

CREATE TEMPORARY TABLE `INNODB_LOCK_WAITS` (
  `requesting_trx_id` varchar(18) NOT NULL DEFAULT '',
  `requested_lock_id` varchar(81) NOT NULL DEFAULT '',
  `blocking_trx_id` varchar(18) NOT NULL DEFAULT '',
  `blocking_lock_id` varchar(81) NOT NULL DEFAULT ''
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
-- in use (#1227 - Access denied; you need (at least one of) the PROCESS privilege(s) for this operation)

-- --------------------------------------------------------

--
-- Table structure for table `INNODB_CMPMEM`
--

CREATE TEMPORARY TABLE `INNODB_CMPMEM` (
  `page_size` int(5) NOT NULL DEFAULT '0',
  `buffer_pool_instance` int(11) NOT NULL DEFAULT '0',
  `pages_used` int(11) NOT NULL DEFAULT '0',
  `pages_free` int(11) NOT NULL DEFAULT '0',
  `relocation_ops` bigint(21) NOT NULL DEFAULT '0',
  `relocation_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
-- in use (#1227 - Access denied; you need (at least one of) the PROCESS privilege(s) for this operation)

-- --------------------------------------------------------

--
-- Table structure for table `INNODB_CMP`
--

CREATE TEMPORARY TABLE `INNODB_CMP` (
  `page_size` int(5) NOT NULL DEFAULT '0',
  `compress_ops` int(11) NOT NULL DEFAULT '0',
  `compress_ops_ok` int(11) NOT NULL DEFAULT '0',
  `compress_time` int(11) NOT NULL DEFAULT '0',
  `uncompress_ops` int(11) NOT NULL DEFAULT '0',
  `uncompress_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
-- in use (#1227 - Access denied; you need (at least one of) the PROCESS privilege(s) for this operation)

-- --------------------------------------------------------

--
-- Table structure for table `INNODB_LOCKS`
--

CREATE TEMPORARY TABLE `INNODB_LOCKS` (
  `lock_id` varchar(81) NOT NULL DEFAULT '',
  `lock_trx_id` varchar(18) NOT NULL DEFAULT '',
  `lock_mode` varchar(32) NOT NULL DEFAULT '',
  `lock_type` varchar(32) NOT NULL DEFAULT '',
  `lock_table` varchar(1024) NOT NULL DEFAULT '',
  `lock_index` varchar(1024) DEFAULT NULL,
  `lock_space` bigint(21) unsigned DEFAULT NULL,
  `lock_page` bigint(21) unsigned DEFAULT NULL,
  `lock_rec` bigint(21) unsigned DEFAULT NULL,
  `lock_data` varchar(8192) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
-- in use (#1227 - Access denied; you need (at least one of) the PROCESS privilege(s) for this operation)

-- --------------------------------------------------------

--
-- Table structure for table `INNODB_CMPMEM_RESET`
--

CREATE TEMPORARY TABLE `INNODB_CMPMEM_RESET` (
  `page_size` int(5) NOT NULL DEFAULT '0',
  `buffer_pool_instance` int(11) NOT NULL DEFAULT '0',
  `pages_used` int(11) NOT NULL DEFAULT '0',
  `pages_free` int(11) NOT NULL DEFAULT '0',
  `relocation_ops` bigint(21) NOT NULL DEFAULT '0',
  `relocation_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
-- in use (#1227 - Access denied; you need (at least one of) the PROCESS privilege(s) for this operation)

-- --------------------------------------------------------

--
-- Table structure for table `INNODB_CMP_RESET`
--

CREATE TEMPORARY TABLE `INNODB_CMP_RESET` (
  `page_size` int(5) NOT NULL DEFAULT '0',
  `compress_ops` int(11) NOT NULL DEFAULT '0',
  `compress_ops_ok` int(11) NOT NULL DEFAULT '0',
  `compress_time` int(11) NOT NULL DEFAULT '0',
  `uncompress_ops` int(11) NOT NULL DEFAULT '0',
  `uncompress_time` int(11) NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
-- in use (#1227 - Access denied; you need (at least one of) the PROCESS privilege(s) for this operation)

-- --------------------------------------------------------

--
-- Table structure for table `INNODB_BUFFER_PAGE_LRU`
--

CREATE TEMPORARY TABLE `INNODB_BUFFER_PAGE_LRU` (
  `POOL_ID` bigint(21) unsigned NOT NULL DEFAULT '0',
  `LRU_POSITION` bigint(21) unsigned NOT NULL DEFAULT '0',
  `SPACE` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PAGE_NUMBER` bigint(21) unsigned NOT NULL DEFAULT '0',
  `PAGE_TYPE` varchar(64) DEFAULT NULL,
  `FLUSH_TYPE` bigint(21) unsigned NOT NULL DEFAULT '0',
  `FIX_COUNT` bigint(21) unsigned NOT NULL DEFAULT '0',
  `IS_HASHED` varchar(3) DEFAULT NULL,
  `NEWEST_MODIFICATION` bigint(21) unsigned NOT NULL DEFAULT '0',
  `OLDEST_MODIFICATION` bigint(21) unsigned NOT NULL DEFAULT '0',
  `ACCESS_TIME` bigint(21) unsigned NOT NULL DEFAULT '0',
  `TABLE_NAME` varchar(1024) DEFAULT NULL,
  `INDEX_NAME` varchar(1024) DEFAULT NULL,
  `NUMBER_RECORDS` bigint(21) unsigned NOT NULL DEFAULT '0',
  `DATA_SIZE` bigint(21) unsigned NOT NULL DEFAULT '0',
  `COMPRESSED_SIZE` bigint(21) unsigned NOT NULL DEFAULT '0',
  `COMPRESSED` varchar(3) DEFAULT NULL,
  `IO_FIX` varchar(64) DEFAULT NULL,
  `IS_OLD` varchar(3) DEFAULT NULL,
  `FREE_PAGE_CLOCK` bigint(21) unsigned NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
-- in use (#1227 - Access denied; you need (at least one of) the PROCESS privilege(s) for this operation)
--
-- Database: `test`
--
CREATE DATABASE `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
