# Archives and Deletes your iZotope RX Audio Editor's operation history.
# Usage: ./RX-CashRemover.ps1 
# Required: ExecutionPolicy of PowerShell < RemoteSigned or Bypass >

$HISTORY_DIR = "~\AppData\Roaming\iZotope\RX 10 Audio Editor Session Data" # Specify your Session Backup Folder (RX Audio Editor's Toolber > Edit > Preference > Misc > Session data folder)
$ARCHIVE_DIR = "~\Documents\RX_HistoryArchives" # Specify destination of archive folder
$DATE = (Get-Date -Format yyMMdd_hhmm)

if (!(Test-Path -Path $HISTORY_DIR)) {
    Write-Error "'$($HISTORY_DIR)' is Not Found."
    exit(1)
}

if (!(Test-Path -Path $ARCHIVE_DIR)) {
    mkdir -Path $ARCHIVE_DIR
    if ($?) {
        Write-Host "'$($ARCHIVE_DIR)' Created."
    }
    else {
        Write-Error "Can't Created '$($ARCHIVE_DIR)', exit this script now."
        exit(1)
    }
}

Compress-Archive -Path $HISTORY_DIR/* -DestinationPath "$($ARCHIVE_DIR)/$($DATE)_RX-History.zip"
if (!$?) {
    Write-Error "Can't Archive $($ARCHIVE_DIR), exit this script now"
    Write-Output $Error[0] > $ARCHIVE_DIR/error.log
    exit(1)
}

Remove-Item -Path $HISTORY_DIR/* -Recurse -Force
if (!$?) {
    Write-Error "Can't Delete $($HISTORY_DIR), exit this script now."
    Write-Output $Error[0] > $ARCHIVE_DIR/error.log
    exit(1)
}
else {
    Write-Host "Script has done."
}

exit(0)