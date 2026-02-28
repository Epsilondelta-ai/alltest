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
   - Test real behavior, not implementation details.
   - Cover happy path, edge cases, and error cases.
   - Mock external dependencies (DB, API, filesystem) appropriately.
   - No snapshot tests unless the project already uses them.
   - No trivial tests that only assert `true === true`.

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

## Rules

- **DO NOT** modify source code to make it "more testable" unless the user explicitly asks.
- **DO NOT** delete or skip existing tests.
- **DO NOT** use `any` type assertions or disable type checking in tests.
- **DO NOT** create tests that depend on execution order.
- **DO** use the project's existing dependency versions — don't upgrade test frameworks.
- **DO** run `lsp_diagnostics` on all new test files before reporting completion.
- **DO** create a todo list breaking down the work by file/module before starting.
