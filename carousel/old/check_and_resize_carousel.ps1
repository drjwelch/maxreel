# check_and_resize_carousel.ps1
# Verifies that images in carousel are 300px wide and resizes any that are not using ffmpeg

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
  Write-Output 'ERROR: ffmpeg not found on PATH'
  exit 2
}

$files = Get-ChildItem -Path "carousel\*" -Include *.jpg,*.jpeg,*.png -File
Write-Output ("Found {0} images." -f $files.Count)
$bad = @()
foreach ($f in $files) {
  try {
    $info = & ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$($f.FullName)" 2>$null
    if ($info) {
      $parts = $info -split ','
      $w = [int]$parts[0]
      $h = [int]$parts[1]
      Write-Output ("{0}: {1}x{2}" -f $f.Name, $w, $h)
      if ($w -ne 300) { $bad += $f.FullName }
    } else {
      Write-Output ("Could not probe {0}" -f $f.Name)
    }
  } catch {
    Write-Output ("Could not probe {0}: {1}" -f $f.Name, $_)
  }
}

if ($bad.Count -eq 0) {
  Write-Output 'All images are 300px wide.'
  exit 0
}

Write-Output ("Resizing {0} images to 300px width..." -f $bad.Count)
foreach ($p in $bad) {
  $tmp = "$p.tmp.jpg"
  Write-Output ("Resizing: {0} -> {1}" -f $p, $tmp)
  & ffmpeg -y -i $p -vf scale=300:-1 -q:v 2 $tmp 2>&1
  if (Test-Path $tmp) {
    Move-Item -Force $tmp $p
  } else {
    Write-Output ("Failed to create {0}" -f $tmp)
  }
}

Write-Output 'Resize complete.'

$files = Get-ChildItem -Path "carousel\*" -Include *.jpg,*.jpeg,*.png -File
foreach ($f in $files) {
  $info = & ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$($f.FullName)" 2>$null
  if ($info) {
    $parts = $info -split ','
    $w = $parts[0]
    $h = $parts[1]
    Write-Output ("{0}: {1}x{2}" -f $f.Name, $w, $h)
  } else {
    Write-Output ("Could not probe {0}" -f $f.Name)
  }
}
