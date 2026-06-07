@echo off
setlocal
cd /d "%~dp0"

echo ========================================================
echo  Force commit and push (clears stale .git/index.lock)
echo ========================================================
echo.

REM Remove the stale lock first
if exist ".git\index.lock" (
  echo Removing stale .git\index.lock...
  del /F /Q ".git\index.lock"
)

echo.
echo === git status ===
git status --short
echo.

echo === Staging ===
git add .

echo.
echo === Committing ===
git commit -m "Add manifesto section, Restaurant JSON-LD schema, and full Open Graph meta tags (from master audit)"

echo.
echo === Pushing ===
git push origin main

echo.
echo ========================================================
echo  Done. Check https://github.com/kirbykung168-art/Holic-House-cafe-Draft
echo ========================================================
pause
endlocal
