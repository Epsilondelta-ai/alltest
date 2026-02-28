# alltest

Agent skill for achieving full test coverage across any project. Follows the open [SKILL.md](https://agentskills.io/specification) standard.

Works with **Claude Code**, **OpenCode**, **OpenAI Codex**, **Cursor**, **Gemini CLI**, **Windsurf**, and any tool that supports the SKILL.md format.

## What it does

Activate the skill and the agent will:

1. Analyze your project's tech stack and existing test setup
2. Map every source file and identify coverage gaps
3. Write tests systematically — highest-impact files first
4. Iterate until coverage targets are met

**Coverage targets:**
- **Goal**: 100% line coverage
- **Minimum**: 80% line coverage
- **Hard rule**: Every source file with exportable logic gets at least one test

Works with any language: TypeScript, Python, Go, Rust, Java, PHP, Ruby, Elixir, and more.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Epsilondelta-ai/alltest/main/install.sh | bash
```

The script auto-detects installed tools and copies the skill to the right locations:

| Tool | Skill path | Auto-detected |
|------|-----------|---------------|
| Claude Code | `~/.claude/skills/alltest/SKILL.md` | Always |
| OpenAI Codex | `~/.codex/skills/alltest/SKILL.md` | If `~/.codex/` exists |
| OpenCode | `~/.config/opencode/skills/alltest/SKILL.md` | If `~/.config/opencode/` exists |

Restart your coding tool after installation.

### Manual install

Copy `skills/alltest/SKILL.md` from this repo into your tool's skills directory:

```bash
# Claude Code
mkdir -p ~/.claude/skills/alltest
cp skills/alltest/SKILL.md ~/.claude/skills/alltest/

# OpenAI Codex
mkdir -p ~/.codex/skills/alltest
cp skills/alltest/SKILL.md ~/.codex/skills/alltest/

# OpenCode
mkdir -p ~/.config/opencode/skills/alltest
cp skills/alltest/SKILL.md ~/.config/opencode/skills/alltest/

# Project-level (any tool)
mkdir -p .claude/skills/alltest
cp skills/alltest/SKILL.md .claude/skills/alltest/
```

## Usage

Most tools auto-activate skills based on context. Ask for test coverage and the agent will use the skill automatically.

### OpenCode slash command

```
/alltest
```

### OpenCode + oh-my-opencode skill delegation

```
task(category="deep", load_skills=["alltest"], prompt="Achieve full test coverage for this project")
```

### Any tool

```
Write tests to achieve full coverage for this project.
```

The agent will discover the alltest skill from its description and activate it.

> **Note (OpenCode)**: Typing `alltest` without the `/` slash does NOT trigger the command. You must use `/alltest`. Keyword-based triggering (like `ultrawork`) is an oh-my-opencode built-in feature that does not support custom keywords.

## Compatibility

| Feature | Claude Code | OpenAI Codex | OpenCode | OpenCode + oh-my-opencode |
|---------|------------|-------------|---------|--------------------------|
| Skill auto-activation | Yes | Yes | Yes | Yes |
| `/alltest` command | — | — | Yes | Yes |
| `load_skills=["alltest"]` | — | — | — | Yes |
| LSP diagnostics on tests | — | — | — | Yes |
| Background parallel agents | — | — | — | Yes |

## SkillsMP

This skill follows the [agentskills.io](https://agentskills.io) open standard and is discoverable on [SkillsMP](https://skillsmp.com/).

## Uninstall

```bash
rm -rf ~/.claude/skills/alltest
rm -rf ~/.codex/skills/alltest
rm -rf ~/.config/opencode/skills/alltest
rm -f ~/.config/opencode/commands/alltest.md
```

## License

MIT
