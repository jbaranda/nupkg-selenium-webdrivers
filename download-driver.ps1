#input parameters
param (
	[Parameter(Mandatory=$true)][string]$browser,
	[Parameter(Mandatory=$true)][string]$version
)

If ($browser -like 'Chrome') {
	$driverName = "chromedriver.exe"
	$zipName = "chromedriver_win32.zip"
	$downloadUrl ="http://chromedriver.storage.googleapis.com/$version/$zipName"
} ElseIf ($browser -like 'Firefox') {
	$driverName = "geckodriver.exe"
	$zipName = "geckodriver-v$version-win32.zip"
	$downloadUrl ="https://github.com/mozilla/geckodriver/releases/download/v$version/$zipName"
} ElseIf ($browser -like 'IE') {
	$driverName = "IEDriverServer.exe"
	$zipName = "IEDriverServer_Win32_$version.0.zip"
	$downloadUrl ="http://selenium-release.storage.googleapis.com/$version/$zipName"
} ElseIf ($browser -like 'Phantomjs') {
	$driverName = "phantomjs.exe"
	$folderName = "phantomjs-$version-windows"
	$zipName = "$folderName.zip"
	$downloadUrl ="https://bitbucket.org/ariya/phantomjs/downloads/$zipName"
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