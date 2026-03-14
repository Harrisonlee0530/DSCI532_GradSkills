library(shiny)
library(tidyverse)

# Load data
data <- read_csv("data/processed/processed_data.csv")

regions <- data$Region |> unique() |> sort()
countries <- data$Country |> unique() |> sort()
studies <- data$Field_of_Study |> unique() |> sort()
industries <- data$Top_Industry |> unique() |> sort()
degrees <- data$Degree_Level |> unique() |> sort()

min_year <- min(data$Graduation_Year)
max_year <- max(data$Graduation_Year)

ui <- fluidPage(
  titlePanel("Graduate Employability Dashboard (R Version)"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        "region",
        "Region",
        choices = regions,
        selected = regions
      ),
      checkboxGroupInput(
        "country",
        "Country",
        choices = countries,
        selected = countries
      ),
      checkboxGroupInput(
        "study",
        "Field of Study",
        choices = studies,
        selected = studies
      ),
      checkboxGroupInput(
        "degree",
        "Degree Level",
        choices = degrees,
        selected = degrees
      ),
      checkboxGroupInput(
        "industry",
        "Industry",
        choices = industries,
        selected = industries
      ),
      sliderInput(
        "grad_year",
        "Graduation Year",
        min = min_year,
        max = max_year,
        value = c(max_year - 4, max_year),
        step = 1,
        sep = ""
      )
    ),
    mainPanel(
      plotOutput("industry_bar", height = "500px")
    )
  )
)

server <- function(input, output, session) {

  filtered_data <- reactive({
    data |>
      filter(
        Graduation_Year >= input$grad_year[1],
        Graduation_Year <= input$grad_year[2],
        Region %in% input$region,
        Country %in% input$country,
        Field_of_Study %in% input$study,
        Top_Industry %in% input$industry,
        Degree_Level %in% input$degree
      )
  })
  
  # Bar chart
  output$industry_bar <- renderPlot({
    df <- filtered_data()
    
    industry_salary <- df |>
      group_by(Top_Industry) |>
      summarise(
        avg_salary = mean(Average_Starting_Salary_USD, na.rm = TRUE)
      ) |>
      arrange(desc(avg_salary))
    
    ggplot(
      industry_salary, 
      aes(
        x = reorder(Top_Industry, avg_salary),
        y = avg_salary,
        fill = Top_Industry
      )
    ) + 
      geom_col() +
      coord_flip() +
      labs(
        title = "Top Industries by Average Starting Salary",
        x = "Industry",
        y = "Average Starting Salary (USD)"
      ) +
      scale_y_continuous(labels = scales::dollar) +
      theme_minimal()
  })
}

shinyApp(ui, server)