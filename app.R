library(shiny)
library(DT)

# Define UI
ui <- shinyUI(fluidPage(
    
    # user interface control
    fileInput('path_upload', 'Choose cases file to upload',
              accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  '.csv'
              )),
    
    # user interface view
    DT::dataTableOutput("sample_table")
)
)

# Define server logic
server <- shinyServer(function(input, output) {
    
    # server control
    products_upload <- reactive({
        inFile <- input$path_upload
        if (is.null(inFile))
            return(NULL)
        df <- read.csv(inFile$datapath, header = TRUE,sep=",")
        write.csv(df, "cases.csv", row.names=FALSE)
        return(df)
    })
    
    # server view
    output$sample_table<- DT::renderDataTable({
        df <- products_upload()
        DT::datatable(df)
    })
    
}
)

# Run the application 
shinyApp(ui = ui, server = server)