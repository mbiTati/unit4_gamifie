Get-ChildItem app\*.html | ForEach-Object {
  $c = Get-Content $_.FullName -Raw
  if($c -match '`n</body>'){
    $c = $c.Replace('`n</body>',"`n</body>")
    Set-Content $_.FullName $c -NoNewline
    Write-Host "FIXED: $($_.Name)"
  }
}
Get-ChildItem jeux\*\index.html | ForEach-Object {
  $c = Get-Content $_.FullName -Raw
  if($c -match '`n</body>'){
    $c = $c.Replace('`n</body>',"`n</body>")
    Set-Content $_.FullName $c -NoNewline
    Write-Host "FIXED: $($_.Name)"
  }
}
foreach($f in @('app\profile.html','app\docs.html','app\settings.html')){
  $c = Get-Content $f -Raw
  if($c -notmatch 'profile-tabs'){
    $c = $c.Replace('<script src="prof-bar.js','<script src="profile-tabs.js?v=1775260800"></script>
<script src="prof-bar.js')
    Set-Content $f $c -NoNewline
    Write-Host "TABS: $f"
  }
}
Write-Host "DONE"