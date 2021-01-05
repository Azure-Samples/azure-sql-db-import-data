/*
	SETUP
*/

/*
drop database scoped credential [dmstore1_misc]
go
drop external data source [dmstore1_misc]
go
*/

select * from sys.[database_scoped_credentials]
go
select * from sys.[external_data_sources]
go

create master key encryption by password = 'My-L0ng&Str0ng_P4ss0wrd!';
go

-- Store the SAS Token (WITHOUT leadeing "?")
-- It can be easily generated using Azure Storage Explorer or AZ CLI or Powershell or Portal
create database scoped credential [dmstore1_misc]
with identity = 'SHARED ACCESS SIGNATURE',
secret = 'sv=2019-12-12&st=2021-01-04T20%3A56%3A47Z&se=2021-01-05T20%3A56%3A47Z&sr=c&sp=rl&sig=b5N5RrJJm44A7gbvQVfmAwiu3Gvt2Umv6RX3bmcy%2B1U%3D';
go

-- Create the data source
create external data source [dmstore1_misc]
with 
( 
	type = blob_storage,
 	location = 'https://dmstore1.blob.core.windows.net/misc',
 	credential= [dmstore1_misc]
);
go

/*
	--- JSON Files ---
*/

-- Read the JSON file
-- CANNOT use widcards 
select 
	cast(bulkcolumn as nvarchar(max)) as jsondata 
from 
	openrowset(bulk 'import-demo/user1.json', data_source = 'dmstore1_misc', single_clob) as azureblob
go

-- Read and access the content of the JSON file
with cte as 
(
	select 
		cast(bulkcolumn as nvarchar(max)) as jsondata 
	from 
		openrowset(bulk 'import-demo/user1.json', data_source = 'dmstore1_misc', single_clob) as azureblob
)
select
	j.*
from
	cte
cross apply 
	openjson(cte.jsondata) j
go

-- What if source is a list of json rows?
with cte as
(
select 
	cast(bulkcolumn as nvarchar(max)) as jsondata 
from 
	openrowset(bulk 'import-demo/users.json', data_source = 'dmstore1_misc', single_clob) as azureblob
)
select
	s.[value] as jsonrow
from
	cte c
cross apply
	string_split(c.jsondata, char(10)) s
where
	replace(s.[value], char(13), '') <> ''
go

/*
	--- CSV / Flat Files ---
*/
-- Create target table
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

-- Import data
-- Data types will be inferred from table schema
bulk insert dbo.[CUSTOMER]
from 'import-demo/customer.tbl' 
with (
	data_source = 'dmstore1_misc',
	codepage = '65001',
	fieldterminator = '|',
	rowterminator = '|\n'
)
go

-- Check imported data
select top (100) * from [dbo].[customer]
go

-- Query data without importing
-- A formatfile is neede to provide required schema
select 
	*
from 
	openrowset(bulk 'import-demo/customer.tbl', 
		data_source = 'dmstore1_misc', 
		codepage = '65001',
		formatfile = 'import-demo/customer.fmt', 
		formatfile_data_source = 'dmstore1_misc'
	) as azureblob
go
