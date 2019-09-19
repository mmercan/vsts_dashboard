Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip($zipfile, $outdir) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [System.IO.Compression.ZipFile]::OpenRead($zipfile)
    foreach ($entry in $archive.Entries) {
        $entryTargetFilePath = [System.IO.Path]::Combine($outdir, $entry.FullName)
        $entryDir = [System.IO.Path]::GetDirectoryName($entryTargetFilePath)
        
        #Ensure the directory of the archive entry exists
        if (!(Test-Path $entryDir )) {
            New-Item -ItemType Directory -Path $entryDir | Out-Null 
        }
        #If the entry is not a directory entry, then extract entry
        if (!$entryTargetFilePath.EndsWith("/")) {
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $entryTargetFilePath, $true);
        }
    }
}


$folder = "confidence.io"
$scriptpath = $MyInvocation.MyCommand.Path 
$dir = Split-Path $scriptpath
$angularFolder = Join-Path -Path $dir -ChildPath .\$folder

function ng-new {
    ng new  ClientApp --directory $folder --routing true --style scss
    Set-Location $angularFolder
    # npm install "d3", "@ng-bootstrap/ng-bootstrap", "@swimlane/ngx-charts", "@swimlane/ngx-datatable", "angular-calendar", "angular-tree-component", "angular2-text-mask", "bootstrap@4.0.0", "classlist.js", "d3", "dragula", "intl", "ng-sidebar", "ng2-dragula", "ng2-file-upload" , "ng2-validation", "quill", "resize-observer-polyfill", "screenfull", "spinthatshit", "text-mask-addons", "web-animations-js", "hammerjs", "moment"  --save
    npm install  --save "bootstrap@4.0.0", "hammerjs", "moment"
    npm install --save-dev "@fortawesome/fontawesome-free"
}

function Unzip-sources {
    Unzip "$dir\assets.zip" "$angularFolder\src\assets"
}

function fix-index {
 
    $fileName = "$angularFolder\src\index.html"
    $indexcontent = @'
<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>confidence.io</title>
  <link rel="icon" type="image/x-icon" href="favicon.ico">
  <script src="assets/all.min.js"></script>
  <script src="assets/VSS.SDK.min.js" type="text/javascript"></script>
  <script src="assets/main.js"></script>
</head>

<body>
  <app-root></app-root>
</body>


</html>
'@

    $indexcontent | set-content  "$fileName"
}

Unzip-sources
fix-index