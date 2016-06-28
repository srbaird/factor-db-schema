CREATE SCHEMA IF NOT EXISTS `pFactor` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE `pFactor`;


CREATE TABLE IF NOT EXISTS `pFactor`.`factorCodes` (
  `dsCode` VARCHAR(45) NOT NULL,
  `factorTable` VARCHAR(255) NULL,
  `factorValueColumn` VARCHAR(255) NULL,
  PRIMARY KEY (`dsCode`))
ENGINE = InnoDB;

CREATE TABLE `factorGroupTypes` (
  `factorGroupTypeId` int(11) NOT NULL AUTO_INCREMENT,
  `factorGroupTypeDescription` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`factorGroupTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `factorGroupCategories` (
  `factorGroupId` int(11) NOT NULL AUTO_INCREMENT,
  `factorGroupTypeId` int(11) NOT NULL,
  `factorGroupCategoriesCode` varchar(45) NOT NULL,
  `factorGroupCategoriesDescription` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`factorGroupId`),
  KEY `fk_factorGroupType_idx` (`factorGroupTypeId`),
  CONSTRAINT `fk_factorGroupType` FOREIGN KEY (`factorGroupTypeId`) REFERENCES `factorGroupTypes` (`factorGroupTypeId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `factorGroups` (
  `factorGroupId` int(11) NOT NULL,
  `dsCode` varchar(45) NOT NULL,
  PRIMARY KEY (`factorGroupId`),
  CONSTRAINT `fk_factorGroupId` FOREIGN KEY (`factorGroupId`) REFERENCES `factorGroupCategories` (`factorGroupId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

