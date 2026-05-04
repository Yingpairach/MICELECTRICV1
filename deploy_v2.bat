@echo off
REM V2 Reset Deployment Script for MICELECTRICV1 (Windows)
REM Run from inside your cloned MICELECTRICV1 repo folder
REM Requires: git, curl (Windows 10+ has curl built-in)

echo === Step 1: Download latest source files from Calabura ===
curl -sL "https://raw.githubusercontent.com/Mistyboyz/Calabura/main/index.html" -o index.html
curl -sL "https://raw.githubusercontent.com/Mistyboyz/Calabura/main/admin.html" -o admin.html
curl -sL "https://raw.githubusercontent.com/Mistyboyz/Calabura/main/profile.html" -o profile.html
if not exist "netlify\functions" mkdir "netlify\functions"
curl -sL "https://raw.githubusercontent.com/Mistyboyz/Calabura/main/netlify/functions/charge.js" -o "netlify\functions\charge.js"
curl -sL "https://raw.githubusercontent.com/Mistyboyz/Calabura/main/netlify/functions/upload-image.js" -o "netlify\functions\upload-image.js"
echo   Done downloading source files

echo.
echo === Step 2: Replace URLs using PowerShell ===
powershell -Command "(Get-Content 'index.html' -Raw) -replace 'https://calabura-ea686-default-rtdb.asia-southeast1.firebasedatabase.app','https://fmoiykmqjhlcfvzgpvvj.supabase.co' -replace 'https://mistyboyz.github.io/Calabura/','http://micelectriccar.com/' -replace 'https://mic-electric-car.netlify.app','http://micelectriccar.com' -replace 'Powered by Firebase','Powered by Supabase' | Set-Content 'index.html' -NoNewline"
echo   index.html done

powershell -Command "(Get-Content 'admin.html' -Raw) -replace 'https://calabura-ea686-default-rtdb.asia-southeast1.firebasedatabase.app','https://fmoiykmqjhlcfvzgpvvj.supabase.co' -replace 'https://mistyboyz.github.io/Calabura/','http://micelectriccar.com/' -replace 'https://mic-electric-car.netlify.app','http://micelectriccar.com' -replace 'Powered by Firebase','Powered by Supabase' | Set-Content 'admin.html' -NoNewline"
echo   admin.html done

powershell -Command "(Get-Content 'profile.html' -Raw) -replace 'https://calabura-ea686-default-rtdb.asia-southeast1.firebasedatabase.app','https://fmoiykmqjhlcfvzgpvvj.supabase.co' -replace 'https://mistyboyz.github.io/Calabura/','http://micelectriccar.com/' -replace 'https://mic-electric-car.netlify.app','http://micelectriccar.com' -replace 'Powered by Firebase','Powered by Supabase' | Set-Content 'profile.html' -NoNewline"
echo   profile.html done

powershell -Command "(Get-Content 'netlify\functions\charge.js' -Raw) -replace 'https://mic-electric-car.netlify.app','http://micelectriccar.com' | Set-Content 'netlify\functions\charge.js' -NoNewline"
powershell -Command "(Get-Content 'netlify\functions\upload-image.js' -Raw) -replace 'https://mic-electric-car.netlify.app','http://micelectriccar.com' | Set-Content 'netlify\functions\upload-image.js' -NoNewline"
echo   netlify functions done

echo.
echo === Step 3: Commit and push to GitHub ===
git add -A
git commit -m "V2 Reset: Supabase datastore, micelectriccar.com public URL"
git push origin main

echo.
echo ============================================
echo   V2 Deployment Complete!
echo ============================================
echo   Repo: https://github.com/Yingpairach/MICELECTRICV1
echo.
echo   NEXT: Set these in Netlify Environment Variables:
echo   SUPABASE_URL      = https://fmoiykmqjhlcfvzgpvvj.supabase.co
echo   SUPABASE_ANON_KEY = (from Supabase Dashboard > Settings > API)
echo ============================================
pause
