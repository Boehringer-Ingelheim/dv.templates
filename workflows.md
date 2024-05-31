# What these workflows do?

### [`check.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/check.yml)

Runs devtools::check() and devtools::test() on the R package inside the checked out repository.

### [`gitleaks.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/gitleaks.yml)

Runs [`gitleaks`](https://github.com/zricethezav/gitleaks) on the repo to discover any secrets that might have been hardcoded.

### [`lintr.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/lintr.yml)

Runs lintr on the repo with the linting settings specified in the container image.

### [`pkgdown.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/pkgdown.yml)

Generates a [`pkgdown`](https://pkgdown.r-lib.org/) website and uploads it to Github Pages.

### [`roxygen.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/roxygen.yml)

Uses [`roxygen`](https://roxygen2.r-lib.org/) to generate `.Rd` files in the
`man/` directory. It also checks if manuals are up-to-date with roxygen comments in the code.

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
    uses: boehringer-ingelheim/dv.templates/.github/workflows/check.yml@local

  lintr:
    name: Lintr 🔍
    uses: boehringer-ingelheim/dv.templates/.github/workflows/lintr.yml@local
    with:
      lintr_error_on_lint: true

  gitleaks:
    name: Gitleaks 🌧️
    uses: boehringer-ingelheim/dv.templates/.github/workflows/gitleaks.yml@local

  roxygen:
    name: Roxygen 📄
    uses: boehringer-ingelheim/dv.templates/.github/workflows/roxygen.yml@local

  pkgdown:
    name: Pkgdown 📖
    uses: boehringer-ingelheim/dv.templates/.github/workflows/pkgdown.yml@local

```
