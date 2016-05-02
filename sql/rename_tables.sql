-- Rename tables script (different to renaming the schema) --

ALTER TABLE `baystation`.`erro_admin` 
RENAME TO  `baystation`.`admin` ;

ALTER TABLE `baystation`.`erro_admin_log` 
RENAME TO  `baystation`.`admin_log` ;

ALTER TABLE `baystation`.`erro_ban` 
RENAME TO  `baystation`.`ban` ;

ALTER TABLE `baystation`.`erro_feedback` 
RENAME TO  `baystation`.`feedback` ;

ALTER TABLE `baystation`.`erro_player` 
RENAME TO  `baystation`.`player` ;

ALTER TABLE `baystation`.`erro_poll_option` 
RENAME TO  `baystation`.`poll_option` ;

ALTER TABLE `baystation`.`erro_poll_question` 
RENAME TO  `baystation`.`poll_question` ;

ALTER TABLE `baystation`.`erro_poll_textreply` 
RENAME TO  `baystation`.`poll_textreply` ;

ALTER TABLE `baystation`.`erro_poll_vote` 
RENAME TO  `baystation`.`poll_vote` ;

-- Drop privacy poll and karma tables --
DROP TABLE `baystation`.`erro_privacy`;
DROP TABLE `baystation`.`karma`;
DROP TABLE `baystation`.`karmatotals`;
