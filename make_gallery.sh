#!/usr/bin/env bash
# set -e

# Run in a directory with a "wallpapers/" subdirectory, and it will create a
# "thumbnails/" subdirectory.
#
# Uses imagemagick's `convert`, so make sure that's installed.
# On Nix, nix-shell -p imagemagick --run ./make_gallery.sh
# rm -rf thumbnails
mkdir -p thumbnails wallpapers

url_root="https://raw.githubusercontent.com/arsildo/wallpapers/main"

echo "" >>README.md

total=$(ls wallpapers/ | wc -l)
i=0

for src in wallpapers/*; do
  ((i++))
  filename="$(basename "$src")"
  printf '%4d/%d: %s\n' "$i" "$total" "$filename"

  test -e "${src/wallpapers/thumbnails}" || convert -resize 400x200^ -gravity center -extent 400x200  "$src" "${src/wallpapers/thumbnails}"

  filename_escaped="${filename// /%20}"
  thumb_url="$url_root/thumbnails/$filename_escaped"
  pape_url="$url_root/wallpapers/$filename_escaped"

  echo "[![$filename]($thumb_url)]($pape_url)" >>README.md
done
