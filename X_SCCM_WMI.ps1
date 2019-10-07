<#
===================================================================================
Paessler PRTG Sensor to check the progress/status of SCCM Software Update deployments.
===================================================================================
Author:       Drew Morrigan
Script:       SCCMSyncStatus.ps1
Version:      2
Date:         3 Oct 2019
Environment:  Windows Server 2016, SCCM Current Build
Scriptpath:   C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML
Scripttype:   EXE/Script Advanced
#>

# I created a better version of this script.  You're free to use/tweak it, but it is deprecated.
# (I know you can do that with entire repositories but I don't think you can with individual files)

$ComputerName = # Enter the name of your SCCM server here

$cutoff = (get-date).addDays(-30)

$xmlOutput = "<prtg>"

$GetDeployments = Get-WmiObject -Namespace "root\sms\site_PSC" -Class SMS_DeploymentSummary -ComputerName $ComputerName | Where-Object {($_.FeatureType -eq "5" ) -AND ($_.CreationTime -ne $null) -AND ($_.converttodatetime($_.creationTime) -gt $cutoff)}

for ($count = 1; $count -le $getDeployments.count; $count++)
{
$unitName = $getDeployments[$count-1].SoftwareName + " " + $getDeployments[$count-1].collectionName
$sCount = $getDeployments[$count-1].numberSuccess
$xmlOutput = $xmlOutput + "<result>
<channel>Deployment $count Success</channel>
<unit>Custom</unit>
<customUnit>$unitName</customUnit>
<value>$sCount</value>
</result>
"
$ipCount = $getDeployments[$count-1].numberInProgress
$xmlOutput = $xmlOutput + "<result>
<channel>Deployment $count In Progress</channel>
<unit>Custom</unit>
<customUnit>$unitName</customUnit>
<value>$ipCount</value>
</result>
"
$eCount = $getDeployments[$count-1].numberErrors
$xmlOutput = $xmlOutput + "<result>
<channel>Deployment $count Errors</channel>
<unit>Custom</unit>
<customUnit>$unitName</customUnit>
<value>$eCount</value>
</result>
"
}

$xmlOutput += "</prtg>"
$xmlOutput
