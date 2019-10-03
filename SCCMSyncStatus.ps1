<#
===================================================================================
Paessler PRTG Sensor to check SCCM's synchronization status with Microsoft's update catalog
===================================================================================
Author:       Drew Morrigan
Script:       SCCMSyncStatus.ps1
Version:      1.5
Date:         3 Oct 2019
Environment:  Windows Server 2016, SCCM Current Build
Scriptpath:   C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML
Scripttype:   EXE/Script Advanced
#>

$module = (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1)

Import-module $module

$SiteCode = Get-PSDrive -PSProvider CMSITE
pushd "$($SiteCode.Name):\"

$syncResult = get-cmsoftwareupdatesyncstatus

popd

$timestamp = get-date
$timeDiff = $timestamp - $syncResult.lastSuccessfulSyncTime

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
<DecimalMode>All</DecimalMode>
<limitMode>1</limitMode>
<limitMaxError>170</limitMaxError>
<LimitErrorMsg>SCCM has not been able to sync with Microsoft update in 7 days.</LimitErrorMsg>
</result>
"

$xmlOutput = $xmlOutput + "</prtg>"
$xmlOutput