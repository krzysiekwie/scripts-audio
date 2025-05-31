#!/bin/bash

# Check for required arguments
if [ $# -ne 2 ]; then
  echo "Usage: $0 <source_folder> <trim_seconds>"
  exit 1
fi

SRC_FOLDER="$1"
TRIM_SECONDS="$2"

# Validate source folder
if [ ! -d "$SRC_FOLDER" ]; then
  echo "Error: Source folder '$SRC_FOLDER' does not exist."
  exit 2
fi

# Validate trim time (should be a positive integer or float)
if ! [[ "$TRIM_SECONDS" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  echo "Error: Trim time '$TRIM_SECONDS' is not a valid number."
  exit 3
fi

DEST_FOLDER="$SRC_FOLDER/trimmed"
mkdir -p "$DEST_FOLDER"

echo "Trimming first $TRIM_SECONDS seconds from MP3s in '$SRC_FOLDER'..."
for file in "$SRC_FOLDER"/*.mp3; do
  [ -e "$file" ] || continue  # skip if no mp3 files found
  filename=$(basename "$file")
  ffmpeg -y -ss "$TRIM_SECONDS" -i "$file" -acodec copy "$DEST_FOLDER/$filename"
done

echo "Done. Trimmed files are in '$DEST_FOLDER'."
