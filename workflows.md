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

### [`ci_image.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/ci_image.yml)

Resolves the container image the other workflows run in (see [CI image](#ci-image)) and returns it as the `image` output.

### [`shared_ci.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/shared_ci.yml)

Builds a reusable workflow to be called from other repositories. It is the entry point: it gets the CI image from `ci_image.yml` and passes it to the workflows above.

Example configuration:

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
  push:
    branches:
      - main
      - dev
      - test
  workflow_dispatch:

jobs:
  run-shared-ci:
    name: Shared
    uses: boehringer-ingelheim/dv.templates/.github/workflows/shared_ci.yml@main
```

`check.yml`, `test.yml`, `lintr.yml` and `pkgdown.yml` require the container image as the `ci_image` input, so call them through `shared_ci.yml` rather than directly.

# CI image

All repositories run on one container image, defined once as `DEFAULT_CI_IMAGE` at the top of [`ci_image.yml`](https://github.com/boehringer-ingelheim/dv.templates/blob/main/.github/workflows/ci_image.yml).

### Opting out: `CI_IMAGE`

A repository that needs a different image sets the Actions variable `CI_IMAGE`, as before. Delete the variable to use the central default.
A warning is issued when this option is used.
If possible it will sent as a PR comment (Write permission is set).
If not as a warning in the results. As this does not fail the actions the warning in the results may be hidden.