/*
 * The contents of this file were auto-generated using the export feature of adminer.
 */


CREATE TABLE IF NOT EXISTS `erro_ban` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bantime` datetime NOT NULL,
  `serverip` text NOT NULL,
  `bantype` text NOT NULL,
  `reason` text NOT NULL,
  `job` text DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `rounds` int(11) DEFAULT NULL,
  `expiration_time` datetime NOT NULL,
  `ckey` text NOT NULL,
  `computerid` text NOT NULL DEFAULT '',
  `ip` text NOT NULL DEFAULT '',
  `a_ckey` text NOT NULL,
  `a_computerid` text NOT NULL DEFAULT '',
  `a_ip` text NOT NULL DEFAULT '',
  `who` text NOT NULL,
  `adminwho` text NOT NULL,
  `edits` text DEFAULT NULL,
  `unbanned` int(11) DEFAULT NULL,
  `unbanned_datetime` datetime DEFAULT NULL,
  `unbanned_ckey` text DEFAULT NULL,
  `unbanned_computerid` text DEFAULT NULL,
  `unbanned_ip` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ckey` (`ckey`(768))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


CREATE TABLE IF NOT EXISTS `erro_connection_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime DEFAULT NULL,
  `serverip` text DEFAULT NULL,
  `ckey` text DEFAULT NULL,
  `ip` text DEFAULT NULL,
  `computerid` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ckey` (`ckey`(768))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


CREATE TABLE IF NOT EXISTS `erro_player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` text NOT NULL,
  `firstseen` datetime DEFAULT NULL,
  `lastseen` datetime DEFAULT NULL,
  `ip` text DEFAULT NULL,
  `computerid` text DEFAULT NULL,
  `lastadminrank` text DEFAULT NULL,
  `staffwarn` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ckey` (`ckey`(768)) USING HASH,
  KEY `ckey_2` (`ckey`(768)),
  KEY `ip` (`ip`(768)),
  KEY `computerid` (`computerid`(768))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


CREATE TABLE IF NOT EXISTS `library` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` text DEFAULT NULL,
  `title` text DEFAULT NULL,
  `author` text DEFAULT NULL,
  `content` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `title` (`title`(768)),
  KEY `author` (`author`(768)),
  KEY `category` (`category`(768))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


CREATE TABLE IF NOT EXISTS `whitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` text NOT NULL,
  `race` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ckey` (`ckey`(768)),
  KEY `race` (`race`(768))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
