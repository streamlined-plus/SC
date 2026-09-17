#!/usr/bin/env bash
# Assemble the deployable site into ./dist
# No dependencies, no build step - this just selects which files ship.
set -euo pipefail
cd "$(dirname "$0")"

rm -rf dist
mkdir -p dist

cp index.html sitemap.xml robots.txt dist/
cp -r services dist/

echo "dist/ contents:"
find dist -type f | sort | sed 's/^/  /'
echo
echo "$(find dist -type f | wc -l) files, $(du -sh dist | cut -f1) total"
