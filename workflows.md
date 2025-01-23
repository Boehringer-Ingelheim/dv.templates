# What these workflows do?

### [`check.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/check.yml)

Runs devtools::check() and devtools::test() on the R package inside the checked out repository.

### [`test.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/test.yml)

Runs tests on the installed package, generates the qc documentation and uploads it as an artifact for later consumption.

### [`lintr.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/lintr.yml)

Runs lintr on the repo with the linting settings specified in the container image, except when overriden by a repository-specific `.lintr.R` configuration file.

### [`pkgdown.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/pkgdown.yml)

Generates a [`pkgdown`](https://pkgdown.r-lib.org/) website and uploads it to Github Pages.

### [`roxygen.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/roxygen.yml)

Uses [`roxygen`](https://roxygen2.r-lib.org/) to generate `.Rd` files in the
`man/` directory. It also checks if manuals are up-to-date with roxygen comments in the code. (Currently broken).

### [`release.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/release.yml)

Uses adds additional checks before merging the PR to main.

### [`shared_ci.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/shared_ci.yml)

Builds a reusable workflow to be called from other repositories.

Example configuration for `main` branch:

```yaml
---
name: Checks 🧩

on:
  pull_request:
    types:
      - opened
      - synchronize
      - reopened
      - ready_for_review
    branches:
      - main
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  check-test:
    name: Check 📦
    uses: boehringer-ingelheim/dv.templates/.github/workflows/check.yml@main

  lintr:
    name: Lintr 🔍
    uses: boehringer-ingelheim/dv.templates/.github/workflows/lintr.yml@main
    with:
      lintr_error_on_lint: true

  roxygen:
    name: Roxygen 📄
    uses: boehringer-ingelheim/dv.templates/.github/workflows/roxygen.yml@main

  pkgdown:
    name: Pkgdown 📖
    uses: boehringer-ingelheim/dv.templates/.github/workflows/pkgdown.yml@main
```
