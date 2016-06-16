CREATE SCHEMA IF NOT EXISTS `pFactor` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS `pFactor`.`factorCodes` (
  `dsCode` VARCHAR(45) NOT NULL,
  `factorTable` VARCHAR(255) NULL,
  `factorValueColumn` VARCHAR(255) NULL,
  PRIMARY KEY (`dsCode`))
ENGINE = InnoDB;
