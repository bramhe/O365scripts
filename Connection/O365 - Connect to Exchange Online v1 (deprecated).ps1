<#
.SYNOPSIS
Connect to Exchange Online using Basic Authentication
https://github.com/O365scripts/O365scripts/blob/master/Connection/O365%20-%20Connect%20to%20Exchange%20Online%20v1%20(deprecated).ps1
.NOTES
	> Choose the appropriate connection script depending on if multi-factor authentication was enabled on the admin. Preferably, it should be!
	> Limitations:
		+ To help prevent denial-of-service (DoS) attacks, you're limited to three open remote PowerShell connections to your Exchange Online organization.
		+ TCP port 80 traffic needs to be open between your local computer and Office 365.
		+ It's probably open, but it's something to consider if your organization has a restrictive Internet access policy.
	+ When using MFA:
		+ Normally you would have to go inside the EAC in the Hybrid section to get the EXO MFA module but you can simply open this link in IE instead:
			https://cmdletpswmodule.blob.core.windows.net/exopsmodule/Microsoft.Online.CSE.PSModule.Client.application
		+ Once the MFA module is installed, a new icon should appear on your desktop.
		+ This module also adds the functionallity of connecting to Security & Compliance (v1) using MFA.
	> Troubleshooting MFA:
		+ Windows Remote Management (WinRM) on your computer needs to allow Basic authentication (it's enabled by default).
		+ The Basic authentication header is required to transport the session's OAuth token, since the client-side WinRM implementation has no support for OAuth.
			https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/mfa-connect-to-exchange-online-powershell?view=exchange-ps
.LINK
Reference:
https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/connect-to-exchange-online-powershell?view=exchange-ps
https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/mfa-connect-to-exchange-online-powershell?view=exchange-ps
https://o365reports.com/2019/04/17/connect-exchange-online-using-mfa/
https://cmdletpswmodule.blob.core.windows.net/exopsmodule/Microsoft.Online.CSE.PSModule.Client.application
#>

<# Connect to EXO v1. #>
$AdminUpn = "admin@tenantname.onmicrosoft.com";
$Creds = Get-Credential -UserName $AdminUpn -Message "Login:";
$SessionExo = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid" -Credential $Creds -Authentication Basic -AllowRedirection -SessionOption (New-PSSessionOption -IdleTimeoutMSec (30*60000));
Import-PSSession $SessionExo;

<# Disconnect all sessions? #>
$Creds = $null; Get-PSSession | Remove-PSSession;

<# Load EXO MFA module from expected path within ISE or VSCode instead of the basic EXO MFA shell (adjust path accordingly). #>
$PathEXOMFA = "$env:LOCALAPPDATA\Apps\2.0\V65560L8.V1N\H4JNE5GW.V5Z\micr..tion_45baf49ae30bdb15_0010.0000_9957e8953b5cb903";
. "$PathEXOMFA\CreateExoPSSession.ps1";

<# Connect to EXO MFA #>
$AdminUpn = ""; Connect-EXOPSSession -UserPrincipalName $AdminUpn;

# Is WinRM basic auth enabled?
winrm get winrm/config/client/auth

# If basic auth is disabled run this to enable it.
winrm set winrm/config/client/auth @{Basic="true"}

<# Download and install EXO MFA v1 module. #>
$IE = New-Object -com InternetExplorer.Application;
$IE.Navigate2("https://cmdletpswmodule.blob.core.windows.net/exopsmodule/Microsoft.Online.CSE.PSModule.Client.application");
$IE.Visible=$true;
