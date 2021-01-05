/*
ON MASTER (needed for DBATools Demo)
*/

--Create Login
create login [demouser] with password = 'Demo_USer-Str0ngPassw0rd!'
go

-- Create User
create user [demouser] from login [demouser]
go

/*
ON TARGET DATABASE
*/

-- Create user
create user [demouser] from login [demouser]
go
alter role [db_owner] add member [demouser]
go

-- Create Table
drop table if exists [dbo].[customer];
create table [dbo].[customer]
(
	[C_CUSTKEY] [int] not null,
	[C_NAME] [varchar](25) not null,
	[C_ADDRESS] [varchar](40) not null,
	[C_NATIONKEY] [int] not null,
	[C_PHONE] [char](15) not null,
	[C_ACCTBAL] [decimal](15, 2) not null,
	[C_MKTSEGMENT] [char](10) not null,
	[C_COMMENT] [varchar](117) not null
)
go