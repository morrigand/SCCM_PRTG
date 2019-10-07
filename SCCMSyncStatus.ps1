<#
===================================================================================
Paessler PRTG Sensor to check SCCM's synchronization status with Microsoft's update catalog
===================================================================================
Author:       Drew Morrigan
Script:       SCCMSyncStatus.ps1
Version:      1.5.1
Date:         7 Oct 2019
Environment:  Windows Server 2016, SCCM Current Build
Scriptpath:   C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML
Scripttype:   EXE/Script Advanced
#>

$ComputerName = # Enter the name of your SCCM server/SUP here
$syncResult = Get-WmiObject -Namespace "root\sms\site_PSC" -Class SMS_SUPSyncStatus -ComputerName $ComputerName

$timestamp = get-date
$syncTime = $syncResult.ConvertToDateTime($syncResult.lastsuccessfulSyncTime)
$timeDiff = $timestamp - $syncTime

$syncCode = $syncResult.lastSyncErrorCode

$xmlOutput = '<?xml version="1.0" encoding="UTF-8" ?><prtg>'
$timeDiff = $timeDiff.totalHours

$xmlOutput = $xmlOutput + "<result>
<channel>Sync Code</channel>
<value>$syncCode</value>
<unit>Absolute</unit>
<limitmode>1</limitmode>
<LimitMaxError>0</LimitMaxError>
<LimitErrorMsg>SCCM Error: Sync with Microsoft Update Catalog failed.  Code: $syncCode</LimitErrorMsg>
</result>
<result>
<channel>Successful Sync Age</channel>
<value>$timeDiff</value>
<unit>TimeHours</unit>
<float>1</float>
<DecimalMode>Auto</DecimalMode>
<limitMode>1</limitMode>
<limitMaxError>170</limitMaxError>
<LimitErrorMsg>SCCM has not been able to sync with Microsoft Update in 7 days.</LimitErrorMsg>
</result>
"

$xmlOutput = $xmlOutput + "</prtg>"
$xmlOutput
