# Source .env file
. .\.env.ps1

## Sample file to import
$csv_path = "..\csv\customer.tbl"

## Go!
$dt = Import-Csv -Delimiter "|" -Path $csv_path -Header "C_CUSTKEY", "C_NAME", "C_ADDRESS", "C_NATIONKEY", "C_PHONE", "C_ACCTBAL", "C_MKTSEGMENT", "C_COMMENT"

$sp = ConvertTo-SecureString $db_password -AsPlainText -Force 
$c = New-Object System.Management.Automation.PSCredential ($db_user, $sp) 

Write-DbaDbTableData -SqlInstance $db_server -SqlCredential $c -InputObject $dt -Database $db_database -Table $db_table -Truncate
