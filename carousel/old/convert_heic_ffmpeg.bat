@echo off
REM convert_heic_ffmpeg.bat
REM Converts all .heic/.HEIC files in the carousel\ folder to 300px-wide JPEGs
REM Requires ffmpeg on PATH

SETLOCAL ENABLEDELAYEDEXPANSION
IF NOT EXIST "carousel\jpg" (
  mkdir "carousel\jpg"
)

echo Converting HEIC files in carousel\ to carousel\jpg\ (300px wide)...

REM process lowercase and uppercase extensions
for %%f in ("carousel\*.heic" "carousel\*.HEIC") do (
  if exist "%%~f" (
    echo Converting: %%~nxf
    ffmpeg -y -i "%%~f" -vf "scale=300:-1" -q:v 2 "carousel\jpg\%%~nf.jpg"
  )
)

echo Done.
ENDLOCAL
