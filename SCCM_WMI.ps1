$ComputerName="stargazer"

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