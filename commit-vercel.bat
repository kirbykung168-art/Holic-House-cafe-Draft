@echo off
setlocal
cd /d "%~dp0"
echo Committing vercel.json...
git add vercel.json .gitignore
git commit -m "Add vercel.json for static-site deploy (cleanUrls, image caching headers)"
git push origin main
echo Done.
pause
endlocal
