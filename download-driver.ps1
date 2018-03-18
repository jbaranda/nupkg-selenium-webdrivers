#input parameters
param (
	[Parameter(Mandatory=$true)][string]$browser,
	[Parameter(Mandatory=$true)][string]$version,
	[Parameter(Mandatory=$false)][string]$bit
)

If ($browser -like 'Chrome') {
	$driverName = "chromedriver.exe"
	If ([string]::IsNullOrEmpty($bit)) {
		$zipName = "chromedriver_win32.zip"
	}
	else {
		$zipName = "chromedriver_win$bit.zip"
	}
	$downloadUrl ="http://chromedriver.storage.googleapis.com/$version/$zipName"
	Write-Host $downloadUrl
} ElseIf ($browser -like 'Firefox') {
	$driverName = "geckodriver.exe"
	If ([string]::IsNullOrEmpty($bit)) {
		$zipName = "geckodriver-v$version-win32.zip"
	}
	else {
		$zipName = "geckodriver-v$version-win$bit.zip"
	}	
	$downloadUrl ="https://github.com/mozilla/geckodriver/releases/download/v$version/$zipName"
	Write-Host $downloadUrl
} ElseIf ($browser -like 'IE') {
	$driverName = "IEDriverServer.exe"
	If ([string]::IsNullOrEmpty($bit)) {
		$zipName = "IEDriverServer_Win32_$version.zip"
	} ElseIf ($bit -like '64') {
		$zipName = "IEDriverServer_x$bit" + "_$version.zip"
	} Else {
		$zipName = "IEDriverServer_Win$bit" + "_$version.zip"
	}
	$versionUrlParam = $version.Substring(0, $version.LastIndexOf('.'))

	$downloadUrl ="http://selenium-release.storage.googleapis.com/$versionUrlParam/$zipName"
	Write-Host $downloadUrl
} ElseIf ($browser -like 'Phantomjs') {
	$driverName = "phantomjs.exe"
	$folderName = "phantomjs-$version-windows"
	$zipName = "$folderName.zip"
	$downloadUrl ="https://bitbucket.org/ariya/phantomjs/downloads/$zipName"
	Write-Host $downloadUrl
} Else {
	Write-Output "Browser=$browser NOT supported... Exiting script..."
	Exit
}


# move current folder to where contains this .ps1 script file.
$scriptDir = Split-Path $MyInvocation.MyCommand.Path
pushd $scriptDir

$currentPath = Convert-Path "."
$zipPath = Join-Path $currentPath $zipName

# download driver .zip file if not exists.
if (-not (Test-Path ".\$zipName")){
	[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    (New-Object Net.WebClient).Downloadfile($downloadurl, $zipPath)
    if (Test-Path ".\$driverName") { del ".\$driverName" }
}

# Decompress .zip file to extract driver .exe file.
if (-not (Test-Path ".\$driverName")) {
    $shell = New-Object -com Shell.Application
    if ($browser -like 'Phantomjs') {
		$zipFile = $shell.NameSpace("$zipPath\$folderName\bin")
	}  Else {
		$zipFile = $shell.NameSpace("$zipPath")
	}

    $zipFile.Items() | `
    where {(Split-Path $_.Path -Leaf) -eq $driverName} | `
    foreach {
        $currentDir = $shell.NameSpace((Convert-Path "."))
        $currentDir.copyhere($_.Path)
    }
    sleep(2)
}

del ".\$zipName"