select a.ProjectNumber, DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), a.t) as t, a.Effort,a.Status, a.DateReplace , b.effortperday from
(Select z.ProjectNumber, z.t, z.created as Effort, 'Open' as Status, 0 as DateReplace from
(select a.ProjectNumber, a.t, sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as completed, sum(a.RunningCreatedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) - sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as created
from
((Select [ProjectNumber], sum(Effort) AS RunningCreatedEffortTotal, 0 as RunningCompletedEffortTotal, CreatedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CreatedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CreatedDate
)

union

(Select [ProjectNumber], 0 AS RunningCreatedEffortTotal, sum(Effort) as RunningCompletedEffortTotal, CompletedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CompletedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CompletedDate
)
) as a) as z

union
Select y.ProjectNumber, y.t, y.completed as Effort, 'Done' as Status, 0 as DateReplace from
(select a.ProjectNumber, a.t, sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as completed, sum(a.RunningCreatedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) - sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as created
from
((Select [ProjectNumber], sum(Effort) AS RunningCreatedEffortTotal, 0 as RunningCompletedEffortTotal, CreatedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CreatedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CreatedDate
)

union

(Select [ProjectNumber], 0 AS RunningCreatedEffortTotal, sum(Effort) as RunningCompletedEffortTotal, CompletedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CompletedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CompletedDate
)
) as a) as y

union

Select x.ProjectNumber, dateadd(minute,1,x.t) as t, x.created as Effort, 'Projected' as Status, 0 as DateReplace from
(select a.ProjectNumber, a.t, sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as completed, sum(a.RunningCreatedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) - sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as created
from
((Select [ProjectNumber], sum(Effort) AS RunningCreatedEffortTotal, 0 as RunningCompletedEffortTotal, CreatedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CreatedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CreatedDate
)


union

(Select [ProjectNumber], 0 AS RunningCreatedEffortTotal, sum(Effort) as RunningCompletedEffortTotal, CompletedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CompletedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CompletedDate
)
) as a) as x
inner join (select ProjectNumber, max(isnull(CompletedDate,CreatedDate)) as MaxDate
from DataVault.[DVT].[SAT_TFSPBI]
where  [CreatedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber
) as d  on x.ProjectNumber = d.ProjectNumber and x.t = d.MaxDate



union

select Distinct [ProjectNumber], GetDate() as t, 0 as Effort, 'Projected' as Status, 1 as DateReplace
from DataVault.[DVT].[SAT_TFSPBI]
where  Effort Is NOT NULL and CurrentRecordFlag = 1

-----NEW

union

Select x.ProjectNumber, dateadd(minute,1,x.t) as t, x.created as Effort, 'Projected2' as Status, 0 as DateReplace from
(select a.ProjectNumber, a.t, sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as completed, sum(a.RunningCreatedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) - sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as created
from
((Select [ProjectNumber], sum(Effort) AS RunningCreatedEffortTotal, 0 as RunningCompletedEffortTotal, CreatedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CreatedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CreatedDate
)


union

(Select [ProjectNumber], 0 AS RunningCreatedEffortTotal, sum(Effort) as RunningCompletedEffortTotal, CompletedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CompletedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CompletedDate
)
) as a) as x
inner join (select ProjectNumber, max(isnull(CompletedDate,CreatedDate)) as MaxDate
from DataVault.[DVT].[SAT_TFSPBI]
where  [CreatedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber
) as d  on x.ProjectNumber = d.ProjectNumber and x.t = d.MaxDate

union

Select x.ProjectNumber, dateadd(minute,1,x.t) as t, x.created as Effort, 'Projected2' as Status, 1 as DateReplace from
(select a.ProjectNumber, a.t, sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as completed, sum(a.RunningCreatedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) - sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as created
from
((Select [ProjectNumber], sum(Effort) AS RunningCreatedEffortTotal, 0 as RunningCompletedEffortTotal, CreatedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CreatedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CreatedDate
)


union

(Select [ProjectNumber], 0 AS RunningCreatedEffortTotal, sum(Effort) as RunningCompletedEffortTotal, CompletedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CompletedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CompletedDate
)
) as a) as x
inner join (select ProjectNumber, max(isnull(CompletedDate,CreatedDate)) as MaxDate
from DataVault.[DVT].[SAT_TFSPBI]
where  [CreatedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber
) as d  on x.ProjectNumber = d.ProjectNumber and x.t = d.MaxDate) as a

left join (select c.ProjectNumber, iif(datediff(day,d.t,c.t) != 0, cast((d.Effort - c.Effort) as decimal(5,2))/cast(datediff(day,d.t,c.t) as decimal(5,2)),0) as effortperday
from
(Select x.ProjectNumber, dateadd(minute,1,x.t) as t, x.completed as Effort, 'Projected' as Status from
(select a.ProjectNumber, a.t, sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as completed, sum(a.RunningCreatedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) - sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as created
from
((Select [ProjectNumber], sum(Effort) AS RunningCreatedEffortTotal, 0 as RunningCompletedEffortTotal, CreatedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CreatedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CreatedDate
)


union

(Select [ProjectNumber], 0 AS RunningCreatedEffortTotal, sum(Effort) as RunningCompletedEffortTotal, CompletedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CompletedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CompletedDate
)
) as a) 

as x
inner join (select a.ProjectNumber, max(a.t) as MaxDate
from (select ProjectNumber, CreatedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where Effort IS NOT NULL and CurrentRecordFlag = 1 and CreatedDate IS NOT NULL

union

select ProjectNumber, CompletedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where Effort IS NOT NULL and CurrentRecordFlag = 1 and CompletedDate IS NOT NULL) as a
where a.t < DATEADD(week,-4,GETDATE())
group by a.ProjectNumber
) as d  on x.ProjectNumber = d.ProjectNumber and x.t = d.MaxDate) as c



inner join

(Select x.ProjectNumber, dateadd(minute,1,x.t) as t, x.completed as Effort, 'Projected' as Status from
(select a.ProjectNumber, a.t, sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as completed, sum(a.RunningCreatedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) - sum(a.RunningCompletedEffortTotal) OVER (partition by a.[ProjectNumber] ORDER BY a.t) as created
from
((Select [ProjectNumber], sum(Effort) AS RunningCreatedEffortTotal, 0 as RunningCompletedEffortTotal, CreatedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CreatedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CreatedDate
)


union

(Select [ProjectNumber], 0 AS RunningCreatedEffortTotal, sum(Effort) as RunningCompletedEffortTotal, CompletedDate as t
from DataVault.[DVT].[SAT_TFSPBI]
where [CompletedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber, CompletedDate
)
) as a) 

as x
inner join (select ProjectNumber, max(isnull(CompletedDate,CreatedDate)) as MaxDate
from DataVault.[DVT].[SAT_TFSPBI]
where [CreatedDate] IS NOT NULL and Effort Is NOT NULL and CurrentRecordFlag = 1
group by ProjectNumber
) as d  on x.ProjectNumber = d.ProjectNumber and x.t = d.MaxDate) as d
on c.ProjectNumber = d.ProjectNumber) as b
on a.ProjectNumber = b.ProjectNumber