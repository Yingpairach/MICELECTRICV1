#!/bin/bash
# V2 Reset Deployment Script for MICELECTRICV1
# Run this from the root of your cloned MICELECTRICV1 repo

set -e

FIREBASE_OLD="https://calabura-ea686-default-rtdb.asia-southeast1.firebasedatabase.app"
SUPABASE_URL="https://fmoiykmqjhlcfvzgpvvj.supabase.co"
BASE_IMG_OLD="https://mistyboyz.github.io/Calabura/"
BASE_IMG_NEW="http://micelectriccar.com/"
NETLIFY_OLD="https://mic-electric-car.netlify.app"
NETLIFY_NEW="http://micelectriccar.com"

echo "=== Step 1: Copy latest source files from Calabura ==="
# Download the latest HTML files from Mistyboyz/Calabura
curl -sL "https://raw.githubusercontent.com/Mistyboyz/Calabura/main/index.html" -o index.html
curl -sL "https://raw.githubusercontent.com/Mistyboyz/Calabura/main/admin.html" -o admin.html
curl -sL "https://raw.githubusercontent.com/Mistyboyz/Calabura/main/profile.html" -o profile.html
curl -sL "https://raw.githubusercontent.com/Mistyboyz/Calabura/main/netlify/functions/charge.js" -o netlify/functions/charge.js
curl -sL "https://raw.githubusercontent.com/Mistyboyz/Calabura/main/netlify/functions/upload-image.js" -o netlify/functions/upload-image.js
echo "  ✓ Source files downloaded"

echo ""
echo "=== Step 2: Replace Firebase → Supabase ==="
find . \( -name "*.html" -o -name "*.js" -o -name "*.toml" \) -not -path "./.git/*" | while read f; do
  sed -i "s|${FIREBASE_OLD}|${SUPABASE_URL}|g" "$f"
done
echo "  ✓ Firebase URL → Supabase URL"

echo ""
echo "=== Step 3: Replace GitHub Pages base image URL → micelectriccar.com ==="
find . -name "*.html" -not -path "./.git/*" | while read f; do
  sed -i "s|${BASE_IMG_OLD}|${BASE_IMG_NEW}|g" "$f"
done
echo "  ✓ Base image URL updated"

echo ""
echo "=== Step 4: Replace Netlify function URL → micelectriccar.com ==="
find . \( -name "*.html" -o -name "*.js" \) -not -path "./.git/*" | while read f; do
  sed -i "s|${NETLIFY_OLD}|${NETLIFY_NEW}|g" "$f"
done
echo "  ✓ Netlify function URL updated"

echo ""
echo "=== Step 5: Update footer credit ==="
find . -name "*.html" -not -path "./.git/*" | while read f; do
  sed -i "s|Powered by Firebase|Powered by Supabase|g" "$f"
done
echo "  ✓ Footer updated"

echo ""
echo "=== Step 6: Update netlify.toml with Supabase env var docs ==="
cat >> netlify.toml << 'TOML'

# V2 Environment variables — set in Netlify dashboard:
# SUPABASE_URL      = https://fmoiykmqjhlcfvzgpvvj.supabase.co
# SUPABASE_ANON_KEY = <your Supabase anon/public key>
TOML
echo "  ✓ netlify.toml updated"

echo ""
echo "=== Step 7: Verify no old URLs remain ==="
OLD_COUNT=$(grep -r "$FIREBASE_OLD\|$BASE_IMG_OLD\|$NETLIFY_OLD" --include="*.html" --include="*.js" . 2>/dev/null | grep -v ".git" | wc -l)
if [ "$OLD_COUNT" -eq 0 ]; then
  echo "  ✓ No old URLs found — all clean!"
else
  echo "  ⚠️  Found $OLD_COUNT remaining old URL occurrences:"
  grep -r "$FIREBASE_OLD\|$BASE_IMG_OLD\|$NETLIFY_OLD" --include="*.html" --include="*.js" . | grep -v ".git"
fi

echo ""
echo "=== Step 8: Commit and push ==="
git add -A
git commit -m "V2 Reset: Copy from Calabura, datastore → Supabase, public URL → micelectriccar.com"
git push origin main

echo ""
echo "=== ✅ V2 Deployment Complete! ==="
echo "Deployed to: https://github.com/Yingpairach/MICELECTRICV1"
echo ""
echo "⚠️  IMPORTANT - Next steps in Supabase (https://fmoiykmqjhlcfvzgpvvj.supabase.co):"
echo "  1. Create tables: bookings, cars, packages, pkg_bindings, users, history, maintenance, adjustments"
echo "  2. Enable Row Level Security (RLS) policies as needed"
echo "  3. Copy your SUPABASE_ANON_KEY from: Supabase Dashboard → Settings → API"
echo "  4. Set SUPABASE_ANON_KEY in Netlify: Site Settings → Environment Variables"
echo ""
echo "⚠️  IMPORTANT - Firebase Auth is STILL ACTIVE (sign in/sign up uses Firebase)"
echo "  The datastore (bookings, cars, packages) now points to Supabase"
echo "  To also migrate auth → Supabase Auth, update the Firebase module imports"
echo "  in index.html and profile.html (search for 'import { initializeApp }' blocks)"
