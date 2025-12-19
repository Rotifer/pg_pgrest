library(shiny)
library(DT)

shinyUI(
  fluidPage(
    titlePanel("Mouse Weight Data"),
    
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "mouse_id",
          label = "Select Mouse ID",
          choices = NULL   # populated from server
        ),
        actionButton("load", "Load data")
      ),
      
      mainPanel(
        DTOutput("weight_table")
      )
    )
  )
)
