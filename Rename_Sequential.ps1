#
# Rename-Sequential.ps1
#
# In order to execute this script you may have to run (as Administrator) the command 
#	> Set-ExecutionPolicy RemoteSigned
#
<#
	This script finds all files with a specified ext (default - 'jpg') in the current directory,
	Sorts them on the "Time Created"
	Then renames them with a specified prefix (default - 'current folder name') followed by a sequential 4-digit number (or more if needed)
#>

Param (
	[string]$ext = "jpg",
	[string]$prefix = "",
    [string]$dbg = ""
)

"DBG:[{0}]" -f $dbg
$debug = ($dbg.ToLower() -like "t*" )
"Debug:[{0}]" -f $debug

Write-Verbose ("Starting Rename_Sequential")
Write-Verbose "Usage:  powershell.exe Rename-Sequential [-prefix <string> ] [-ext <string>]"
Write-Verbose "         -prefix defaults to 'Folder Name'"
Write-Verbose "         -ext defaults to 'jpg'"
Write-Verbose "         -dbg : 't*' to show rename commands only"
Write-Verbose ""

$work_place = Get-Location 
Write-Verbose ("In folder [{0}]" -f $work_place)

if ($prefix -eq "") {
	$prefix = $work_place | Split-Path -Leaf
}

$files = Get-ChildItem -Filter ("*.$ext") | sort LastWriteTime
$fmt = "{0}-{1:d4}.{2}"
if($files.Count -gt 9999) { $fmt = $fmt.replace("d4","d6") }

foreach($n in (0..($files.Count-1))) {
    $name = $files[$n].Name
    $newname = ($fmt -f $prefix,($n+1),$ext)
    if( $debug ) 
        { "Rename-Item -Path $name -NewName $newname" }
    else 
        { # Rename-Item -Path $name -NewName $newname 
        }
}

exit