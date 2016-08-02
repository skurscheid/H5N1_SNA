library(shiny)
library(leaflet)
library(RColorBrewer)

load("nattrCombined.rda")

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%")
)

server <- function(input, output, session) {

  # 
  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI
  filteredData <- reactive({nattrCombined})
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(nattrCombined) %>% addTiles() %>%
      fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat))
  })
  
  observe({
    leafletProxy("map", data = filteredData()) %>%
    clearShapes() %>%
      addCircles(lng = ~lon, 
                 lat = ~lat, 
                 weight = 1, 
                 radius = ~nideg * 30000 + 1, 
                 popup = ~id,
                 color = "red")
    })  
}

shinyApp(ui, server)