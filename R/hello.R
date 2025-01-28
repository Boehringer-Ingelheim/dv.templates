#' Personal greeting
#'
#' @description Greet a person and appropriately capitalize their name.
#'
#' @param name Your name (character string; e.g. "john doe").
#'
#' @return A character string, capitalized to title case.
#' @export
#'
#' @examples
#' hello("james bond")
hello <- function(name = "your name") {
  words <- strsplit(name, " ")[[1]]
  words <- sapply(words, function(word) paste0(toupper(substr(word, 1, 1)), substr(word, 2, nchar(word))))
  name <- paste(words, collapse = " ")
  paste0("Hello, ", name, ".")
}

#' Personal greeting as a Shiny app
#'
#' @description Greet a person and appropriately capitalize their name
#'              as a Shiny app.
#'
#' @return Shiny app showcasing the personal greeting feature.
#' @export
#'
run_app <- function() {
  ui <- shiny::fluidPage(
    shiny::textInput("name", "What is your name?"),
    shiny::actionButton("greet", "Greet"),
    shiny::textOutput("greeting")
  )

  server <- function(input, output, session) {
    output$greeting <- shiny::renderText({
      shiny::req(input$greet)
      hello(shiny::isolate(input$name))
    })
  }

  shiny::shinyApp(ui, server)
}
