library(shiny)
library(data.table)
library(extrafont)
library(esquisse)
options(shiny.port = 8351)
options(shiny.host = "0.0.0.0")
args = commandArgs(trailingOnly=TRUE)

font_import()
loadfonts()

ui <- fluidPage(
  
  titlePanel("GNPS Esquisse Data Exploration Interface"),
  
  sidebarLayout(
    sidebarPanel(
        textAreaInput(inputId="datatext", "Import tab separated data", value = "", width = NULL, height="100%", placeholder = NULL)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          title = "esquisse",
          esquisserUI(
            id = "esquisse", 
            header = FALSE, # dont display gadget title
            choose_data = FALSE # dont display button to change data
          )
        ),
        tabPanel(
          title = "output",
          verbatimTextOutput("module_out")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  #TODO: refactor this portion of the code because, we don't fully understand global
  data <- reactiveValues(data=data.frame(), fulldt=data.frame(), name = "gnps")

  observeEvent(input$datatext, {
    print("Observing Text Area")
    if (nchar(input$datatext) > 10){
        fileConn<-file("output.tsv")
        writeLines(input$datatext,fileConn)
        close(fileConn)
        data$fulldt <- fread("output.tsv")
        data$data = data$fulldt
    }
    print("END")
  })

  result <- callModule(
    module = esquisserServer,
    id = "esquisse",
    data = data
  )
  
  output$module_out <- renderPrint({
    str(reactiveValuesToList(result))
  })
  
}

shinyApp(ui, server)