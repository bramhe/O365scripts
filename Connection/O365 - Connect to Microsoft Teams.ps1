<#
.SYNOPSIS
Connect to Microsoft Teams PowerShell.
https://github.com/O365scripts/O365scripts/blob/master/Connection/O365%20-%20Connect%20to%20Microsoft%20Teams.ps1
.NOTES
	> The recent Teams module versions contain commands related to both Teams and SFBO and as such, the old New-CsOnlineSession has been deprecated.
	> You will need to specify the -TeamsEnvironmentName when connecting to a GCC High or a DOD tenant (TeamsGCCH or TeamsDOD).
	> Use the -LogFilePath and -LogLevel when reporting bugs.
.LINK
Reference:
https://docs.microsoft.com/en-us/microsoftteams/teams-powershell-install
https://docs.microsoft.com/en-us/powershell/module/teams/connect-microsoftteams?view=teams-ps
https://www.powershellgallery.com/packages/MicrosoftTeams/
#>

<# Connect to Teams. #>
#Set-ExecutionPolicy RemoteSigned -Force -Confirm:$false;
#Install-Module MicrosoftTeams -AllowClobber -Force -Confirm:$false;
Import-Module MicrosoftTeams;
Connect-MicrosoftTeams;

<# Connect to Teams without MFA. #>
$AdminUpn = "";
$Creds = Get-Credential -Message "Login:" -UserName $AdminUpn;
Connect-MicrosoftTeams -Credential $Creds;
#$Creds = $null;

<# Connect to Teams without MFA and without caching credentials. #>
Connect-MicrosoftTeams -Credential (Get-Credential -Message "Login:" -UserName $AdminUpn);

<# Install Teams module without local admin rights. #>
#Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -Confirm:$false;
Install-Module MicrosoftTeams -Scope CurrentUser -AllowClobber -Force -Confirm:$false;

<# Confirm Teams module version(s) installed? #>
Get-Module MicrosoftTeams -ListAvailable | Select Version;

<# Update the Teams module. #>
Update-Module MicrosoftTeams -Force -Confirm:$false;

<# Remove all Teams module versions (restart PS before reinstalling). #>
Uninstall-Module MicrosoftTeams -AllVersions -Force -Confirm:$false;
Install-Module MicrosoftTeams -Force -Confirm:$false;

<# Disconnect session? #>
Disconnect-MicrosoftTeams;
