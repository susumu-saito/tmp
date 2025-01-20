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
			DATEADD(hh, 9, Time) AS T,
			FieldID ,
			FieldValue
		FROM EventsHistory_{pars.ControllerID}
		WHERE FieldID IN (@FID1,@FID2)
			AND FieldValue IS NOT NULL
	),

	h2 AS (
		SELECT @CustomerID AS CustomerID,
			T,
			DATEADD(DAY,DATEDIFF(DAY,0, getdate()),0) as T1,
			DATEADD(DAY,DATEDIFF(DAY,0, getdate()),1) as T2,
			(CASE WHEN FieldID=@FID1 THEN FieldValue END) AS [F1],
			(CASE WHEN FieldID=@FID2 THEN FieldValue END) AS [F2]
		 FROM h
	),

	h3 AS (
		SELECT
			CustomerID,
			T,
			MAX(F1) AS F1,
			MAX(F2) AS F2,
                                    ROUND(MAX(F1) / (MAX(F2)/1000),2,1) as F3

		FROM h2
		where T between T1 and T2
		GROUP BY CustomerID,T
	),
	h4 AS (
		SELECT
			*

		FROM h3
		WHERE F3 IS NOT NULL
	)
	 , starth as (
	select top(1) @CustomerID as CustomerID,@From as [Time],
	(select top 1 FieldValue from h where T<=@From and FieldID=@FID1 order by T desc)  as F1,
	(select top 1 FieldValue from h where T<=@From and FieldID=@FID2 order by T desc)  as F2,
	(select top 1 FieldValue from h where T<=@From order by T desc)  as F3
	where @IncludeBeginEnd=1
 )
	 , endh as (
	select top(1) @CustomerID as CustomerID,@To as [Time],
	(select top 1 FieldValue from h where T<=@To and FieldID=@FID1 order by T desc)  as F1,
	(select top 1 FieldValue from h where T<=@To and FieldID=@FID2 order by T desc)  as F2,
	(select top 1 FieldValue from h where T<=@To order by T desc)  as F3
	where @IncludeBeginEnd=1
 )

	select CustomerID,DATEADD(hh, -9, T) AS Time,F1,F2,F3 from h3
	union
	select CustomerID,DATEADD(hh, -9, T) AS Time,F1,F2,F3 from h4
	order by Time

",

	Process=[
        SELECT(CustomerID,Time,F1,F2,F3)
    ]
)
