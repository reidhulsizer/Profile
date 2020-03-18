(Select x.JhaPostingDate, x.CIFNO, u.[Id], y.Email1, y.Email2, y.Deceased
      ,u.[Address]
      ,u.[Birthdate]
      ,u.[CIF]
      ,u.[Email]
      ,u.[Enrolled]
      ,u.[FirstName]
      ,u.[LastName]
      ,u.[PhoneNumber]
      ,u.[XSSN]
      ,u.[UserName]
      ,u.[BrandId]
      ,u.[RegistrationDate]
      ,u.[LastContactDate]
      ,u.[EnrollmentCompleted]
      ,u.[PreloadedUser]
      ,u.[InsightsEnabled]
      ,u.[JHOriginalCustomerDate]
      ,u.[UserType]
      ,u.[UserSubType]
      ,u.[UserState]
      ,u.[HashSSN]
      ,u.[HasSecurityQuestions]
      ,u.[ParentUserId]
      ,u.[AlternateEmail]
      ,u.[SecretWord]
      ,u.[SecretWordHint]
      ,u.[SegmentCode]
      ,u.[Occupation]
      ,u.[Employer]
      ,u.[Gender]
      ,u.[MaritalStatus]
      ,u.[SMSOptIn]
      ,u.[SourceTypeCode]
	  , o.LastOLBLogin , sum(x.Accounts) as Accounts, sum(x.OtherLoanBalance) as OtherLoanBalance, sum(x.CheckingBalance) as CheckingBalance , sum(x.MMBalance) as MMBalance, sum(x.SavingsBalance) as SavingsBalance, sum(x.IRABalance) as IRABalance, sum(x.CDBalance) as CDBalance, y.LastCustomerContact
, sum(x.SavingsFlag) as SavingsFlag, sum(x.CheckingFlag) as CheckingFlag , sum(x.MMFlag) as MMFlag, sum(x.IRAFlag) as IRAFlag, sum(x.CDFlag) as CDFlag, sum(x.OtherLoanFlag) as OtherLoanFlag, min(y.CFBRNN) as CFBRNN, sum(x.RestrictedAccounts) as RestrictedAccounts, sum(x.PrimaryAccounts) as PrimaryAccounts, (SELECT max(JhaPostingDate) from [Archive].[silverlake.jha].[CFACCT]) as MaxPostDate, (SELECT min(JhaPostingDate) from [Archive].[silverlake.jha].[CFACCT]) as MinPostDate
,  sum(x.AutoLoanFlag) as AutoLoanFlag, sum(x.SFRLoanFlag) as SFRLoanFlag, sum(x.SFRLoanBalance) as SFRLoanBalance, sum(x.AutoLoanBalance) as AutoLoanBalance, min(x.LastActiveDate) as CustomerLastActiveDate, sum(x.HRBFlag) as HRBFlag, sum(x.HRBBalance) as HRBBalance,
IIF(sum(x.AutoLoanBalance) + sum(x.SFRLoanBalance) + sum(x.OtherLoanBalance)!= 0,  (((sum(x.OtherLoanBalance) * sum(x.OtherLoanWAR)) + (sum(x.SFRLoanBalance) * sum(x.SFRLoanWAR)) + (sum(x.AutoLoanBalance) * sum(x.AutoLoanWAR)))/ (sum(x.AutoLoanBalance) + sum(x.SFRLoanBalance) + sum(x.OtherLoanBalance))),0) as LNWAR
,IIF(sum(x.CheckingBalance) != 0, IIF(sum(x.CheckingBalance) + sum(x.HRBBalance) + sum(x.MMBalance) + sum(x.SavingsBalance) + sum(x.IRABalance) + sum(x.CDBalance) != 0,  (((sum(x.CheckingBalance) * sum(x.CheckingWAR)) + (sum(x.HRBBalance) * sum(x.HRBWAR)) + (sum(x.SavingsBalance) * sum(x.SavingsWAR)) + (sum(x.CDBalance) * sum(x.CDWAR)) + (sum(x.MMBalance) * sum( CONVERT(decimal(10,5),x.MMWAR))) + (sum(x.IRABalance) * sum(x.IRAWAR)))/ (sum(x.CheckingBalance) + sum(x.HRBBalance) + sum(x.MMBalance) + sum(x.SavingsBalance) + sum(x.IRABalance) + sum(x.CDBalance))),0),0) as DEPWAR
from
(
(SELECT j.JhaPostingDate, j.CIFNO, Count(j.ACCTNO) as Accounts, '0' as OtherLoanBalance, Sum(j.CheckingBalance) as CheckingBalance, Sum(j.SavingsBalance) as SavingsBalance, '0' as IRABalance, '0' as CDBalance
  ,Max(j.SavingsFlag) as SavingsFlag, max(j.CheckingFlag) as CheckingFlag, 0 as IRAFlag, 0 as CDFlag, 0 as OtherLoanFlag, sum(j.RestrictedAccounts) as RestrictedAccounts, sum(j.PrimaryAccounts) as PrimaryAccounts, '0' as SFRLoanBalance, '0' as AutoLoanBalance, 0 as SFRLoanFlag, 0 as AutoLoanFlag, min(j.ActiveDate) as LastActiveDate
   , '0' as OtherLoanWAR,  IIF(SUM(j.CheckingBalance ) != 0, sum(j.CheckingBalance  * j.CheckingRate)/SUM(j.CheckingBalance), 0) as CheckingWAR, IIF(SUM(j.SavingsBalance) != 0, sum(j.SavingsBalance * j.SavingsRate)/SUM(j.SavingsBalance), 0) as SavingsWAR, '0' as IRAWAR, '0' as CDWAR,  '0' as SFRLoanWAR, '0' as AutoLoanWAR, IIF(SUM(j.MMBalance) != 0, sum(j.MMBalance * j.MMRate)/SUM(j.MMBalance), 0) as MMWAR, Sum(j.MMBalance) as MMBalance, max(j.MMFlag) as MMFlag, '0' as HRBWAR, '0' as HRBBalance, 0 as HRBFlag
  From
(SELECT c.CFCIF# as CIFNO, l.ACCTNO as ACCTNO,  l.JhaPostingDate, CASE WHEN l.STATUS = '6' or l.STATUS = '7' THEN 1 else 0 end as RestrictedAccounts, CASE WHEN c.CFCIF# = l.CIFNO THEN 1 else 0 end as PrimaryAccounts, isnull(DLA7,isnull(DLC7,DATOP7)) as ActiveDate
   ,CASE WHEN l.ACTYPE = 'S' THEN l.CBAL else '0' end as SavingsBalance, CASE WHEN l.ACTYPE = 'S' THEN l.RATE else '0' end as SavingsRate,  CASE WHEN l.ACTYPE = 'S' THEN 1 else 0 end as SavingsFlag
   ,CASE WHEN l.ACTYPE = 'D' AND p.P2STMD NOT LIKE '%mm%' AND p.P2STMD NOT LIKE '%money market%' THEN l.CBAL else '0' end as CheckingBalance, CASE WHEN l.ACTYPE = 'D' AND p.P2STMD NOT LIKE '%mm%' AND p.P2STMD NOT LIKE '%money market%' THEN l.RATE else '0' end as CheckingRate,  CASE WHEN l.ACTYPE = 'D' AND p.P2STMD NOT LIKE '%mm%' AND p.P2STMD NOT LIKE '%money market%' THEN 1 else 0 end as CheckingFlag
  ,CASE WHEN l.ACTYPE = 'D' AND (p.P2STMD LIKE '%mm%' OR p.P2STMD LIKE '%money market%') THEN l.CBAL else '0' end as MMBalance, CASE WHEN l.ACTYPE = 'D' AND (p.P2STMD LIKE '%mm%' OR p.P2STMD LIKE '%money market%') THEN l.RATE else '0' end as MMRate,  CASE WHEN l.ACTYPE = 'D' AND (p.P2STMD LIKE '%mm%' OR p.P2STMD LIKE '%money market%') THEN 1 else 0 end as MMFlag
  FROM  [Archive].[silverlake.jha].[CFACCT] as c
INNER JOIN [Archive].[silverlake.jha].[DDMAST] AS l
on c.CFACC# = l.ACCTNO and c.CFATYP = l.ACTYPE and c.[JhaPostingDate] = l.JhaPostingDate 
INNER JOIN
[Archive].[silverlake.jha].[DDPAR2] as p
ON l.SCCODE = p.SCCODE
 WHERE       c.[JhaPostingDate] = (select max(JhaPostingDate) from  [Archive].[silverlake.jha].[CFACCT]) and l.STATUS != '2'  and l.CBAL > 0 and l.JhaPostingDate = (select max(JhaPostingDate) from  [Archive].[silverlake.jha].[CFACCT]) and p.JhaPostingDate = (select max(JhaPostingDate) from [Archive].[silverlake.jha].[DDPAR2]) ) as j 
  GROUP BY j.JhaPostingDate, j.CIFNO)
union
  (SELECT j.JhaPostingDate, j.CIFNO, Count(j.ACCTNO) as Accounts, '0' as OtherLoanBalance, '0' as CheckingBalance, '0' as SavingsBalance, sum(j.IRABalance) as IRABalance, SUM(j.CDBalance) as CDBalance
,0 as SavingsFlag, 0 as CheckingFlag, Max(j.IRAFlag) as IRAFlag, max(j.CDFlag) as CDFlag, 0 as OtherLoanFlag, sum(j.RestrictedAccounts) as RestrictedAccounts, sum(j.PrimaryAccounts) as PrimaryAccounts, '0' as SFRLoanBalance, '0' as AutoLoanBalance, 0 as SFRLoanFlag, 0 as AutoLoanFlag, min(j.ActiveDate) as LastActiveDate
  , '0' as OtherLoanWAR, '0' as CheckingWAR, '0' as SavingsWAR, IIF(SUM(j.IRABalance) != 0, sum(j.IRABalance * j.IRARate)/SUM(j.IRABalance), 0) as IRAWAR,  IIF(SUM(j.CDBalance) != 0, sum(j.CDBalance * j.CDRate)/SUM(j.CDBalance), 0) as CDWAR,  '0' as SFRLoanWAR, '0' as AutoLoanWAR, '0' as MMWAR, '0' as MMBalance, 0 as MMFlag, IIF(SUM(j.HRBBalance) != 0, sum(j.HRBBalance * j.HRBRate)/SUM(j.HRBBalance), 0) as HRBWAR, Sum(j.HRBBalance) as HRBBalance, Max(j.HRBFlag) as HRBFlag
  From
(SELECT c.CFCIF# as CIFNO, l.ACCTNO as ACCTNO,  l.JhaPostingDate, CASE WHEN l.STATUS = '6' or l.STATUS = '7' THEN 1 else 0 end as RestrictedAccounts, CASE WHEN c.CFCIF# = l.CIFNO THEN 1 else 0 end as PrimaryAccounts, isnull(ACTVDT,isnull(CONTDT,ISSDT)) as ActiveDate, isnull(ACTVDT,CONTDT) as ActiveDate2
 ,CASE WHEN l.IRACOD = 'N' THEN l.CBAL else '0' end as CDBalance, CASE WHEN l.IRACOD = 'N' THEN l.RATE else '0' end as CDRate,  CASE WHEN l.IRACOD = 'N' THEN 1 else 0 end as CDFlag
   ,CASE WHEN l.OFFCR = 'HRB' and l.IRACOD = 'Y' THEN l.CBAL else '0' end as HRBBalance, CASE WHEN l.OFFCR = 'HRB' and l.IRACOD = 'Y' THEN l.RATE else '0' end as HRBRate,  CASE WHEN l.OFFCR = 'HRB' and l.IRACOD = 'Y' THEN 1 else 0 end as HRBFlag
  ,CASE WHEN l.IRACOD = 'Y' and  l.OFFCR != 'HRB' THEN l.CBAL else '0' end as IRABalance, CASE WHEN l.IRACOD = 'Y' and  l.OFFCR != 'HRB' THEN l.RATE else '0' end as IRARate,  CASE WHEN l.IRACOD = 'Y' and  l.OFFCR != 'HRB' THEN 1 else 0 end as IRAFlag
  FROM [Archive].[silverlake.jha].[CFACCT] as c
  INNER JOIN [Archive].[silverlake.jha].[CDMAST] as l
  on c.CFACC# = l.ACCTNO and c.CFATYP = l.ACTYPE and c.[JhaPostingDate] = l.JhaPostingDate
 where  c.[JhaPostingDate] = (select max(JhaPostingDate) from  [Archive].[silverlake.jha].[CFACCT]) and l.STATUS != '2'  and l.CBAL > 0 and l.JhaPostingDate = (select max(JhaPostingDate) from  [Archive].[silverlake.jha].[CFACCT])) as j 
  GROUP BY j.JhaPostingDate, j.CIFNO)
  union
  (SELECT j.JhaPostingDate, j.CIFNO, Count(j.ACCTNO) as Accounts, Sum(j.OtherLoanBalance) as OtherLoanBalance, '0' as CheckingBalance, '0' as SavingsBalance, '0' as IRABalance,'0' as CDBalance
  ,0 as SavingsFlag, 0 as CheckingFlag, 0 as IRAFlag, 0 as CDFlag, max(j.OtherLoanFlag) as OtherLoanFlag, sum(j.RestrictedAccounts) as RestrictedAccounts, sum(j.PrimaryAccounts) as PrimaryAccounts, Sum(j.SFRBalance) as SFRLoanBalance, Sum(j.AutoBalance) as AutoLoanBalance, max(j.SFRFlag) as SFRLoanFlag, max(j.AutoFlag) as AutoLoanFlag, min(j.ActiveDate) as LastActiveDate
  , IIF(SUM(j.OtherLoanBalance) != 0, sum(j.OtherLoanBalance * j.OtherLoanRate)/SUM(j.OtherLoanBalance), 0) as OtherLoanWAR, '0' as CheckingWAR, '0' as SavingsWAR, '0' as IRAWAR, '0' as CDWAR,  IIF(SUM(j.SFRBalance) != 0, sum(j.SFRBalance * j.SFRRate)/SUM(j.SFRBalance), 0) as SFRLoanWAR, IIF(SUM(j.AutoBalance) != 0, sum(j.AutoBalance * j.AutoRate)/SUM(j.AutoBalance), 0) as AutoLoanWAR, '0' as MMWAR, '0' as MMBalance, 0 as MMFlag, '0' as HRBWAR, '0' as HRBBalance, 0 as HRBFlag
  From 
(SELECT c.CFCIF# as CIFNO, l.ACCTNO as ACCTNO, l.JhaPostingDate, CASE WHEN DATEDIFF(day,l.NPDT, l.JhaPostingDate) > 180 or l.STATUS = '6' or l.STATUS = '7' THEN 1 else 0 end as RestrictedAccounts, CASE WHEN c.CFCIF# = l.CIFNO THEN 1 else 0 end as PrimaryAccounts, isnull(ACTIV7,ORGDT) as ActiveDate
,CASE WHEN (p.PGRDSC = 'SINGLE FAMILY RES' or p.PGRDSC = 'SINGLE FAMLIY RES') THEN l.CBAL else '0' end as SFRBalance, CASE WHEN (p.PGRDSC = 'SINGLE FAMILY RES' or p.PGRDSC = 'SINGLE FAMLIY RES') THEN l.RATE else '0' end as SFRRate,  CASE WHEN (p.PGRDSC = 'SINGLE FAMILY RES' or p.PGRDSC = 'SINGLE FAMLIY RES') THEN 1 else 0 end as SFRFlag
   ,CASE WHEN p.PGRDSC != 'Auto Ind Loan Fund' and p.PGRDSC != 'RV INDIRECT' and p.PGRDSC != 'AUTO DIRECT' and p.PGRDSC != 'RV/AUTO REO' and p.PGRDSC != 'SINGLE FAMILY RES' and p.PGRDSC != 'SINGLE FAMLIY RES' THEN l.CBAL else '0' end as OtherLoanBalance, CASE WHEN p.PGRDSC != 'Auto Ind Loan Fund' and p.PGRDSC != 'RV INDIRECT' and p.PGRDSC != 'AUTO DIRECT' and p.PGRDSC != 'RV/AUTO REO' and p.PGRDSC != 'SINGLE FAMILY RES' and p.PGRDSC != 'SINGLE FAMLIY RES' THEN l.RATE else '0' end as OtherLoanRate,  CASE WHEN p.PGRDSC != 'Auto Ind Loan Fund' and p.PGRDSC != 'RV INDIRECT' and p.PGRDSC != 'AUTO DIRECT' and p.PGRDSC != 'RV/AUTO REO' and p.PGRDSC != 'SINGLE FAMILY RES' and p.PGRDSC != 'SINGLE FAMLIY RES' THEN 1 else 0 end as OtherLoanFlag
  ,CASE WHEN (p.PGRDSC = 'Auto Ind Loan Fund' or p.PGRDSC = 'RV INDIRECT' or p.PGRDSC = 'AUTO DIRECT' or p.PGRDSC = 'RV/AUTO REO')  THEN l.CBAL else '0' end as AutoBalance, CASE WHEN (p.PGRDSC = 'Auto Ind Loan Fund' or p.PGRDSC = 'RV INDIRECT' or p.PGRDSC = 'AUTO DIRECT' or p.PGRDSC = 'RV/AUTO REO')  THEN l.RATE else '0' end as AutoRate,  CASE WHEN (p.PGRDSC = 'Auto Ind Loan Fund' or p.PGRDSC = 'RV INDIRECT' or p.PGRDSC = 'AUTO DIRECT' or p.PGRDSC = 'RV/AUTO REO')  THEN 1 else 0 end as AutoFlag
  FROM [Archive].[silverlake.jha].[CFACCT] as c
  INNER JOIN [Archive].[silverlake.jha].[LNMAST] as l
  on c.CFACC# = l.ACCTNO and c.CFATYP = l.ACTYPE and c.[JhaPostingDate] = l.JhaPostingDate
   INNER JOIN [Archive].[silverlake.jha].[LNPAR2] as p
  on l.Type = p.PType 
 where  c.[JhaPostingDate] = (select max(JhaPostingDate) from  [Archive].[silverlake.jha].[CFACCT]) and p.JhaPostingDate = (SELECT MAX(JhaPostingDate)
  FROM [Archive].[silverlake.jha].[LNPAR2]) and l.STATUS != '2' and l.CBAL > 0 and l.JhaPostingDate = (select max(JhaPostingDate) from  [Archive].[silverlake.jha].[CFACCT])) as j
  GROUP BY j.JhaPostingDate, j.CIFNO)
  ) as x
  
 inner join 
(SELECT CFCIF#, JhaPostingDate, CFBRNN, CFDLAC7 as LastCustomerContact, CFEML1 as Email1 ,CFEML2 as Email2, CFDEAD as Deceased
FROM [Archive].[silverlake.jha].[CFMAST] 
where JhaPostingDate = (select max(JhaPostingDate) from  [Archive].[silverlake.jha].[CFACCT])) as y
on x.CIFNO = y.CFCIF# and x.JhaPostingDate = y.JhaPostingDate


left join 
[PreVault].[Identity].[UdbUsers] as u
on x.CIFNO = u.CIF

left join
(SELECT u.CIF , max(convert(datetime, a.Timestamp)) as LastOLBLogin
  FROM [PreVault].[olb].[UserActions] as a
  inner join [PreVault].[Identity].[UdbUsers] as u
  on a.UserId = u.Id
  where ((EventId = '5' or EventId = '74' or (EventId = '7' and Success = '1') or EventId = '129' or EventId = '116' or EventId = '130'))
  group by u.CIF) as o
  on x.CIFNO = o.CIF


 GROUP BY x.JhaPostingDate, x.CIFNO,  u.[Id], o.LastOLBLogin, y.Email1, y.Email2, y.Deceased, y.LastCustomerContact
      ,u.[Address]
      ,u.[Birthdate]
      ,u.[CIF]
      ,u.[Email]
      ,u.[Enrolled]
      ,u.[FirstName]
      ,u.[LastName]
      ,u.[PhoneNumber]
      ,u.[XSSN]
      ,u.[UserName]
      ,u.[BrandId]
      ,u.[RegistrationDate]
      ,u.[LastContactDate]
      ,u.[EnrollmentCompleted]
      ,u.[PreloadedUser]
      ,u.[InsightsEnabled]
      ,u.[JHOriginalCustomerDate]
      ,u.[UserType]
      ,u.[UserSubType]
      ,u.[UserState]
      ,u.[HashSSN]
      ,u.[HasSecurityQuestions]
      ,u.[ParentUserId]
      ,u.[AlternateEmail]
      ,u.[SecretWord]
      ,u.[SecretWordHint]
      ,u.[SegmentCode]
      ,u.[Occupation]
      ,u.[Employer]
      ,u.[Gender]
      ,u.[MaritalStatus]
      ,u.[SMSOptIn]
      ,u.[SourceTypeCode])