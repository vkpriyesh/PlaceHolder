<#
.SYNOPSIS
	Create an Azure AD App Registration
	
.DESCRIPTION
	Create an Azure AD App Registration with HomePage, ReplyURLs and a Key valid for 1 year
	 
.EXAMPLE

	C:\PS> Create-AADApplicationPart1
	
.NOTES
	Author  : Octavie van Haaften (Mavention)
	For 	: Blogpost Creating Azure AD App Registration with PowerShell – Part 1
	Date    : 13-09-2017
	Version	: 1.0
#>

$appName = "MyApplication"
$appURI = "https://myapplication.azurewebsites.net"
$appHomePageUrl = "https://myapplication.octavie.nl"
$appReplyURLs = @($appURI, $appHomePageURL, "https://localhost:12345")

if(!($myApp = Get-AzureADApplication -Filter "DisplayName eq '$($appName)'"  -ErrorAction SilentlyContinue))
{
	$Guid = New-Guid
	$startDate = Get-Date
	
	$PasswordCredential 				= New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordCredential
	$PasswordCredential.StartDate 		= $startDate
	$PasswordCredential.EndDate 		= $startDate.AddYears(1)
	$PasswordCredential.KeyId 			= $Guid
	$PasswordCredential.Value 			= ([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(($Guid))))+"="

	$myApp = New-AzureADApplication -DisplayName $appName -IdentifierUris $appURI -Homepage $appHomePageUrl -ReplyUrls $appReplyURLs -PasswordCredentials $PasswordCredential

	$AppDetailsOutput = "Application Details for the $AADApplicationName application:
=========================================================
Application Name: 	$appName
Application Id:   	$($myApp.AppId)
Secret Key:       	$($PasswordCredential.Value)
"
	Write-Host
	Write-Host $AppDetailsOutput
}
else
{
	Write-Host
	Write-Host -f Yellow Azure AD Application $appName already exists.
}

Write-Host
Write-Host -f Green "Finished"
Write-Host



