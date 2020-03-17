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

ui <- fluidPage(
  
  titlePanel("Upload Esquisse Data Exploration Interface"),
  
  sidebarLayout(
    sidebarPanel(
        #textInput(inputId="uploadfile", "File Name (Do not touch)", value = "", width = NULL, placeholder = NULL),
        # Input: Select a file ----
        fileInput(inputId="file1", "Choose CSV File",
                  multiple = FALSE,
                  accept = c("text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv"))
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

  # observe({
  #   query <- parseQueryString(session$clientData$url_search)
  #   if (!is.null(query[['filename']])) {
  #     updateTextInput(session, "uploadfile", value=query[['filename']])
  #   }
  # })

  #TODO: refactor this portion of the code because, we don't fully understand global
  data <- reactiveValues(data=data.frame(), name="upload")

  # observeEvent(input$uploadfile, {
  #   if (nchar(input$uploadfile) > 2){
  #     data$data <- fread(sprintf("/uploads/%s", basename(input$uploadfile)))
  #   }
  # })

  observeEvent(input$file1, {
    print(input$file1)
    data$data = read.csv(file=input$file1$datapath)
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