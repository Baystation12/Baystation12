SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `baystation` DEFAULT CHARACTER SET latin1 ;
USE `baystation` ;

-- -----------------------------------------------------
-- Table `baystation`.`death`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `baystation`.`death` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `pod` TEXT NOT NULL COMMENT 'Place of death' ,
  `coord` TEXT NOT NULL COMMENT 'X, Y, Z POD' ,
  `tod` DATETIME NOT NULL COMMENT 'Time of death' ,
  `job` TEXT NOT NULL ,
  `special` TEXT NOT NULL ,
  `name` TEXT NOT NULL ,
  `byondkey` TEXT NOT NULL ,
  `laname` TEXT NOT NULL COMMENT 'Last attacker name' ,
  `lakey` TEXT NOT NULL COMMENT 'Last attacker key' ,
  `gender` TEXT NOT NULL ,
  `bruteloss` INT(11) NOT NULL ,
  `brainloss` INT(11) NOT NULL ,
  `fireloss` INT(11) NOT NULL ,
  `oxyloss` INT(11) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = MyISAM
AUTO_INCREMENT = 3409
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `baystation`.`library`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `baystation`.`library` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `author` TEXT NOT NULL ,
  `title` TEXT NOT NULL ,
  `content` LONGTEXT NOT NULL ,
  `category` TEXT NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = MyISAM
AUTO_INCREMENT = 184
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `baystation`.`population`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `baystation`.`population` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `playercount` INT(11) NULL DEFAULT NULL ,
  `admincount` INT(11) NULL DEFAULT NULL ,
  `time` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = MyISAM
AUTO_INCREMENT = 2544
DEFAULT CHARACTER SET = latin1;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
