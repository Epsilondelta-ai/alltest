---
description: Achieve full test coverage (100% goal, 80% minimum). Analyzes the project, identifies gaps, writes tests for every file.
---

# /alltest — Full Project Test Coverage

You are now in **alltest mode**. Your single objective: achieve maximum test coverage for the entire project.

## Execution Steps

### Phase 1: Reconnaissance

1. **Identify the project's language, framework, and existing test setup**
   - Check `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `build.gradle`, `pom.xml`, etc.
   - Find existing test runner config: `jest.config`, `vitest.config`, `pytest.ini`, `.mocharc`, `phpunit.xml`, etc.
   - If no test framework exists, choose the most appropriate one for this project and set it up.

2. **Discover all source files and existing tests**
   - Map every source file that contains exportable logic (functions, classes, modules).
   - Identify which files already have corresponding test files.
   - Build a coverage gap matrix: `[source file] → [has test: yes/no] → [estimated coverage]`.

3. **Run existing tests and measure current coverage**
   - Execute the test suite with coverage reporting enabled.
   - Record the baseline coverage percentage.
   - Identify uncovered lines, branches, and functions per file.

### Phase 2: Test Generation

4. **Prioritize files by impact**
   - Files with 0% coverage first (every file MUST have at least one test).
   - Then files with the most uncovered lines/branches.
   - Core business logic and utility functions before config/constants.

5. **Write tests following project conventions**
   - Match existing test file naming patterns (e.g., `*.test.ts`, `*.spec.ts`, `*_test.go`, `test_*.py`).
   - Match existing test directory structure (co-located vs `__tests__/` vs `tests/`).
   - Match existing assertion libraries and testing patterns.
   - If no conventions exist, use the community standard for the language/framework.

6. **Test quality requirements**

   **Assertion rules (strict):**
   - Every test function MUST contain at least one assertion that compares a result against a **concrete expected value** (a literal, a constructed object, or a well-defined variable — NOT just an existence/truthiness check).
   - Every test MUST follow the **Arrange → Act → Assert** structure. Each section must be non-empty. A test with only "Act" (call the function) and no "Assert" is not a test.

   Banned as sole assertion (acceptable only when ACCOMPANIED by a specific value assertion in the same test):
   - JS/TS: `.toBeDefined()`, `.toBeTruthy()`, `.toBeFalsy()`, `.not.toBeNull()`
   - Python: `assert x is not None`, `assert x` (bare)
   - Go: no assertion at all (just calling the function)
   - Rust: `assert!(result.is_ok())`, `assert!(result.is_some())` without value check

   Required patterns — every test must have at least one of:
   - JS/TS: `.toBe(expected)`, `.toEqual({...})`, `.toThrow(ErrorType)`
   - Python: `assert result == expected`, `pytest.raises(ErrorType)`
   - Go: `assert.Equal(t, expected, actual)`, `assert.ErrorIs(t, err, expected)`
   - Rust: `assert_eq!(result, expected)`, `assert_ne!(result, unexpected)`

   **Self-review check (do this for every test):**
   - "If this implementation always returned null/0/empty-string, would this test fail?" → If no, rewrite.
   - "What specific bug does this test catch?" → If you can't answer, delete and rewrite.

   **Other rules:**
   - Test real behavior, not implementation details.
   - Cover happy path, edge cases, and error cases.
   - Mock external dependencies (DB, API, filesystem) appropriately.
   - No snapshot tests unless the project already uses them.

### Phase 3: Coverage Targets

7. **Coverage goals (in priority order)**
   - **Target**: 100% line coverage.
   - **Minimum acceptable**: 80% line coverage.
   - **Hard requirement**: Every source file with exportable logic must have at least 1 test file.

8. **What counts as "untestable" (legitimate exclusions)**
   - Entry points / bootstrap files (e.g., `index.ts` that just re-exports, `main.go` with only `func main()`).
   - Generated code (protobuf stubs, GraphQL codegen, etc.).
   - Type-only files (`.d.ts`, pure type definitions).
   - Configuration files that contain only static data.
   - Mark these explicitly in coverage config (e.g., `coveragePathIgnorePatterns`).

### Phase 4: Verification

9. **Run the full test suite with coverage**
   - All tests must pass.
   - Coverage must meet the target (100%) or minimum (80%).
   - Report the final coverage numbers clearly.

10. **If coverage < 80%, continue writing tests**
    - Do NOT stop at "good enough". Keep iterating until at least 80%.
    - If truly stuck on specific files, document WHY they're hard to test and what would unblock them.

### Phase 4.5: Test Quality Verification

After tests pass and coverage targets are met, verify test **quality**:

11. **Assertion density check (all new test files)**
    Count assertion calls in each test function. Flag any test function with 0 assertions.
    - JS/TS: count `expect(` calls per `test()`/`it()` block
    - Python: count `assert` statements per `def test_*` function
    - Go: count `assert.`/`t.Error`/`t.Fatal`/`t.Errorf` per `func Test*`
    - Rust: count `assert!`/`assert_eq!`/`assert_ne!` per `#[test] fn`
    If any test function has 0 assertions → fix it before proceeding.

12. **Weak assertion scan (all new test files)**
    Search each new test file for weak patterns. If found as the ONLY assertion in a test, replace with a specific value assertion:

    | Pattern | Language | Action |
    |---------|----------|--------|
    | `expect($).toBeDefined()` | JS/TS | Replace with `.toBe(specificValue)` |
    | `expect($).toBeTruthy()` | JS/TS | Replace with `.toBe(true)` or specific check |
    | `expect($).not.toBeNull()` | JS/TS | Replace with `.toBe(specificValue)` |
    | `assert x is not None` | Python | Replace with `assert x == expected` |
    | `assert result` (bare) | Python | Replace with `assert result == expected` |
    | `assert!($.is_ok())` | Rust | Replace with `assert_eq!($.unwrap(), expected)` |

    Non-blocking if the weak assertion is ACCOMPANIED by a specific value assertion in the same test.

13. **Smoke mutation test (top 3 critical files, recommended if project has ≤50 test files)**
    For the 3 source files with the most complex logic:
    1. Temporarily change one return value to a trivial wrong value (e.g., `return 0`). Use `git stash` or note the original for safe restoration.
    2. Run ONLY that file's corresponding tests.
    3. At least one test MUST fail. If none fail → tests are not verifying behavior. Rewrite them.
    4. Revert the source file immediately (`git checkout -- <file>`).
    Skip this step for projects with >50 test files.

### Phase 5: Final Report

14. **Report final numbers including quality metrics:**
    - Line coverage %
    - Branch coverage % (if available)
    - Files with 0 tests remaining (should be 0)
    - **Test quality metrics:**
      - Total test functions written
      - Test functions with ≥1 specific value assertion: X/Y (target: 100%)
      - Weak assertion patterns found and fixed: N
      - Smoke mutation results (if run): passed/failed

## Rules

- **DO NOT** modify source code to make it "more testable" unless the user explicitly asks.
- **DO NOT** delete or skip existing tests.
- **DO NOT** use `any` type assertions or disable type checking in tests.
- **DO NOT** create tests that depend on execution order.
- **DO NOT** write tests that only call functions without asserting on return values.
- **DO NOT** use weak assertions (`.toBeDefined()`, `assert x is not None`) as the sole assertion in a test.
- **DO** use the project's existing dependency versions — don't upgrade test frameworks.
- **DO** run `lsp_diagnostics` on all new test files before reporting completion.
- **DO** create a todo list breaking down the work by file/module before starting.
- **DO** perform the Phase 4.5 quality verification before reporting completion.
