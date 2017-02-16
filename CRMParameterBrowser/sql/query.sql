--SELECT DISTINCT 'InputParameter', REPLACE(mreq.Name, '{Entity.PrimaryEntityName}', ''), mrf.Name, mrf.ClrParser, ISNULL(mreq.PrimaryObjectTypeCode, 0)
--FROM SdkMessageRequestField mrf
--INNER JOIN SdkMessageRequest mreq ON mrf.SdkMessageRequestId = mreq.SdkMessageRequestId
--WHERE NOT mrf.ClrParser LIKE '%Microsoft.Crm.Sdk%'
--AND NOT mrf.ClrParser LIKE '%Microsoft.Crm.Sdk.Reserved%'
----ORDER BY 1, 2, 4 DESC
--UNION ALL
--SELECT DISTINCT 'OutputParameter', REPLACE(mreq.Name, '{Entity.PrimaryEntityName}', ''), mrf.Value, mrf.ClrFormatter, ISNULL(mreq.PrimaryObjectTypeCode, 0)
--FROM SdkMessageResponseField mrf
--INNER JOIN SdkMessageResponse mres ON mrf.SdkMessageResponseId = mres.SdkMessageResponseId
--INNER JOIN SdkMessageRequest mreq ON mres.SdkMessageRequestId = mreq.SdkMessageRequestId
--WHERE NOT mrf.ClrFormatter LIKE '%Microsoft.Crm.Sdk%'
--AND NOT mrf.ClrFormatter LIKE '%Microsoft.Crm.Sdk.Reserved%'
--ORDER BY 2,1



SELECT DISTINCT
	'InputParameter',
	REPLACE(mreq.Name, '{Entity.PrimaryEntityName}', ''), 
	mrf.Name, 
	CASE 
		WHEN CHARINDEX(',', mrf.ClrParser) > 0 THEN SUBSTRING(mrf.ClrParser, 1, CHARINDEX(',', mrf.ClrParser) - 1)
		ELSE mrf.ClrParser
	END,
	CASE
		WHEN mrf.Optional is null THEN 1
		ELSE 0
	END as Required
FROM SdkMessageRequestField mrf
INNER JOIN SdkMessageRequest mreq ON mrf.SdkMessageRequestId = mreq.SdkMessageRequestId
WHERE NOT mrf.ClrParser LIKE '%Microsoft.Crm.Sdk%'
AND NOT mrf.ClrParser LIKE '%Microsoft.Crm.Sdk.Reserved%'
UNION ALL
SELECT DISTINCT 
	'OutputParameter', 
	REPLACE(mreq.Name, '{Entity.PrimaryEntityName}', ''), 
	mrf.Value, 
	CASE 
		WHEN CHARINDEX(',', mrf.ClrFormatter) > 0 THEN SUBSTRING(mrf.ClrFormatter, 1, CHARINDEX(',', mrf.ClrFormatter) - 1)
		ELSE mrf.ClrFormatter
	END,
	0
FROM SdkMessageResponseField mrf
INNER JOIN SdkMessageResponse mres ON mrf.SdkMessageResponseId = mres.SdkMessageResponseId
INNER JOIN SdkMessageRequest mreq ON mres.SdkMessageRequestId = mreq.SdkMessageRequestId
WHERE NOT mrf.ClrFormatter LIKE '%Microsoft.Crm.Sdk%'
AND NOT mrf.ClrFormatter LIKE '%Microsoft.Crm.Sdk.Reserved%'
ORDER BY 2,1 DESC