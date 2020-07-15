with cte as(
select UserId, 
ROW_NUMBER() over(partition by UserId order by case when b.Name <> 'CreateScheduledTransfer' or convert(date,f.Value) < '1754-08-24' then convert(datetime,Timestamp) else convert(datetime,f.Value)  end) as rank,
 Name, a.Id, case when b.Name <> 'CreateScheduledTransfer' or convert(date,f.Value) < '1754-08-24' then convert(datetime,Timestamp) else convert(datetime,f.Value) end as t
 , try_convert(money,f2.Value) as Amount
 FROM [PreVault].[olb].[UserActions] as a
 inner join [PreVault].[olb].[UserActionEvents] as b
  on a.EventId = b.Id
  left join [PreVault].[olb].[UserActionFields] as f
  on a.Id = f.UserActionId  and  FieldName = 'BeginSendingOn' and b.Name = 'CreateScheduledTransfer'
  inner join [PreVault].[olb].[UserActionFields] as f2
  on a.Id = f2.UserActionId and (f2.FieldName = 'Amount'  or f2.FieldName = 'Amount:') and case when f2.FieldName in ('Amount','Amount:') then  try_convert(money,f2.Value) else NULL end  >= 1 
  where Timestamp > '2018-09-01'  and a.Success = 1 and ( b.Name = 'CreateScheduledTransfer' or b.Name = 'RemoteDeposit' or b.Name = 'PostWireTransfer')
 )

 select *
INTO #MyTempTable
 from cte 
 where rank =1