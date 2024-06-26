library(shiny)

players <- read.csv("data/nba2018.csv")
players

ui <- fluidPage(
  titlePanel("NBA 2018/19 Player Stats"),
  sidebarLayout(
    
    sidebarPanel(
      
      "Exploring all player stats from the NBA 2018/19 season",
      h3("Filters"),
      sliderInput(inputId = "VORP",
                  label = "Player VORP rating at least",
                  min = -3, max = 10,
                  value = 0),
      
      selectInput(inputId = "Team",
                  label = "Team",
                  choices = unique(players$Team),
                  selected = "Golden State Warriors"),
      
    ),
    mainPanel(
      strong(
        "There are",
        nrow(players),
        "players in the dataset"
      )
    )
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
