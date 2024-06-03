#! /usr/local/bin/Rscript

success <- c(
    check = FALSE,
    test = FALSE,
    lint = FALSE,
    valdoc = FALSE
)

# Getting package information ----
pkg_name <- read.dcf("DESCRIPTION")[1, "Package"]
pkg_version <- read.dcf("DESCRIPTION")[1, "Version"]

# Building ----

message("############################")
message("###### INSTALLING (S) ######")
message("############################")

devtools::install(upgrade = FALSE, args = "--install-tests")

message("############################")
message("###### INSTALLING (F) ######")
message("############################")

# Checking ----

message("##########################")
message("###### CHECKING (S) ######")
message("##########################")

check_results <- rcmdcheck::rcmdcheck(error_on = "never", args = "--no-tests")
success[["check"]] <- identical(check_results[["errors"]], character(0))

message("##########################")
message("###### CHECKING (F) ######")
message("##########################")

# Testing ----

message("##########################")
message("###### TESTING  (S) ######")
message("##########################")

reporter <- testthat::MultiReporter$new(
    list(
        testthat::ProgressReporter$new(),
        testthat::SummaryReporter$new(file = file.path(getwd(), "tests", "test-out.xml"))
    )
)

test_results <- tibble::as_tibble(
    withr::with_envvar(
        new = list(CI = TRUE, no_proxy = "127.0.0.1", NOT_CRAN = TRUE, TESTTHAT_CPUS = 1),
        code = {
            testthat::test_package(pkg_name, reporter, stop_on_failure = FALSE)
        }
    )
)

success[["test"]] <- sum(test_results[["failed"]]) == 0

message("##########################")
message("###### TESTING  (F) ######")
message("##########################")

# Linting ----

message("##########################")
message("###### LINTING  (S) ######")
message("##########################")

lints <- lintr::lint_package()
message(paste(length(lints), "lints found"))
jsonlite::toJSON(data.frame(lints), file = "lintr_out.json")
success[["lint"]] <- length(lints) == 0

message("##########################")
message("###### LINTING  (F) ######")
message("##########################")

# Validation ----

message("#######################################")
message("###### RENDERING VALIDATION  (S) ######")
message("#######################################")

success[["valdoc"]] <- local({
    # This is evaluated inside a local because, otherwise, all the variables created in the chunks of the rendered
    # document leak into the environment

	validation_root <- "./inst/validation"
  	validation_report_rmd  <- file.path(validation_root, "val_report.Rmd")
  	validation_report_html  <- "val_report.html"
  	validation_results <- file.path(validation_root, "results")
  	val_param_rds <- file.path(validation_results, "val_param.rds")

  	stopifnot(dir.exists(validation_root))
  	stopifnot(file.exists(validation_report_rmd))

	stopifnot(dir.exists(validation_results))
  	unlink(list.files(validation_results))

    saveRDS(
          list(
              package = pkg_name,
              tests = test_results,
              version = pkg_version
          ),
          val_param_rds
      )

	rmarkdown::render(
        input = validation_report_rmd,
        params = list(
            package = pkg_name,
            tests = test_results,
            version = pkg_version
        ),
        output_dir = validation_results,
        output_file = validation_report_html
    )

# We use one of the leaked variables, created inside the validation report to asses if the validation is succesful or not
    VALIDATION_PASSED
})


message("#######################################")
message("###### RENDERING VALIDATION  (F) ######")
message("#######################################")

# message("##############################")
# message("###### BUILDING TAR (S) ######")
# message("##############################")

# devtools::build()

# message("##############################")
# message("###### BUILDING TAR (F) ######")
# message("##############################")

# Exit ----
message("##############################")
message("###### BUILD RESULT (S) ######")
message("##############################")

message(paste("Was", names(success), "successful?\t", success, collapse = "\n"))

# Write GITHUB ACTIONS summary
github_summary_file <- Sys.getenv("GITHUB_STEP_SUMMARY")
summary <- "# Build Summary"
summary <- c(
    summary,
    purrr::imap_chr(success, ~paste(" - ", if(.x) "\U02705" else "\U274C", "\t", .y))   
)

CON <- file(github_summary_file, "a")
on.exit(close(CON))
writeLines(summary, CON)

stopifnot(all(success))
    
message("##############################")
message("###### BUILD RESULT (F) ######")
message("##############################")
