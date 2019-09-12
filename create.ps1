$folder = "confidence"
# $folder = "Sentinel.UI.Admin"
$scriptpath = $MyInvocation.MyCommand.Path 
$dir = Split-Path $scriptpath

$angularFolder = Join-Path -Path $dir -ChildPath .\$folder

# ng new  ClientApp --directory $folder --routing true --style scss

Set-Location $angularFolder


# npm install "d3", "@ng-bootstrap/ng-bootstrap", "@swimlane/ngx-charts", "@swimlane/ngx-datatable", "angular-calendar", "angular-tree-component", "angular2-text-mask", "bootstrap@4.0.0", "classlist.js", "d3", "dragula", "intl", "ng-sidebar", "ng2-dragula", "ng2-file-upload" , "ng2-validation", "quill", "resize-observer-polyfill", "screenfull", "spinthatshit", "text-mask-addons", "web-animations-js", "hammerjs", "moment"  --save
npm install  --save "bootstrap@4.0.0", "hammerjs", "moment"
npm install --save-dev "@fortawesome/fontawesome-free"