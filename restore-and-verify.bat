@echo off
setlocal
cd /d "%~dp0"

echo ========================================================
echo  Restore HEAD state and verify Vercel
echo ========================================================
echo.

REM 1. Remove stale lock if present
if exist ".git\index.lock" (
  echo Found stale .git\index.lock, removing...
  del /f /q ".git\index.lock"
)

REM 2. Show current state
echo === BEFORE ===
git status --short
echo.

REM 3. Restore everything to match HEAD (index AND working tree)
echo === Restoring all files to HEAD ===
git restore --staged --worktree .
echo.

REM 4. Verify clean
echo === AFTER ===
git status --short
echo.

REM 5. Confirm HEAD is dc2b40e
echo === Recent commits ===
git log --oneline -5
echo.

REM 6. Verify index.html size matches HEAD
echo === Working-tree index.html size ===
for %%I in (index.html) do echo   %%~zI bytes (HEAD has 49,970)
echo.

echo ========================================================
echo  Done. If status above shows nothing, working tree is clean.
echo  Live URL: https://holic-house-cafe-draft.vercel.app
echo ========================================================
pause
endlocal
