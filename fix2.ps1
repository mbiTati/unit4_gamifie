# Inject nav-bar.js on app pages
Get-ChildItem app\*.html | ForEach-Object {
  $c = Get-Content $_.FullName -Raw
  if($c -notmatch 'nav-bar.js'){
    $c = $c.Replace('<script src="prof-bar.js','<script src="nav-bar.js?v=1775260800"></script>
<script src="prof-bar.js')
    Set-Content $_.FullName $c -NoNewline
    Write-Host "NAV: $($_.Name)"
  }
}
# Inject nav-bar.js on jeux pages
Get-ChildItem jeux\*\index.html | ForEach-Object {
  $c = Get-Content $_.FullName -Raw
  if($c -notmatch 'nav-bar.js'){
    $c = $c.Replace('<script src="../../app/prof-bar.js','<script src="../../app/nav-bar.js?v=1775260800"></script>
<script src="../../app/prof-bar.js')
    Set-Content $_.FullName $c -NoNewline
    Write-Host "NAV: $($_.Name)"
  }
}
# exercices-entreprise.html
$f = 'exercices-entreprise.html'
if(Test-Path $f){
  $c = Get-Content $f -Raw
  if($c -notmatch 'nav-bar.js'){
    $c = $c.Replace('<script src="app/prof-bar.js','<script src="app/nav-bar.js?v=1775260800"></script>
<script src="app/prof-bar.js')
    Set-Content $f $c -NoNewline
    Write-Host "NAV: $f"
  }
}
Write-Host "DONE"