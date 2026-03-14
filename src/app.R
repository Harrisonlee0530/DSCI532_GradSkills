library(shiny)
library(bslib)
library(tidyverse)

# Load data
data <- read_csv("../data/processed/processed_data.csv")

regions <- data$Region |> unique() |> sort()
countries <- data$Country |> unique() |> sort()
studies <- data$Field_of_Study |> unique() |> sort()
industries <- data$Top_Industry |> unique() |> sort()
degrees <- data$Degree_Level |> unique() |> sort()

min_year <- min(data$Graduation_Year)
max_year <- max(data$Graduation_Year)

ui <- fluidPage(
  titlePanel("Graduate Employability Dashboard"),
  theme = bs_theme(version = 5), 
  sidebarLayout(
    sidebarPanel(
      accordion(
        accordion_panel(
          "Region",
          checkboxGroupInput(
            "region",
            NULL,
            choices = regions,
            selected = regions
          )
        ),
        accordion_panel(
          "Country",
          checkboxGroupInput(
            "country",
            NULL,
            choices = countries,
            selected = countries
          )
        ),
        accordion_panel(
          "Field of Study",
          checkboxGroupInput(
            "study",
            NULL,
            choices = studies,
            selected = studies
          )
        ),
        accordion_panel(
          "Degree Level",
          checkboxGroupInput(
            "degree",
            NULL,
            choices = degrees,
            selected = degrees
          )
        ),
        accordion_panel(
          "Industry",
          checkboxGroupInput(
            "industry",
            NULL,
            choices = industries,
            selected = industries
          )
        ),
        open = FALSE
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
      layout_columns(
        card(
          card_header("Employment Rate (6 months)"),
          uiOutput("emp6_card")
        ),
        card(
          card_header("Employment Rate (12 months)"),
          uiOutput("emp12_card")
        ),
        card(
          card_header("Starting Salary"),
          uiOutput("salary_card")
        )
      ),
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
  
  summary_stats <- function(x) {
    paste0(
      "Average: ", 
        round(mean(x, na.rm = TRUE), 1), "<br>",
      "Bottom 25%: ", 
        round(quantile(x, 0.25, na.rm = TRUE), 1), "<br>",
      "Median: ", 
        round(median(x, na.rm = TRUE), 1), "<br>",
      "Top 25%: ", 
        round(quantile(x, 0.75, na.rm = TRUE), 1)
    )
  }
  
  output$emp6_card <- renderUI({
    df <- filtered_data()
    HTML(summary_stats(df$`Employment_Rate_6_Months (%)`))
  })
  
  output$emp12_card <- renderUI({
    df <- filtered_data()
    HTML(summary_stats(df$`Employment_Rate_12_Months (%)`))
  })
  
  output$salary_card <- renderUI({
    df <- filtered_data()
    HTML(summary_stats(df$Average_Starting_Salary_USD))
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