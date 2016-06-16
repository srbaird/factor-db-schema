USE `pData`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `buildFactorTable`()
BEGIN

	DECLARE dsCodeVar VARCHAR(45);
	DECLARE done INT DEFAULT FALSE;



	DECLARE createStmt LONGTEXT;

	DECLARE c1 CURSOR FOR SELECT dsCode FROM pData.rates;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	SET createStmt = "CREATE TABLE factors ("; 
	OPEN c1;

	read_loop: LOOP

		FETCH c1 INTO dsCodeVar;

		IF done THEN
			LEAVE read_loop;
		END IF;

		SET createStmt = CONCAT(createStmt, CONCAT (dsCodeVar, " FLOAT, ") ) ;

	END LOOP;



	SET createStmt = CONCAT(createStmt, "valueDate DATETIME NOT NULL, PRIMARY KEY (valueDate))");

	CLOSE c1;

	DROP table IF EXISTS `factors`;

	SET @s = createStmt; 

	PREPARE createFactorTable FROM @s;

	EXECUTE createFactorTable;

	DEALLOCATE PREPARE createFactorTable;


	/* Populate the table */

	SET @startDate = STR_TO_DATE("01,5,2016","%d,%m,%Y");
	SET @endDate = STR_TO_DATE("30,5,2016","%d,%m,%Y");

	SET done = FALSE;
	OPEN c1;

	read_loop: LOOP

		FETCH c1 INTO dsCodeVar;

		IF done THEN
			LEAVE read_loop;
		END IF;

		/* Generate an INSERT/UPDATE statement for each dsCode */
		SET @s = CONCAT("INSERT INTO factors (valueDate,", dsCodeVar);
		SET @s = CONCAT(@s, ") SELECT t.valueDate, t.value FROM rateValues t WHERE dsCode = ? AND valueDate BETWEEN ? AND ? ON DUPLICATE KEY UPDATE ");
		SET @s = CONCAT(@s,dsCodeVar);
		SET @s = CONCAT(@s, " = t.value");

		SET @dsCode = dsCodeVar;

		PREPARE populateFactorTable FROM @s;

		INSERT INTO sqlLog(createStmt) VALUES (@s);

		EXECUTE populateFactorTable USING @dsCode,  @startDate, @endDate;
		DEALLOCATE PREPARE populateFactorTable;

	END LOOP;

END$$

DELIMITER ;

