# What do these workflows do?

### [`check.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/check.yml)

Runs devtools::check() and devtools::test() on the R package inside the checked out repository.

### [`test.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/test.yml)

Runs tests on the installed package, generates the qc documentation and uploads it as an artifact for later consumption.

### [`lintr.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/lintr.yml)

Runs lintr on the repo with the linting settings specified in the container image, except when overriden by a repository-specific `.lintr.R` configuration file.

### [`pkgdown.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/pkgdown.yml)

Generates `man/*.Rd` documentation through [`roxygen`](https://roxygen2.r-lib.org/).
Renders a [`pkgdown`](https://pkgdown.r-lib.org/) website and uploads it to Github Pages.

### [`release.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/release.yml)

Checks that version numbers in `NEWS.md` and `DESCRIPTION` match. 
Checks that version numbers don't have a fourth component (major.minor.patch.**dev**) on PRs targeting `main`.

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

  pkgdown:
    name: Pkgdown 📖
    uses: boehringer-ingelheim/dv.templates/.github/workflows/pkgdown.yml@main
```
