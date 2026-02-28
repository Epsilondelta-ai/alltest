# alltest

[OpenCode](https://opencode.ai) + [oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode) custom command & skill for achieving full test coverage across any project.

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

### As a skill (for task delegation)

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
