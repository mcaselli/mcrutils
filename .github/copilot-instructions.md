# Copilot Instructions For mcrutils

## Project Overview

- This repository is an R package named mcrutils.
- The package provides general-purpose helper functions for data cleaning, analysis, visualization, and reporting workflows.
- This is a public GitHub project. All contributions must be safe for public release. See below for details.
- Primary code lives in R/ and tests live in tests/testthat/.
- Package docs are generated from roxygen comments in R/ into man/ and NAMESPACE.
- README.md is generated from README.Rmd.

## What Good Changes Look Like Here

- Generally adhere to the [tidyverse style guide](https://style.tidyverse.org/) and [tidy design principles](https://design.tidyverse.org/).
- Keep edits small, focused, and consistent with existing package patterns.
- Prefer explicit namespaces where practical (for example dplyr::mutate, rlang::arg_match).
- In README/vignette examples, avoid namespace-qualified calls when the package is already loaded in that example context.
- In README, vignette, and internal documentation examples, prefer minimal and elegant code examples; include only the elements needed to communicate the behavior.
- Treat README as a brief overview of functionality; prioritize clarity and brevity over exhaustive edge-case coverage.
- Use the vignette for richer usage guidance, practical customization patterns, and extended examples.
- Treat function documentation generated from roxygen (man/ + help pages) as the definitive source of API behavior and argument-level details.
- Code should be clear and self-documenting, with roxygen2 comments for all exported functions.
- Prefer the cli package for user-facing UI, messages, warnings, and errors when adding or updating package feedback.
- Error messages should be descriptive and actionable; they should explain what is wrong and, when practical, how the caller can fix it.
- For longer messages, prefer cli's bullet style to separate the main error from supporting details.
- Be explicit about input validation. A good validation error follows the pattern: `{.arg x} must be <expected>; you provided <actual>`.
- Favor reusable, domain-agnostic APIs over project-specific wrappers.
- Preserve backward compatibility where practical; if behavior changes, call it out explicitly.
- Avoid introducing broad refactors unless explicitly requested.

## R Package Workflow Expectations

This repository follows the workflow and practices outlined in [R Packages (2e)](https://r-pkgs.org/), using the `devtools` package as the primary development toolkit. The checklist below is the practical implementation of that workflow for this project.

- When package code, behavior, or user-facing functionality changes, update `NEWS.md` with a concise entry before committing.

1. Always incorporate the separate private security/public-safety guidance that is maintained outside this repository.
2. If that separate guidance is not available in context, stop and do not make the change until it has been incorporated.

When function signatures or exported behavior change:

1. Update roxygen comments in R/ files.
2. Regenerate docs (man/ and NAMESPACE) with `devtools::document()`.
3. Add or update tests under tests/testthat/.
4. Run targeted tests first, then broader tests with `devtools::test()`.
5. Run `devtools::check()` and ensure no new errors or warnings before committing.

When touching README content:

1. Edit README.Rmd, not README.md directly.
2. Re-knit README.md from README.Rmd using `devtools::build_readme()`.

## Testing Guidance

- Prefer testthat edition 3 idioms used in this repository.
- Cover both success paths and argument validation failures.
- Add regression tests when fixing bugs.
- Keep tests deterministic.
- Where functions emit errors or messages, test the descriptive behavior at the level appropriate for the change.
- When adding input validation, test both that an error is raised and that the error text communicates the expected input and the provided value or type.

## Scope Discipline

- Do not modify unrelated files.
- Do not change package metadata, licensing, or CI workflows unless requested.
- If a requested change implies a breaking API change, call it out clearly in the response.