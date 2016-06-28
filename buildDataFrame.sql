TRUNCATE TABLE pFactor.factorCodes;

INSERT	pFactor.factorCodes(dsCode, factorTable, factorValueColumn)
SELECT	c.dsCode
,		"pData.currencyValues"
,		"value"
FROM	pData.currencies c;

INSERT	pFactor.factorCodes(dsCode, factorTable, factorValueColumn)
SELECT	c.dsCode
,		"pData.commodityValues"
,		"value"
FROM	pData.commodities c;

INSERT	pFactor.factorCodes(dsCode, factorTable, factorValueColumn)
SELECT	c.dsCode
,		"pData.rateValues"
,		"value"
FROM	pData.rates c
WHERE 	c.dsCode IN (
	SELECT 	v.dsCode
	FROM	pData.rateValues v
	WHERE	v.valueDate BETWEEN STR_TO_DATE("01,1,2016","%d,%m,%Y") AND STR_TO_DATE("31,12,2016","%d,%m,%Y")
	GROUP BY v.dsCode
	HAVING Count(*) > 100
);

SELECT * FROM pFactor.factorCodes;

CALL `pFactor`.`buildFactorTable`();

SELECT * FROM pFactor.factors;





