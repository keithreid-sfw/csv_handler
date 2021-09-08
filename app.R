library(shiny)
library(DT)

# Define UI
ui <- shinyUI(fluidPage(
    
    fileInput('target_upload', 'Choose file to upload',
              accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  '.csv'
              )),
    radioButtons("separator","Separator: ",choices = c(";",",",":"), selected=";",inline=TRUE),
    DT::dataTableOutput("sample_table")
)
)

# Define server logic
server <- shinyServer(function(input, output) {
    
    df_products_upload <- reactive({
        inFile <- input$target_upload
        if (is.null(inFile))
            return(NULL)
        df <- read.csv(inFile$datapath, header = TRUE,sep = input$separator)
        write.csv(df, "predictands.csv", row.names=FALSE)
        return(df)
    })
    
    output$sample_table<- DT::renderDataTable({
        df <- df_products_upload()
        DT::datatable(df)
    })
    
}
)

# Run the application 
shinyApp(ui = ui, server = server)