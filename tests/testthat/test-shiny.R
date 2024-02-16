test_that("the greeter app updates user's name on clicking the button", {
  app <- shinytest2::AppDriver$new(app_dir = "./shiny-app", name = "greeting_app")

  # WHEN: the user enters their name and clicks the "Greet" button
  app$set_inputs(name = "Hello Bar")
  app$click("greet")

  # THEN: a greeting is printed to the screen
  values <- app$expect_values(output = "greeting", screenshot_args = FALSE)
})
