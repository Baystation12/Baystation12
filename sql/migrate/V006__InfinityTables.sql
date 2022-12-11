--
-- Table structure for table `erro_messages`
--

CREATE TABLE IF NOT EXISTS `erro_messages` (
  `id` int(11) NOT NULL,
  `type` enum('memo','message','message sent','note','watchlist entry') NOT NULL,
  `targetckey` varchar(32) NOT NULL,
  `adminckey` varchar(32) NOT NULL,
  `text` varchar(2048) NOT NULL,
  `timestamp` datetime NOT NULL,
  `server` varchar(32) DEFAULT NULL,
  `secret` tinyint(1) DEFAULT 0,
  `lasteditor` varchar(32) DEFAULT NULL,
  `edits` text,
  PRIMARY KEY (`id`),
  KEY `idx_msg_ckey_time` (`targetckey`,`timestamp`),
  KEY `idx_msg_type_ckeys_time` (`type`,`targetckey`,`adminckey`,`timestamp`),
  KEY `idx_msg_type_ckey_time_odr` (`type`,`targetckey`,`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `online_score`
--

DROP TABLE IF EXISTS `online_score`;
CREATE TABLE `online_score` (
  `ckey` varchar(32),
  `year` int(11) DEFAULT 0,
  `month` int(11) DEFAULT 0,
  `day` int(11) DEFAULT 0,
  `sum` int(11) DEFAULT 0,
  PRIMARY KEY (`ckey`, `year`, `month`, `day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `erro_admin_tickets`
--

DROP TABLE IF EXISTS `erro_admin_tickets`;
CREATE TABLE `erro_admin_tickets` (
  `id` int(11) AUTO_INCREMENT,
  `assignee` text DEFAULT NULL,
  `ckey` varchar(32) NOT NULL,
  `text` text DEFAULT NULL,
  `status` enum('OPEN','CLOSED','SOLVED','TIMED_OUT') NOT NULL,
  `round` varchar(32),
  `inround_id` int(11),
  `open_date` date,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `erro_connection_log`
--
DROP TABLE IF EXISTS `erro_connection_log`;
CREATE TABLE IF NOT EXISTS `erro_connection_log`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`datetime` DATETIME DEFAULT now() NOT NULL,
	`server_ip` VARCHAR(32) NOT NULL,
	`server_port` INT(5) UNSIGNED NOT NULL,
	`ckey` VARCHAR(32) NOT NULL,
	`ip` VARCHAR(32) NOT NULL,
	`computerid` VARCHAR(32) NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `ckey_whitelist`
--
DROP TABLE IF EXISTS `ckey_whitelist`;
CREATE TABLE IF NOT EXISTS `ckey_whitelist`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`date` DATETIME DEFAULT now() NOT NULL,
	`ckey` VARCHAR(32) NOT NULL,
	`adminwho` VARCHAR(32) NOT NULL,
	`port` INT(5) UNSIGNED NOT NULL,
	`date_start` DATETIME DEFAULT now() NOT NULL,
	`date_end` DATETIME NULL,
	`is_valid` BOOLEAN DEFAULT true NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
