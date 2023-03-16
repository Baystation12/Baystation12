CREATE TABLE IF NOT EXISTS `budget`
(
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`date` datetime DEFAULT now() NOT NULL,
	`ckey` varchar(32) NOT NULL,
	`amount` int(10) UNSIGNED NOT NULL,
	`source` varchar(32) NOT NULL,
	`date_start` datetime DEFAULT now() NOT NULL,
	`date_end` datetime DEFAULT (now() + INTERVAL 1 MONTH),
	`is_valid` boolean DEFAULT true NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
