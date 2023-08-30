CREATE TABLE IF NOT EXISTS `erro_admin_tickets` (
  `id` int(11) AUTO_INCREMENT,
  `assignee` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ckey` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('OPEN','CLOSED','SOLVED','TIMED_OUT') COLLATE utf8mb4_unicode_ci NOT NULL,
  `round` varchar(32) COLLATE utf8mb4_unicode_ci,
  `inround_id` int(11),
  `open_date` date,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `erro_connection_log` ADD `server_port` int(5) UNSIGNED NOT NULL AFTER `serverip`;

CREATE TABLE IF NOT EXISTS `ckey_whitelist`
(
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT now() NOT NULL,
  `ckey` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `adminwho` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `port` int(5) UNSIGNED NOT NULL,
  `date_start` datetime DEFAULT now() NOT NULL,
  `date_end` datetime NULL,
  `is_valid` boolean DEFAULT true NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `erro_player` ADD `discord_id` varchar(32) DEFAULT NULL AFTER `staffwarn`;
ALTER TABLE `erro_player` ADD `discord_name` varchar(32) DEFAULT NULL AFTER `discord_id`;

ALTER TABLE `erro_player` ADD `exp` text DEFAULT NULL AFTER `discord_name`;
ALTER TABLE `erro_player` ADD `species_exp` text DEFAULT NULL AFTER `exp`;

CREATE TABLE IF NOT EXISTS `erro_playtime_history` (
  `ckey` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date COLLATE utf8mb4_unicode_ci NOT NULL,
  `time_living` int(32) NOT NULL DEFAULT '0',
  `time_ghost` int(32) NOT NULL DEFAULT '0',
  CONSTRAINT PRIMARY KEY (ckey, date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `budget`
(
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT now() NOT NULL,
  `ckey` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `source` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_start` datetime DEFAULT now() NOT NULL,
  `date_end` datetime DEFAULT (now() + INTERVAL 1 MONTH),
  `is_valid` boolean DEFAULT true NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* EX666 ban table */
ALTER `erro_ban` RENAME TO `ban`;

ALTER TABLE `ban`
  MODIFY COLUMN `serverip` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY COLUMN `bantype` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY COLUMN `reason` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY COLUMN `job` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  MODIFY COLUMN `ckey` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY COLUMN `computerid` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY COLUMN `ip` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY COLUMN `a_ckey` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY COLUMN `a_computerid` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY COLUMN `a_ip` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY COLUMN `who` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY COLUMN `adminwho` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  MODIFY COLUMN `edits` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  MODIFY COLUMN `unbanned` tinyint(1) DEFAULT NULL,
  MODIFY COLUMN `unbanned_datetime` datetime DEFAULT NULL,
  MODIFY COLUMN `unbanned_ckey` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  MODIFY COLUMN `unbanned_computerid` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  MODIFY COLUMN `unbanned_ip` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  ADD INDEX `computerid` (`computerid`),
  ADD INDEX `ip` (`ip`);

ALTER TABLE `ban` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

/* General conversion */
ALTER TABLE `erro_connection_log` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `erro_player` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `library` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `whitelist` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
