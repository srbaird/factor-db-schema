USE `pFactor`;
DROP procedure IF EXISTS `buildDataFrame`;

USE `pFactor`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `buildDataFrame`(dsCode VARCHAR(45), startDate DATETIME, endDate DATETIME)
BEGIN

	DECLARE createStmt LONGTEXT;

	CALL `pFactor`.`buildFactorTable`(startDate, endDate);

	SET createStmt =  "SELECT e.dsCode, e.closePrice, f.* FROM 	pData.equityPrices e LEFT JOIN pFactor.factors f ON (e.valueDate = f.valueDate) ";
	SET createStmt = CONCAT(createStmt, "WHERE 	e.dsCode = ? AND e.valueDate BETWEEN ? AND ?");

	SET @s = createStmt;
	SET @dsCode = dsCode;
	SET @startDate = startDate;
	SET @endDate = endDate;

	PREPARE selectDataFrame FROM @s;

	INSERT INTO sqlLog(createStmt) VALUES (@s);

	EXECUTE selectDataFrame USING @dsCode,  @startDate, @endDate;

	DEALLOCATE PREPARE selectDataFrame;

END$$
DELIMITER ;
