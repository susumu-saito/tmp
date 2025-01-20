QueryDef(
	Parameters=[CustomerID->Integer(Required=true),
	ControllerID->Integer(Required=true),
	From->Date(Required=true,Period="Day",
	EndOfPeriod=false),To->Date(Required=true,Period="Day",
	EndOfPeriod=true),FID1->Integer(_Match="FieldID"),
	FID2->Integer(Required=false,_Match="FieldID"),
	FID3->Integer(Required=false,_Match="FieldID"),
	FID4->Integer(Required=false,_Match="FieldID"),
	FID5->Integer(Required=false,_Match="FieldID"),
	FID6->Integer(Required=false,_Match="FieldID"),
	FID7->Integer(Required=false,_Match="FieldID"),
	FID8->Integer(Required=false,_Match="FieldID"),
	FID9->Integer(Required=false,_Match="FieldID"),
	FID10->Integer(Required=false,_Match="FieldID"),
	IncludeBeginEnd->Boolean(Description="With rows for report begin/end",Required=true,Default=true)
],
  InlinePars=PARS(CustomerID,ControllerID,FID1,FID2,FID3,FID4,FID5,IncludeBeginEnd),
	Query=def(pars)=>$"

with h as (
	SELECT    Time, FieldID , FieldValue from EventsHistory_{pars.ControllerID}
	WHERE     FieldID IN (@FID1,@FID2,@FID3,@FID4,@FID5,@FID6,@FID7,@FID8,@FID9,@FID10)
		and FieldValue is not null
) ,

h2 as (
	select
		@CustomerID as CustomerID,
		[Time],
		(case when FieldID=@FID1 then FieldValue end) as [F1],
		(case when FieldID=@FID2 then FieldValue end) as [F2],
		(case when FieldID=@FID3 then FieldValue end) as [F3],
		(case when FieldID=@FID4 then FieldValue end) as [F4],
		(case when FieldID=@FID5 then FieldValue end) as [F5],
		(case when FieldID=@FID6 then FieldValue end) as [F6],
		(case when FieldID=@FID7 then FieldValue end) as [F7],
		(case when FieldID=@FID8 then FieldValue end) as [F8],
		(case when FieldID=@FID9 then FieldValue end) as [F9],
		(case when FieldID=@FID10 then FieldValue end) as [F10]
	from h),

h3 as (
	select
		CustomerID,
		[Time],
		MAX(F1) as F1,
		MAX(F2) as F2,
		MAX(F3) as F3,
		MAX(F4) as F4,
		MAX(F5) as F5,
		MAX(F6) as F6,
		MAX(F7) as F7,
		MAX(F8) as F8,
		MAX(F9) as F9,
		MAX(F10) as F10
	from h2
	where [Time] between @From and @To
	group by CustomerID,[Time]
 ) ,

 starth as (
	select top(1) @CustomerID as CustomerID,@From as [Time],
		(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID1 order by [Time] desc)  as F1,
		(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID2 order by [Time] desc)  as F2,
		(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID3 order by [Time] desc)  as F3,
		(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID4 order by [Time] desc)  as F4,
		(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID5 order by [Time] desc)  as F5,
		(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID6 order by [Time] desc)  as F6,
		(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID7 order by [Time] desc)  as F7,
		(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID8 order by [Time] desc)  as F8,
		(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID9 order by [Time] desc)  as F9,
		(select top 1 FieldValue from h where [Time]<=@From and FieldID=@FID10 order by [Time] desc)  as F10
	where @IncludeBeginEnd=1
 )
 , endh as (
	select top(1) @CustomerID as CustomerID,@To as [Time],
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID1 order by [Time] desc)  as F1,
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID2 order by [Time] desc)  as F2,
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID3 order by [Time] desc)  as F3,
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID4 order by [Time] desc)  as F4,
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID5 order by [Time] desc)  as F5,
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID6 order by [Time] desc)  as F6,
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID7 order by [Time] desc)  as F7,
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID8 order by [Time] desc)  as F8,
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID9 order by [Time] desc)  as F9,
	(select top 1 FieldValue from h where [Time]<=@To and FieldID=@FID10 order by [Time] desc)  as F10
	where @IncludeBeginEnd=1
 )

 select * from starth
 union
 select * from h3
 union
 select * from endh
 order by [Time]
 ",
    Process=[
        CALC(FT1=FormatByField(pars.ControllerID,pars.FID1,row.F1),FT2=FormatByField(pars.ControllerID,pars.FID2,row.F2),FT3=FormatByField(pars.ControllerID,pars.FID3,row.F3),FT4=FormatByField(pars.ControllerID,pars.FID4,row.F4),FT5=FormatByField(pars.ControllerID,pars.FID5,row.F5),
	FT6=FormatByField(pars.ControllerID,pars.FID6,row.F6),FT7=FormatByField(pars.ControllerID,pars.FID7,row.F7),FT8=FormatByField(pars.ControllerID,pars.FID8,row.F8),FT9=FormatByField(pars.ControllerID,pars.FID9,row.F9),FT10=FormatByField(pars.ControllerID,pars.FID10,row.F10)
),
        SELECT(CustomerID,Time,F1,FT1,F2,FT2,F3,FT3,F4,FT4,F5,FT5,F6,FT6,F7,FT7,F8,FT8,F9,FT9,F10,FT10)
    ]
)
