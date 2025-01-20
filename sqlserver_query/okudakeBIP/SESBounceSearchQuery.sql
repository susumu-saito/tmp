/****** 
不通メールアドレス検索クエリ
　WHEREでメールアドレスを検索
　削除はApplicationBuilderから行う
******/
SELECT [okudakedb].[dbo].[Customers].[CustomerID]
	  ,[okudakedb].[dbo].[Customers].[Name]
	  ,[FirstName]
      ,[LastName]
      ,[Email]
      , [okudakedb].[dbo].[Contacts].[TimeStamp] as LastUpdate
  FROM [okudakedb].[dbo].[Contacts], [okudakedb].[dbo].[Customers]
  WHERE
   [okudakedb].[dbo].[Customers].CustomerID=[okudakedb].[dbo].[Contacts].CustomerID
   and [okudakedb].[dbo].[Contacts].CustomerID!=''
 　and [okudakedb].[dbo].[Contacts].Email='dummy-okdk-bip@sun-denshi.co.jp'