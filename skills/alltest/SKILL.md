---
name: alltest
description: Full project test coverage. Analyzes the entire codebase, identifies coverage gaps, and writes tests to achieve 100% coverage (minimum 80%). Ensures every source file with exportable logic has at least one test. Use when the user mentions 'alltest', wants comprehensive testing, or asks for full test coverage.
license: MIT
compatibility:
  - Claude Code
  - OpenCode
  - OpenAI Codex
  - Cursor
  - Gemini CLI
  - Windsurf
metadata:
  author: Epsilondelta-ai
  version: "1.1"
  tags: testing, coverage, tdd, quality
---

# alltest — Full Project Test Coverage

Your mission: achieve maximum test coverage for the entire project through systematic test generation.

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

Assertion rules (strict):
- Every test function MUST contain at least one assertion that compares a result against a **concrete expected value** (a literal, a constructed object, or a well-defined variable — NOT just an existence/truthiness check).
- Every test MUST follow the **Arrange → Act → Assert** structure. Each section must be non-empty. A test with only "Act" (call the function) and no "Assert" is not a test.

Banned as sole assertion (these are acceptable only when ACCOMPANIED by a specific value assertion in the same test):
- JS/TS: `.toBeDefined()`, `.toBeTruthy()`, `.toBeFalsy()`, `.not.toBeNull()`, `.toBeInstanceOf()` without value check
- Python: `assert x is not None`, `assert x` (bare), `assert isinstance(x, T)` without value check
- Go: no assertion at all (just calling the function)
- Rust: `assert!(result.is_ok())`, `assert!(result.is_some())` without unwrap + value check

Required patterns — every test must have at least one of:
- JS/TS: `.toBe(expectedValue)`, `.toEqual({...})`, `.toThrow(ErrorType)`, `.toMatchObject({...})`
- Python: `assert result == expected`, `assert result.field == expected`, `pytest.raises(ErrorType)`
- Go: `assert.Equal(t, expected, actual)`, `assert.ErrorIs(t, err, expected)`
- Rust: `assert_eq!(result, expected)`, `assert_ne!(result, unexpected)`

Self-review check (do this mentally for every test you write):
- "If this implementation always returned null/0/empty-string, would this test fail?" → If no, rewrite with a specific expected value.
- "What specific bug does this test catch?" → If you can't answer, the test adds no value.

Other rules:
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
- No tests that only call functions without asserting on the return value.
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
5. If available, run diagnostics or linting on every new test file.

### Step 5b: Test Quality Verification

After tests pass and coverage targets are met, verify test **quality**:

**A. Assertion density check (all new test files):**
Count assertion calls in each test function. Flag any test function with 0 assertions.
- JS/TS: count `expect(` calls per `test()`/`it()` block
- Python: count `assert` statements per `def test_*` function
- Go: count `assert.`/`t.Error`/`t.Fatal`/`t.Errorf` per `func Test*`
- Rust: count `assert!`/`assert_eq!`/`assert_ne!` per `#[test] fn`
If any test function has 0 assertions → fix it before proceeding.

**B. Weak assertion scan (all new test files):**
Search each new test file for weak patterns. If found as the ONLY assertion in a test, replace with a specific value assertion:

| Pattern | Language | Action |
|---------|----------|--------|
| `expect($).toBeDefined()` | JS/TS | Replace with `.toBe(specificValue)` or `.toEqual(...)` |
| `expect($).toBeTruthy()` | JS/TS | Replace with `.toBe(true)` or specific comparison |
| `expect($).not.toBeNull()` | JS/TS | Replace with `.toBe(specificValue)` |
| `assert x is not None` | Python | Replace with `assert x == expected` |
| `assert result` (bare) | Python | Replace with `assert result == expected` |
| `assert!($.is_ok())` | Rust | Replace with `assert_eq!($.unwrap(), expected)` |

These are non-blocking if the weak assertion is ACCOMPANIED by a specific value assertion in the same test.

**C. Smoke mutation test (top 3 critical files, recommended if project has ≤50 test files):**
For the 3 source files with the most complex logic:
1. Temporarily change one return value to a trivial wrong value (e.g., `return 0`, `return None`, `return ""`). Use `git stash` or note the original for safe restoration.
2. Run ONLY that file's corresponding tests.
3. At least one test MUST fail. If none fail → the tests are not verifying behavior. Rewrite them.
4. Revert the source file immediately (`git checkout -- <file>`).
Skip Step C for projects with >50 test files (diminishing returns at scale).

### Step 5c: Final Report

6. Report final numbers:
   - Line coverage %
   - Branch coverage % (if available)
   - Files with 0 tests remaining (should be 0)
   - **Test quality metrics:**
     - Total test functions written
     - Test functions with ≥1 specific value assertion: X/Y (target: 100%)
     - Weak assertion patterns found and fixed: N
     - Smoke mutation results (if run): passed/failed

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
