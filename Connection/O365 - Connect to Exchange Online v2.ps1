<#
.SYNOPSIS
Connect to Exchange Online v2 PowerShell.
https://github.com/O365scripts/O365scripts/blob/master/Connection/O365%20-%20Connect%20to%20Exchange%20Online%20v2.ps1
.NOTES
	> The EXO V2 module uses Modern authentication for all cmdlets.
	> You can't use Basic authentication in the EXO V2 module; however, you still need to configure the Basic authentication setting in WinRM.
	> The latest version of PowerShell that's currently supported for the EXO V2 module is PowerShell 5.1.
	> Support for PowerShell 6.0 or later is currently a work in progress and will be released soon.
	> This also implies that EXO PowerShell V2 module won't work in Linux or Mac as of now.
.LINK
https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/exchange-online-powershell-v2/exchange-online-powershell-v2?view=exchange-ps
https://www.powershellgallery.com/packages/exchangeonlinemanagement/
https://docs.microsoft.com/en-us/powershell/module/exchange/connect-exchangeonline?view=exchange-ps
https://docs.microsoft.com/en-us/powershell/module/exchange/disconnect-exchangeonline?view=exchange-ps
#>

<# Connect to EXO v2. #>
#Set-ExecutionPolicy RemoteSigned -Force -Confirm:$false;
#Install-Module ExchangeOnlineManagement -AllowClobber -Force -Confirm:$false;
Import-Module ExchangeOnlineManagement;
$AdminUpn = "";
Connect-ExchangeOnline -UserPrincipalName $AdminUpn;

<# Connect to EXO v2 without MFA. #>
$AdminUpn = ""; $Creds = Get-Credential -UserName $AdminUpn -Message "Login:";
Connect-ExchangeOnline -Credential $Creds;

<# Connect to EXO v2 without MFA and without caching credentials. #>
Connect-ExchangeOnline -Credential (Get-Credential -UserName $AdminUpn -Message "Login:");

<# Connect to EXO v2 and send full debug logs to the Downloads folder. #>
$AdminUpn = ""; $PathLogExo = "$env:USERPROFILE\Downloads\";
Connect-ExchangeOnline -UserPrincipalName $AdminUpn -EnableErrorReporting -LogLevel All -LogDirectoryPath $PathLogExo;

<# Disconnect? #>
$Creds = $null; Disconnect-ExchangeOnline -Confirm:$false;

<# Install EXO v2 module as a non-admin user? #>
Install-Module ExchangeOnlineManagement -Scope CurrentUser -Confirm:$false;

<# Confirm EXO v2 module version(s) installed? #>
Get-Module MicrosoftTeams -ListAvailable | Select Version;

<# Update the EXO v2 module. #>
Update-Module ExchangeOnlineManagement -Force -Confirm:$false;

<# Force Update PSGet? #>
Install-Module PowerShellGet -Force -Confirm:$false;

<# Uninstall EXO v2 module? #>
Uninstall-Module ExchangeOnlineManagement -AllVersions -Force -Confirm:$false -WhatIf;

<# Connect to EXO v2 using a public key certificate. #>
$Tenant = "tenantname"; $AppId = ""; $PathCert = "";
Connect-ExchangeOnline -AppId $AppId -CertificateFilePath $PathCert -Organization "$Tenant.onmicrosoft.com";

<# Connect to EXO v2 using a certificate thumbprint. #>
$Tenant = ""; $AppId = ""; $CertThumb = "";
Connect-ExchangeOnline -AppId $AppId -CertificateThumbprint $CertThumb -Organization "$Tenant.onmicrosoft.com";

<# Connect to EXO v2 using a certificate thumbprint. #>
$Tenant = ""; $AppId = ""; $Cert = "";
Connect-ExchangeOnline -AppId $AppId -Certificate $Cert -Organization "$Tenant.onmicrosoft.com";
