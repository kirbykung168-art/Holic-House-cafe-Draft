@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ============================================================
echo  Holic Haus - emergency fix script
echo  - clears stale git lock
echo  - restores working tree to HEAD (dc2b40e)
echo  - opens Vercel /new so you can re-import the repo
echo ============================================================
echo.

REM 1. Remove stale lock if present
if exist ".git\index.lock" (
  echo [1/5] Removing stale .git\index.lock
  del /f /q ".git\index.lock"
) else (
  echo [1/5] No stale lock found
)
echo.

REM 2. Show pre-state
echo [2/5] Working tree before restore:
git status --short
echo.

REM 3. Restore everything to match HEAD (both index and working tree)
echo [3/5] Restoring all files to HEAD (dc2b40e)
git restore --staged --worktree .
echo.

REM 4. Verify clean
echo [4/5] Working tree after restore:
git status --short
echo Expected: nothing (clean tree)
echo.
echo HEAD:
git log --oneline -3
echo.
for %%I in (index.html) do echo index.html size: %%~zI bytes (expected ~49,970)
echo.

REM 5. Open Vercel /new — re-import the repo if the project was deleted
echo [5/5] Opening https://vercel.com/new in default browser...
echo.
echo What to do there:
echo   - If "Holic-House-cafe-Draft" appears in the Import Git Repository list,
echo     click "Import" and then "Deploy" (Framework: Other, no build command).
echo   - If the project still exists in your dashboard but the deployment vanished,
echo     go to the project's Deployments tab and click "Redeploy" on the last commit.
echo.
start "" "https://vercel.com/new"
start "" "https://vercel.com/dashboard"
echo.

echo ============================================================
echo  Done. After Vercel redeploys, run:
echo    curl https://holic-house-cafe-draft.vercel.app/  (should return 200)
echo ============================================================
pause
endlocal
