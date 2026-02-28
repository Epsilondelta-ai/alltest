#!/usr/bin/env bash
set -euo pipefail

REPO="Epsilondelta-ai/alltest"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

# Detect OpenCode config directory
if [ -n "${OPENCODE_CONFIG_DIR:-}" ]; then
  CONFIG_DIR="$OPENCODE_CONFIG_DIR"
elif [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/opencode" ]; then
  CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
else
  CONFIG_DIR="$HOME/.config/opencode"
fi

COMMANDS_DIR="$CONFIG_DIR/commands"
SKILLS_DIR="$CONFIG_DIR/skills/alltest"

echo "Installing alltest..."
echo "  Config dir: $CONFIG_DIR"

# Create directories
mkdir -p "$COMMANDS_DIR"
mkdir -p "$SKILLS_DIR"

# Download files
echo "  Downloading command..."
curl -fsSL "$BASE_URL/commands/alltest.md" -o "$COMMANDS_DIR/alltest.md"

echo "  Downloading skill..."
curl -fsSL "$BASE_URL/skills/alltest/SKILL.md" -o "$SKILLS_DIR/SKILL.md"

echo ""
echo "Done! alltest installed."
echo ""
echo "Usage:"
echo "  /alltest                    — Run as slash command"
echo "  load_skills=[\"alltest\"]     — Load as skill in task delegation"
echo ""
echo "Restart OpenCode to pick up the new command and skill."
