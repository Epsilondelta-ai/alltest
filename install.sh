#!/usr/bin/env bash
set -euo pipefail

REPO="Epsilondelta-ai/alltest"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
SKILL_URL="$BASE_URL/skills/alltest/SKILL.md"
COMMAND_URL="$BASE_URL/commands/alltest.md"

INSTALLED=0

install_skill() {
  local dir="$1"
  local label="$2"
  mkdir -p "$dir"
  curl -fsSL "$SKILL_URL" -o "$dir/SKILL.md"
  echo "  ✓ $label → $dir/"
  INSTALLED=$((INSTALLED + 1))
}

echo "Installing alltest skill..."
echo ""

# --- Claude Code ---
CLAUDE_DIR="$HOME/.claude/skills/alltest"
if [ -d "$HOME/.claude" ]; then
  install_skill "$CLAUDE_DIR" "Claude Code"
else
  mkdir -p "$HOME/.claude/skills/alltest"
  install_skill "$CLAUDE_DIR" "Claude Code (created ~/.claude/)"
fi

# --- OpenAI Codex ---
CODEX_DIR="$HOME/.codex/skills/alltest"
if [ -d "$HOME/.codex" ]; then
  install_skill "$CODEX_DIR" "OpenAI Codex"
else
  echo "  · OpenAI Codex — skipped (~/.codex/ not found)"
fi

# --- OpenCode / oh-my-opencode ---
if [ -n "${OPENCODE_CONFIG_DIR:-}" ]; then
  OC_DIR="$OPENCODE_CONFIG_DIR"
elif [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/opencode" ]; then
  OC_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
else
  OC_DIR=""
fi

if [ -n "$OC_DIR" ]; then
  install_skill "$OC_DIR/skills/alltest" "OpenCode"

  # OpenCode also supports slash commands
  mkdir -p "$OC_DIR/commands"
  curl -fsSL "$COMMAND_URL" -o "$OC_DIR/commands/alltest.md"
  echo "  ✓ OpenCode /alltest command → $OC_DIR/commands/"
else
  echo "  · OpenCode — skipped (~/.config/opencode/ not found)"
fi

echo ""
if [ "$INSTALLED" -gt 0 ]; then
  echo "Done! alltest installed to $INSTALLED tool(s)."
else
  echo "No supported tools detected. Install manually:"
  echo "  Claude Code:  ~/.claude/skills/alltest/SKILL.md"
  echo "  OpenAI Codex: ~/.codex/skills/alltest/SKILL.md"
  echo "  OpenCode:     ~/.config/opencode/skills/alltest/SKILL.md"
fi
echo ""
echo "Usage:"
echo "  Any tool    → The agent auto-activates when you ask for test coverage"
echo "  OpenCode    → /alltest (slash command)"
echo ""
echo "Restart your coding tool to pick up the new skill."
