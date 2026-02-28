# alltest

[OpenCode](https://opencode.ai) custom command & skill for achieving full test coverage across any project. Best with [oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode).

## What it does

Type `/alltest` in OpenCode and the agent will:

1. Analyze your project's tech stack and existing test setup
2. Map every source file and identify coverage gaps
3. Write tests systematically — highest-impact files first
4. Iterate until coverage targets are met

**Coverage targets:**
- **Goal**: 100% line coverage
- **Minimum**: 80% line coverage
- **Hard rule**: Every source file with exportable logic gets at least one test

Works with any language: TypeScript, Python, Go, Rust, Java, PHP, Ruby, Elixir, and more.

## Requirements

- [OpenCode](https://opencode.ai) — `/alltest` slash command works out of the box.
- [oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode) (recommended) — unlocks full feature set:
  - `load_skills=["alltest"]` for task delegation
  - `lsp_diagnostics` verification on new test files
  - Background agent parallel exploration

> **Note**: Typing `alltest` without the `/` slash does NOT trigger the command. You must use `/alltest`. Keyword-based triggering (like `ultrawork`) is an oh-my-opencode built-in feature that does not support custom keywords.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Epsilondelta-ai/alltest/main/install.sh | bash
```

Restart OpenCode after installation.

## Usage

### As a slash command

```
/alltest
```

### As a skill (oh-my-opencode only)

```
task(category="deep", load_skills=["alltest"], prompt="Achieve full test coverage for this project")
```

## What gets installed

| File | Location | Purpose |
|------|----------|---------|
| `alltest.md` | `~/.config/opencode/commands/` | Slash command — `/alltest` |
| `SKILL.md` | `~/.config/opencode/skills/alltest/` | Skill — `load_skills=["alltest"]` |

## Uninstall

```bash
rm ~/.config/opencode/commands/alltest.md
rm -rf ~/.config/opencode/skills/alltest
```
