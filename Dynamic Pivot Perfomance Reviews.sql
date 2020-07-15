DECLARE 
 @columns NVARCHAR(MAX) = ''
 ,@SQL NVARCHAR(MAX) = ''
 

    SELECT @columns += QUOTENAME(ReviewIndex)   + ',' 
  FROM (select DISTINCT sum(1) over (Partition by Employee_Number ORDER BY Manager_Due_Date) as ReviewIndex
 from
[PreVault].[K2_Prod].[Performance_Reviews]
where Status = 'Review Complete')  x
 SET @columns = LEFT(@columns, LEN(@columns)-1)
 SET @SQL = 
 
'SELECT * FROM
(
select Employee_Number, sum(1) over (Partition by Employee_Number ORDER BY Manager_Due_Date) as ReviewIndex , Manager_Rating
from  
[PreVault].[K2_Prod].[Performance_Reviews]
where Status = ''Review Complete''
) AS BaseData
 
PIVOT (
    MAX(Manager_Rating)
    FOR ReviewIndex 
    IN (' 
    + @columns +
         ') 
         )
         AS PivotTable'

PRINT @sql;
EXEC sp_executesql @sql
