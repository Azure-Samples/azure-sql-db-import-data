---
page_type: sample
languages:
- tsql
- sql
- json
products:
- azure
- azure-sql-database
- azure-data-factory
- azure-databricks
description: "Samples on how to import data (JSON, CSV, Flat-Files, etc) into Azure SQL"
urlFragment: azure-sql-db-import-data-samples
---

<!-- 
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

# Azure SQL DB Import Data Samples

Samples on how to import data (JSON, CSV, Flat-Files, etc) into Azure SQL

All samples are in the `script` folder. Sample data used for running the samples is in `json` and `csv` folder.

## Pre-Requisites

### Have an Azure SQL database

Make sure you have an database in Azure that you can use for tests. If you are new to Azure SQL and need help in creating a new database, make sure to watch this 5 minutes video:

[Demo: Deploy Azure SQL Database](https://channel9.msdn.com/Series/Azure-SQL-for-Beginners/Demo-Deploy-Azure-SQL-Database-14-of-61)

Remember that speed of import is always tied to the maximum "Log Rate Limits" that the database tier has. More detail on this here in this article: [Raising log rate limits for General Purpose service tier in Azure SQL Database](https://techcommunity.microsoft.com/t5/azure-sql/raising-log-rate-limits-for-general-purpose-service-tier-in/ba-p/1784622). 

Remember that Azure SQL Hyperscale have a 100 MB/Sec limit no matter then number of .vCores: [How much time would it take to bring in X amount of data to Hyperscale](https://docs.microsoft.com/en-us/azure/azure-sql/database/service-tier-hyperscale-frequently-asked-questions-faq#how-much-time-would-it-take-to-bring-in-x-amount-of-data-to-hyperscale)

### Run the setup script

Run the script `00-on-prem-tools-user-setup.sql` in order to have the used `customer` table ready to be used.

The script will also create a demo user that will be used to run the script. Feel free to change user name and password if you wish.

### Configure the .env.ps1 file

Create a `.env.ps1` file in the `script` folder using the provided `.env.ps1.template` file. Make sure to fill the variables with the correct that to access the demo Azure SQL database that you have decided to use.

## Use BCP

BCP (Bulk Copy Program) is of course an option, probably the easiest one and one of the fastest. Make sure to get the latest version from: [bcp Utility](https://docs.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-ver15#download-the-latest-version-of-bcp-utility)

Then, a working sample is available in the `02-import-bcp.ps1` script. 

## Use BULK INSERT or OPENROWSET

If your data is in an Azure Blob Storage, you can import or read the file right from Azure SQL, without the need to use any external tool.

Sample is here: `03-bulkinsert-openrowset.sql`

## Use Write-DbaDbTableData 

If you are a Powershell user, you can use the Write-DbaDbTableData cmdlet made available by the amazing [dbatools](https://docs.dbatools.io/#Write-DbaDbTableData) project.

Sample is available in the `01-import-csv.ps1` script.

## Additional Resources

Of course there are more ways to import (and export) data into Azure SQL. Here's the most common one 

### Azure Data Factory

The easiest option, also with great performances. It [supports a variety of different data sources](https://docs.microsoft.com/en-us/azure/data-factory/supported-file-formats-and-compression-codecs ), not only CSV and JSON, but also Parquet, AVRO, ORC and so on.

The [Copy Data](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-copy-data-tool) tool guides you through the entire process of importing data with an easy-to-follow, wizard-style, interface.

This YouTube video shows the best pratices to load data as fast as possibile in Azure SQL via Azure Data Factory: [Best Practices Using Azure SQL as Sink in ADF](https://www.youtube.com/watch?v=p0CFHMtGVwM&list=PL3EZ3A8mHh0yrJwK_lnz9_J4cimw9ivYD&index=16)

### Apache Spark

Apache Spark is another option if you need more flexibility. It can read from almost any data format, and it can efficiently write data into Azure SQL. Full end-to-end sample on how to import data as fast as possible here: [Fast Data Loading in Azure SQL DB using Azure Databricks](https://github.com/Azure-Samples/azure-sql-db-databricks/tree/main/)

### Azure Synapse

Azure Synapse is another way to read common data formats, like Parquet or sets of CSVs from Azure SQL, using Azure Synapse Serverless SQL Pools as a bridge. Here's a detailed article on how to do that: [Azure SQL can read Azure Data Lake storage files using Synapse SQL external tables](https://devblogs.microsoft.com/azure-sql/read-azure-storage-files-using-synapse-sql-external-tables/)
