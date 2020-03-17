library(shiny)
library(data.table)
library(extrafont)
library(esquisse)
options(shiny.maxRequestSize=500*1024^2)
args = commandArgs(trailingOnly=TRUE)

font_import()
loadfonts()

### Whole Shiny app ###
ui <- navbarPage(
  title = "GNPS",
  tabPanel(
    title = "Equisse Standalone Plotter",
    esquisserUI(
      id = "esquisse", 
      header = FALSE,
      container = esquisseContainer(
        fixed = c(50, 0, 0, 0)
      )
    )
  )
)

server <- function(input, output, session) {
    callModule(module = esquisserServer, id = "esquisse", dataModule="ImportFile")
}

shinyApp(ui, server)
