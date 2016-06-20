
ALTER TABLE `pFactor`.`factorCodes` 
ADD COLUMN `startDate` DATETIME NOT NULL DEFAULT 0 AFTER `factorValueColumn`;

UPDATE	pFactor.factorCodes f, (SELECT	dsCode, Min(valueDate) valueDate FROM pData.commodityValues GROUP BY dsCode) v
SET		f.startDate = v.valueDate
WHERE	f.dsCode = v.dsCode
AND		f.factorTable = "pData.commodityValues";
