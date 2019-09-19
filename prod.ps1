


$folder = "confidence.io"
# $folder = "Sentinel.UI.Admin"
$scriptpath = $MyInvocation.MyCommand.Path 
$dir = Split-Path $scriptpath

$angularFolder = Join-Path -Path $dir -ChildPath .\$folder
Set-Location $angularFolder


Remove-Item $dir/dist/prod -Recurse -Force


ng build --prod --aot --output-path $dir/dist/prod --extract-css true


$filelist = @()
$files = Get-ChildItem -Path "$dir/dist/prod" | where { ! $_.PSIsContainer }

$extensions = @(".svg", ".woff", ".woff2", ".ttf")
$staticFiles = @("assets/main.js", "assets/VSS.SDK.min.js")

foreach ($file in $staticFiles) {
    if ($extensions -contains $file.extension) {
        Write-Host $file "is not added"
    }
    else {
        $item = @{
            path        = $file;
            addressable = $true;
        }
        $filelist += $item
    }
}

# Removing svgs which is not allowed in the packages
foreach ($file in $files) {
    if ($extensions -contains $file.extension) {
        Write-Host $file "is not added"
    }
    else {
        # if ($file.extension -ne ".svg") {
        $item = @{
            path        = $file.Name;
            addressable = $true;
        }
        $filelist += $item
    }
}
$filelist


$jobj = Get-Content "$dir\vss-extension.prod.json" -raw | ConvertFrom-Json
$versionArr = $jobj.version.split(".")
$majorNumber = [int]$versionArr[0]
$minorNumber = [int]$versionArr[1]
$buildNumber = [int]$versionArr[2]

"Build Number " + ++$buildNumber
$newVersion = [string]::Format("{0}.{1}.{2}", $majorNumber, $minorNumber, $buildNumber)
$jobj.version = $newVersion
$jobj | ForEach-Object { $_.files = $filelist }
$json = $jobj | ConvertTo-Json -Depth 3
$json | set-content  "$dir\vss-extension.prod.json"
Copy-Item  $dir\vss-extension.prod.json $dir\dist\prod\vss-extension.json
Copy-Item  $dir\extension-icon.png $dir\dist\prod\extension-icon.png

Set-Location $dir\dist\prod
tfx extension publish --publisher mmercan2 --token $env:vstsMarketPublishKey --bypass-validation
move-item *.vsix ../../outputs -force
Set-Location $dir