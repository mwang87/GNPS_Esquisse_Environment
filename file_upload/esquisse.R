library(shiny)
library(data.table)
library(extrafont)
library(esquisse)
options(shiny.port = 8348)
options(shiny.host = "0.0.0.0")
options(shiny.maxRequestSize=500*1024^2)
args = commandArgs(trailingOnly=TRUE)

font_import()
loadfonts()

### Whole Shiny app ###
ui <- fluidPage(
    esquisserUI(
        id = "esquisse", 
        container = esquisseContainer(fixed = TRUE)
    )
)

server <- function(input, output, session) {
    callModule(module = esquisserServer, id = "esquisse", dataModule="ImportFile")
}

shinyApp(ui, server)
