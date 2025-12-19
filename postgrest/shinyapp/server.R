library(httr)
library(jsonlite)

shinyServer(function(input, output, session) {
  
  api_base <- "http://127.0.0.0:8080"
  
  # ---- 1. Load mouse IDs on startup ----
  observe({
    
    res <- GET(
      modify_url(api_base, path = "/rpc/get_mouse_ids")
    )
    
    stop_for_status(res)
    
    ids_df <- fromJSON(
      content(res, "text", encoding = "UTF-8")
    )
    
    # Expecting a column like: mouse_id
    mouse_ids <- ids_df$mouse_id
    
    updateSelectInput(
      session,
      inputId = "mouse_id",
      choices = mouse_ids,
      selected = mouse_ids[1]
    )
  })
  
  # ---- 2. Load data for selected mouse ----
  mouse_data <- eventReactive(input$load, {
    
    req(input$mouse_id)
    
    url <- modify_url(
      api_base,
      path = "/rpc/get_mouse_weight_data",
      query = list(
        p_mouse_id = as.integer(input$mouse_id)
      )
    )
    
    res <- GET(url)
    stop_for_status(res)
    
    df <- fromJSON(
      content(res, "text", encoding = "UTF-8"),
      flatten = TRUE
    )
    
    if (length(df) == 0) {
      return(data.frame())
    }
    
    df
  })
  
  # ---- 3. Render table ----
  output$weight_table <- renderDT({
    datatable(
      mouse_data(),
      options = list(
        pageLength = 25,
        autoWidth = TRUE
      )
    )
  })
  
})
