
--
-- Table structure for table `ckey_whitelist`
--
ALTER TABLE `erro_player` ADD `discord_id` varchar(32) DEFAULT NULL AFTER `staffwarn`;
ALTER TABLE `erro_player` ADD `discord_name` varchar(32) DEFAULT NULL AFTER `discord_id`;
