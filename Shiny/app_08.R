library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

players <- read.csv("data/nba2018.csv")

ui <- fluidPage(
  titlePanel("NBA 2018/19 Player Stats"),
  sidebarLayout(
    
    sidebarPanel(
      "Exploring all player stats from the NBA 2018/19 season",
      h3("Filters"),
      sliderInput(
        inputId = "VORP",
        label = "Player VORP rating at least",
        min = -3, max = 10,
        value = c(0, 10)
      ),
      
      h3("Plot options"),
      selectInput(
        "variable", "variable",
        choices = c("VORP", "Salary", "Age", "Height", "Weight"),
        selected = "Salary"
      ),
      radioButtons(inputId = "plot_type", 
                   label = "plot type",
                   choices = c("histogram", "density"),
                   selected = "histogram")
    ),
    mainPanel(
      strong(
        "There are",
        textOutput("num_players", inline = TRUE),
        "players in the dataset"
      ),
      plotOutput("nba_plot"),
      DTOutput("players_data")
    )
  )
)

server <- function(input, output, session) {

  filtered_data <- reactive({
    players <- players %>%
      filter(VORP >= input$VORP[1],
             VORP <= input$VORP[2])

    if (length(input$Team) > 0) {
      players <- players %>%
        filter(Team %in% input$Team)
    }

    players
  })

  output$players_data <- renderDT({
    filtered_data()
  })

  output$num_players <- renderText({
    nrow(filtered_data())
  })

  output$nba_plot <- renderPlot({
    
    ggplot(filtered_data(), aes_string(input$variable)) +
      theme_classic() +
      scale_x_log10(labels = scales::comma) +
    
    if(input$plot_type == "histogram"){
      geom_histogram()
    } else {
      geom_density()
    }
    
    # ggplot(filtered_data(), aes_string(input$variable)) +
    #   geom_histogram() +
    #   theme_classic() +
    #   scale_x_log10(labels = scales::comma)
  })

}

shinyApp(ui, server)
