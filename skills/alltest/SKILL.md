---
name: alltest
description: Full project test coverage skill. Analyzes the entire project, identifies coverage gaps, and writes tests to achieve 100% coverage (minimum 80%). Ensures every source file has at least one corresponding test. Use when the user mentions 'alltest', wants comprehensive testing, or asks for full test coverage.
---

# alltest — Full Project Test Coverage Skill

You are now equipped with the **alltest** skill. Your mission: achieve maximum test coverage for the entire project through systematic test generation.

## Core Objectives

1. **100% test coverage** — the target. Every line, branch, and function covered.
2. **80% minimum** — the hard floor. Never deliver below this.
3. **Every file tested** — no source file with exportable logic should lack a test.

## Workflow

### Step 1: Project Analysis

Identify the tech stack and test infrastructure:

- **Language & framework**: Check `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `build.gradle`, `pom.xml`, `Gemfile`, `composer.json`, `mix.exs`, etc.
- **Test runner**: `jest`, `vitest`, `mocha`, `pytest`, `go test`, `cargo test`, `phpunit`, `rspec`, `ExUnit`, etc.
- **Coverage tool**: Built into runner, `istanbul/nyc`, `coverage.py`, `go cover`, `tarpaulin`, `phpunit --coverage`, etc.
- **If no test setup exists**: Install and configure the community standard test framework for this stack.

### Step 2: Coverage Gap Analysis

Build a complete map of what needs testing:

```
Source File             | Has Test | Estimated Coverage | Priority
------------------------|----------|-------------------|----------
src/auth/login.ts       | No       | 0%                | HIGH
src/utils/format.ts     | Yes      | 45%               | MEDIUM
src/config.ts           | No       | 0% (type-only)    | SKIP
```

- Run existing tests with coverage to get baseline numbers.
- Identify files with 0 coverage — these are top priority.
- Map uncovered lines/branches in partially-tested files.

### Step 3: Test Writing Strategy

**Priority order:**
1. Files with 0% coverage (every file must have at least 1 test)
2. Files with the lowest coverage percentage
3. Core business logic over peripheral utilities
4. Complex branching logic over simple pass-through

**Quality standards:**
- Test **behavior**, not implementation.
- Cover: happy path → edge cases → error handling → boundary conditions.
- Mock external dependencies (DB, API, network, filesystem).
- Use the project's existing patterns. Match:
  - File naming: `*.test.ts`, `*.spec.ts`, `*_test.go`, `test_*.py`, etc.
  - Directory structure: co-located, `__tests__/`, `tests/`, `test/`
  - Assertion style: `expect()`, `assert`, `should`, etc.
  - Mocking approach: `jest.mock`, `unittest.mock`, `testify/mock`, etc.

**What NOT to do:**
- No snapshot tests (unless project already uses them).
- No tests that only assert constants or trivial truths.
- No tests that duplicate existing coverage.
- No `@ts-ignore`, `as any`, `# type: ignore` in test code.
- No modifying source code to make it testable (unless user asks).
- No deleting or disabling existing tests.

### Step 4: Legitimate Exclusions

These files may be excluded from coverage requirements:

- Pure re-export files (`index.ts` that only has `export * from`)
- Generated code (protobuf, GraphQL codegen, OpenAPI stubs)
- Type-only files (`.d.ts`, type definition modules)
- Configuration-only files (static config objects, constants)
- Entry points with only bootstrap logic (`main.go` with just `func main()`)

Configure exclusions properly in the test runner (e.g., `coveragePathIgnorePatterns`, `omit` in `.coveragerc`).

### Step 5: Iteration & Verification

1. Write tests for the highest-priority gaps.
2. Run the full suite with coverage after each batch.
3. Check: coverage >= 80%? Every file has a test?
4. If not, continue. Do NOT stop early.
5. Run `lsp_diagnostics` on every new test file.
6. Report final numbers:
   - Line coverage %
   - Branch coverage %
   - Files with 0 tests remaining (should be 0)

## Integration Notes

This skill works with any language. Adapt the specific commands:

| Stack | Test Command | Coverage Flag |
|-------|-------------|--------------|
| Node/TS (Jest) | `npx jest` | `--coverage` |
| Node/TS (Vitest) | `npx vitest run` | `--coverage` |
| Python (pytest) | `pytest` | `--cov --cov-report=term-missing` |
| Go | `go test ./...` | `-coverprofile=coverage.out` |
| Rust | `cargo test` | `cargo tarpaulin` |
| Java (Maven) | `mvn test` | `jacoco:report` |
| PHP (PHPUnit) | `./vendor/bin/phpunit` | `--coverage-text` |
| Ruby (RSpec) | `bundle exec rspec` | `simplecov` in spec_helper |
| Elixir | `mix test` | `--cover` |

## When to Use This Skill

- User says "alltest" or asks for "full test coverage"
- User wants comprehensive testing across the whole project
- User asks to "write tests for everything"
- Delegated via `task(category="deep", load_skills=["alltest"], ...)`
