$folder = "confidence"
# $folder = "Sentinel.UI.Admin"
$scriptpath = $MyInvocation.MyCommand.Path 
$dir = Split-Path $scriptpath

$angularFolder = Join-Path -Path $dir -ChildPath .\$folder
Set-Location $angularFolder

ng build --prod --aot --output-path ./dist/prod --extract-css true


$filelist = @()
$files = Get-ChildItem -Path './dist/prod' | where { ! $_.PSIsContainer }

$extensions = @(".svg", ".woff", ".woff2", ".ttf")
$staticFiles = @("assets/main.js", "assets/VSS.SDK.min.js")
# $staticFiles = @("assets/main.js", "assets/VSS.SDK.min.js", "assets/primeng/themes/bootstrap/theme.css", "assets/primeng/primeng.min.css", "assets/images/logo.png")

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




$jobj = Get-Content '.\src\vss-extension.prod.json' -raw | ConvertFrom-Json
$versionArr = $jobj.version.split(".")
$majorNumber = [int]$versionArr[0]
$minorNumber = [int]$versionArr[1]
$buildNumber = [int]$versionArr[2]

"Build Number " + ++$buildNumber
$newVersion = [string]::Format("{0}.{1}.{2}", $majorNumber, $minorNumber, $buildNumber)

$jobj.version = $newVersion

$jobj | ForEach-Object { 
    $_.files = $filelist
}

$json = $jobj | ConvertTo-Json -Depth 3
$json | set-content  '.\src\vss-extension.prod.json'

Copy-Item  .\src\vss-extension.prod.json .\dist\prod\vss-extension.json

Set-Location .\dist\prod
tfx extension publish --publisher mmercan2 --token $env:vstsMarketPublishKey --bypass-validation
move-item *.vsix ../../outputs -force
Set-Location ../..