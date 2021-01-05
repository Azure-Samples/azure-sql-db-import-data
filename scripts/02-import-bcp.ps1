# Source .env file
. .\.env.ps1

## Sample file to import
$csv_path = "..\csv\customer.tbl"

## BCP tool
$bcp_path = "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\bcp.exe"

## Go!
& $bcp_path $db_table in $csv_path -S $db_server -U $db_user -P $db_password -d $db_database -c -C 65001 -r "|\n" -t "|"
