/****** コントローラーID  ******/
SELECT TOP 1000 [ControllerID]
      ,[ControllerName]
      ,[ControllerClassID]
      ,[UnitID]
	  ,[Description]
      ,[CustomerID]
  FROM [okudakedb].[dbo].[Controllers]
  where [CustomerID]=100
  AND [ControllerName] not like '%vmodbus%'


/****** コントローラーID  ******/
SELECT TOP 1000 [FieldID]
      ,[FieldName]
      ,[ControllerClassID]
  FROM [okudakedb].[dbo].[Fields]
  where [ControllerClassID]>=206
  AND [ControllerClassID]<=210
  AND [FieldName] not like '%-%'
  AND [FieldName] not like '%temp%'
  AND [FieldName] not like '%Status%'
  AND [FieldName] not like '%Module%'
  AND [FieldName] not like '%flag%'
  AND [FieldName] not like '%Signal%'
  AND [FieldName] not like '%Reset%'
  AND [FieldName] not like '%time%'
  AND [FieldName] not like '%Unit%'
  ORDER BY [ControllerClassID] ASC

