USE `pFactor`;
DROP procedure IF EXISTS `buildFactorTable`;

USE `pFactor`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `buildFactorTable`(startDate DATETIME, endDate DATETIME)
BEGIN

	DECLARE dsCodeVar VARCHAR(45);
	DECLARE factorTableVar VARCHAR(45);
	DECLARE factorValueColumnVar VARCHAR(45);
	DECLARE done INT DEFAULT FALSE;

	DECLARE createStmt LONGTEXT;

	DECLARE c1 CURSOR FOR SELECT c.dsCode, c.factorTable, c.factorValueColumn FROM factorCodes c WHERE c.startDate <= startDate;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	SET createStmt = "CREATE TABLE pFactor.factors ("; 
	OPEN c1;

	read_loop: LOOP

		FETCH c1 INTO dsCodeVar, factorTableVar, factorValueColumnVar;

		IF done THEN
			LEAVE read_loop;
		END IF;

		/* Create a FLOAT column to hold each factor value */
		SET createStmt = CONCAT(createStmt, CONCAT (dsCodeVar, " FLOAT, ") ) ;

	END LOOP;



	SET createStmt = CONCAT(createStmt, "valueDate DATETIME NOT NULL, PRIMARY KEY (valueDate))");

	CLOSE c1;

	DROP table IF EXISTS pFactor.factors;

	SET @s = createStmt; 

	PREPARE createFactorTable FROM @s;

	EXECUTE createFactorTable;

	DEALLOCATE PREPARE createFactorTable;


	/* Populate the table */
	INSERT INTO sqlLog(createStmt) VALUES (CONCAT(CONCAT("From: ", startDate) ,CONCAT(", To: ", endDate)) );

	SET done = FALSE;
	OPEN c1;

	read_loop: LOOP

		FETCH c1 INTO dsCodeVar, factorTableVar, factorValueColumnVar;

		IF done THEN
			LEAVE read_loop;
		END IF;

		/* Generate an INSERT/UPDATE statement for each dsCode */
		SET @s = CONCAT("INSERT INTO factors (valueDate,", dsCodeVar);
		SET @s = CONCAT(@s, ") SELECT t.valueDate, t.");
		SET @s = CONCAT(@s, factorValueColumnVar);
		SET @s = CONCAT(@s, " FROM ");
		SET @s = CONCAT(@s, factorTableVar);
		SET @s = CONCAT(@s, " t WHERE dsCode = ? AND valueDate BETWEEN ? AND ? ON DUPLICATE KEY UPDATE ");
		SET @s = CONCAT(@s,dsCodeVar);
		SET @s = CONCAT(@s, " = t.");
		SET @s = CONCAT(@s, factorValueColumnVar);

		SET @dsCode = dsCodeVar;
		SET @startDate = startDate;
		SET @endDate = endDate;

		PREPARE populateFactorTable FROM @s;

		INSERT INTO sqlLog(createStmt) VALUES (@s);

		EXECUTE populateFactorTable USING @dsCode,  @startDate, @endDate;
		DEALLOCATE PREPARE populateFactorTable;

	END LOOP;

END$$
DELIMITER ;
