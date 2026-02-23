#!/usr/bin/env bash

GAME_DIR="$HOME/.steam/steam/steamapps/compatdata/374320/pfx/drive_c/users/steamuser/AppData/Roaming/DarkSoulsIII"
GAME_FILE="$GAME_DIR/DS30000.sl2"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_FILE="$SCRIPT_DIR/DS30000.sl2"
OLD_SAVE_DIR="$SCRIPT_DIR/old-save"

echo "Press:"
echo "  1: To backup your Dark Souls III savefile"
echo "  2: To restore the savefile from the repository"
read -r choice

if [ ! -d "$GAME_DIR" ]; then
    echo "Game save directory not found. Doing nothing."
    exit 0
fi

case "$choice" in
1)
    if [ -f "$GAME_FILE" ]; then
        cp "$GAME_FILE" "$REPO_FILE"
        echo "Save backed up to repository."
    else
        echo "Save file not found. Doing nothing."
    fi
    ;;
2)
    if [ ! -f "$REPO_FILE" ]; then
        echo "No save in repository to restore."
        exit 0
    fi

    echo
    echo "WARNING:"
    echo "This will restore the savefile from the repository."
    echo "The current save will be placed under ./old-save/"
    echo "Would you still like to continue? [y/n]"
    read -r confirm

    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Restore cancelled."
        exit 0
    fi

    if [ -f "$GAME_FILE" ]; then
        mkdir -p "$OLD_SAVE_DIR"
        timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
        cp "$GAME_FILE" "$OLD_SAVE_DIR/DS30000_$timestamp.sl2"
        echo "Existing save backed up to old-save/."
    fi

    cp "$REPO_FILE" "$GAME_FILE"
    echo "Repository save restored."
    ;;
*)
    echo "Invalid selection. Doing nothing."
    ;;
esac