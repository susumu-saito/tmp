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


/****** コントローラーID：206  ******/
SELECT TOP 1000 [FieldID]
      ,[FieldName]
      ,[ControllerClassID]
  FROM [okudakedb].[dbo].[Fields]
  where [ControllerClassID]=206
  AND [FieldName] not like '%-%'
  AND [FieldName] not like '%temp%'
  AND [FieldName] not like '%Status%'
  AND [FieldName] not like '%Module%'
  AND [FieldName] not like '%flag%'
  AND [FieldName] not like '%Signal%'
  AND [FieldName] not like '%Reset%'
  AND [FieldName] not like '%time%'
  AND [FieldName] not like '%Unit%'


  /****** コントローラーID：207  ******/
SELECT TOP 1000 [FieldID]
      ,[FieldName]
      ,[ControllerClassID]
  FROM [okudakedb].[dbo].[Fields]
  where [ControllerClassID]=207
  AND [FieldName] not like '%-%'
  AND [FieldName] not like '%temp%'
  AND [FieldName] not like '%Status%'
  AND [FieldName] not like '%Module%'
  AND [FieldName] not like '%flag%'
  AND [FieldName] not like '%Signal%'
  AND [FieldName] not like '%Reset%'
  AND [FieldName] not like '%time%'
  AND [FieldName] not like '%Unit%'


  /****** コントローラーID：208  ******/
SELECT TOP 1000 [FieldID]
      ,[FieldName]
      ,[ControllerClassID]
  FROM [okudakedb].[dbo].[Fields]
  where [ControllerClassID]=208
  AND [FieldName] not like '%-%'
  AND [FieldName] not like '%temp%'
  AND [FieldName] not like '%Status%'
  AND [FieldName] not like '%Module%'
  AND [FieldName] not like '%flag%'
  AND [FieldName] not like '%Signal%'
  AND [FieldName] not like '%Reset%'
  AND [FieldName] not like '%time%'
  AND [FieldName] not like '%Unit%'


  /****** コントローラーID：209  ******/
SELECT TOP 1000 [FieldID]
      ,[FieldName]
      ,[ControllerClassID]
  FROM [okudakedb].[dbo].[Fields]
  where [ControllerClassID]=209
  AND [FieldName] not like '%-%'
  AND [FieldName] not like '%temp%'
  AND [FieldName] not like '%Status%'
  AND [FieldName] not like '%Module%'
  AND [FieldName] not like '%flag%'
  AND [FieldName] not like '%Signal%'
  AND [FieldName] not like '%Reset%'
  AND [FieldName] not like '%time%'
  AND [FieldName] not like '%Unit%'


  /****** コントローラーID：210  ******/
SELECT TOP 1000 [FieldID]
      ,[FieldName]
      ,[ControllerClassID]
  FROM [okudakedb].[dbo].[Fields]
  where [ControllerClassID]=210
  AND [FieldName] not like '%-%'
  AND [FieldName] not like '%temp%'
  AND [FieldName] not like '%Status%'
  AND [FieldName] not like '%Module%'
  AND [FieldName] not like '%flag%'
  AND [FieldName] not like '%Signal%'
  AND [FieldName] not like '%Reset%'
  AND [FieldName] not like '%time%'
  AND [FieldName] not like '%Unit%'

