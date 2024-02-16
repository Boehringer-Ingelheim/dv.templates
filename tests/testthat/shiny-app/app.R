if (Sys.getenv("CI") == "true") {
  pkgload::load_all(Sys.getenv("GITHUB_WORKSPACE"))
} else {
  pkgload::load_all()
}
run_app()
