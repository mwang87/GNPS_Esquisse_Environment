library(shiny)
library(data.table)
library(extrafont)
library(esquisse)
options(shiny.port = 8347)
options(shiny.host = "0.0.0.0")
args = commandArgs(trailingOnly=TRUE)

font_import()
loadfonts()

ui <- fluidPage(
  
  titlePanel("Use esquisse as a Shiny module"),
  
  sidebarLayout(
    sidebarPanel(
        textInput(inputId="gnpstask", "Import GNPS Task", value = "67357355dae54e7ebf07a8986f07a7f6", width = NULL, placeholder = NULL),
        textInput(inputId="featureselection", "Feature Number", value = "1,2", width = NULL, placeholder = NULL)
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
  observe({
    query <- parseQueryString(session$clientData$url_search)
    if (!is.null(query[['task']])) {
      updateTextInput(session, "gnpstask", value=query[['task']])
    }

    if (!is.null(query[['feature']])) {
      updateTextInput(session, "featureselection", value=query[['feature']])
    }
  })

  data <- reactiveValues(data = fread('https://gnps.ucsd.edu/ProteoSAFe/DownloadResultFile?task=67357355dae54e7ebf07a8986f07a7f6&file=feature_statistics/data_long.csv'), name = "gnps")
  fulldt <- fread('https://gnps.ucsd.edu/ProteoSAFe/DownloadResultFile?task=67357355dae54e7ebf07a8986f07a7f6&file=feature_statistics/data_long.csv')

  observeEvent(input$gnpstask, {
    fulldt <- fread(sprintf("https://gnps.ucsd.edu/ProteoSAFe/DownloadResultFile?task=%s&file=feature_statistics/data_long.csv", input$gnpstask))
    featurelist <- strsplit(input$featureselection, ",")[[1]]
    featurelist <- as.integer(featurelist)
    data$data <- fulldt[variable %in% featurelist]
  })

  observeEvent(input$featureselection, {
    featurelist <- strsplit(input$featureselection, ",")[[1]]
    featurelist <- as.integer(featurelist)
    data$data <- fulldt[variable %in% featurelist]
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