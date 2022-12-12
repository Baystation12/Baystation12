--
-- Columns to store player experience per each job type and species
--
ALTER TABLE `erro_player` ADD `exp` text DEFAULT NULL AFTER `discord_name`;
ALTER TABLE `erro_player` ADD `species_exp` text DEFAULT NULL AFTER `exp`;

--
-- Table structure for table `playtime_history`
--
CREATE TABLE IF NOT EXISTS `erro_playtime_history` (
  `ckey` VARCHAR(32) NOT NULL,
  `date` DATE NOT NULL,
  `time_living` INT(32) NOT NULL DEFAULT '0',
  `time_ghost` INT(32) NOT NULL DEFAULT '0',
  CONSTRAINT PK_Playtime_History PRIMARY KEY (ckey, date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
