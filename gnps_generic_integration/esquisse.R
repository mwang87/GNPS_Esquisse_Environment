library(shiny)
library(data.table)
library(readr)
library(jsonlite)
library(extrafont)
library(esquisse)
options(shiny.port = 8359)
options(shiny.host = "0.0.0.0")
args = commandArgs(trailingOnly=TRUE)

font_import()
loadfonts()

ui <- fluidPage(
  
  titlePanel("GNPS Esquisse Data Exploration Interface"),
  
  sidebarLayout(
    sidebarPanel(
        textInput(inputId="gnpstask", "Import GNPS Task ID", value = "", width = NULL, placeholder = NULL),
        textInput(inputId="view", "Task Table Results View", value = "", width = NULL, placeholder = NULL)
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

    if (!is.null(query[['view']])) {
      updateTextInput(session, "view", value=query[['view']])
    }
  })

  #TODO: refactor this portion of the code because, we don't fully understand global
  data <- reactiveValues(data=data.frame(), fulldt=data.frame(), name = "gnps")

  observeEvent(input$gnpstask, {
    print("Observing GNPS Task")
    task_length = nchar(input$gnpstask)
    view_length = nchar(input$view)

    if (task_length == 32 && view_length > 0){
      url <- sprintf("https://gnps.ucsd.edu/ProteoSAFe/result_json.jsp?task=%s&view=%s", input$gnpstask, input$view)
      print(url)
      result_json <- fromJSON(url)["blockData"]
      result_table <- as.data.frame(result_json)
      result_table <- type_convert(result_table)
      data$data <- result_table

      # data$data = tryCatch({

        
        
      # }, warning = function(w) {
      #   print("warning")
      #   return(data.frame())
      # }, error = function(e) {
      #   print("ERROR")
      #   return(data.frame())
      # }, finally = {
      #   print("FINALLY")
      # })
    }
    print("END")
  })

  observeEvent(input$featureselection, {
    print("Observing Feature Selection")
    # if (nchar(input$featureselection) > 0){
    #   data$data = tryCatch({
    #     featurelist <- strsplit(input$featureselection, ",")[[1]]
    #     featurelist <- as.integer(featurelist)
    #     filtereddf <- data$fulldt[featureid %in% featurelist]
    #   }, warning = function(w) {
    #     print("warning")
    #     return(data.frame())
    #   }, error = function(e) {
    #     print("error")
    #     return(data.frame())
    #   }, finally = {
    #     print("FINALLY")
    #   })
    # }
    # else{
    #   data$data = data$fulldt
    # }
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