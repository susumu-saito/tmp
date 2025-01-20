"
QueryDef(
	Parameters=[
		CustomerID->Integer(Required=true),
		ControllerID->Integer(Required=true),
		From->Date(Required=true, Period="Day", EndOfPeriod=false),
		To->Date(Required=true,Period="Day",EndOfPeriod=true),
		FID1->Integer(_Match="FieldID"),
		FID2->Integer(Required=false,_Match="FieldID"),
		IncludeBeginEnd->Boolean(DESCription="With rows for report begin/end",Required=true,Default=true)
	],
	InlinePars=PARS(CustomerID,ControllerID,FID1,FID2,IncludeBeginEnd),
	Query=def(pars)=>$"

	WITH h AS (
		SELECT
			Time,
			FieldID ,
			FieldValue
		FROM EventsHistory_{pars.ControllerID}
		WHERE FieldID IN (@FID1,@FID2)
			AND FieldValue IS NOT NULL
	),

	h2 AS (
		SELECT @CustomerID AS CustomerID,[Time],
			(CASE WHEN FieldID=@FID1 THEN FieldValue END) AS [F1],
			(CASE WHEN FieldID=@FID2 THEN FieldValue END) AS [F2]
		 FROM h
	),

	h3 AS (
		SELECT
			CustomerID,
			[Time],
			MAX(F1) AS F1,
			MAX(F2) AS F2

		FROM h2
		WHERE [Time] between @From and @To
		GROUP BY CustomerID,[Time]
	)
	,
 h4 AS (
	 SELECT
		 CustomerID,
		 [Time],
		 F1,
		 F2,
		 F1+F2 as F3
		FROM h3
 		WHERE [Time] between @From and @To
 		GROUP BY CustomerID,[Time]
 )
 , starth as (
	select top(1) @CustomerID as CustomerID,@From as [Time],
	(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID1 order by [Time] desc)  as F1,
	(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID2 order by [Time] desc)  as F2,
	(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID3 order by [Time] desc)  as F3
	where @IncludeBeginEnd=1
 )
 , endh as (
	select top(1) @CustomerID as CustomerID,@To as [Time],
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID1 order by [Time] desc)  as F1,
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID2 order by [Time] desc)  as F2,
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID3 order by [Time] desc)  as F3
	where @IncludeBeginEnd=1
 )

 select * from starth
 union
 select * FROM h4
 union
 select * from endh
 order by [Time]

	",

	Process=[
        SELECT(CustomerID,Time,F1,F2,F3)
    ]
)
