CREATE TABLE IF NOT EXISTS `branch_whitelist` (
  `id` int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `ckey` text NOT NULL,
  `branch` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
