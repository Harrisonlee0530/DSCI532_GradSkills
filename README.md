# DSCI532_GradSkills

## Graduate Employability Dashboard

This dashboard is the simplified version built with **R Shiny** based on the [python version (https://github.com/UBC-MDS/DSCI-532_2026_12_GradSkills)](https://github.com/UBC-MDS/DSCI-532_2026_12_GradSkills) built using **Shiny for Python** that allows users to explore graduate employment outcomes across universities, industries, and fields of study.

Users can filter the data by:
- Region
- Country
- Field of Study
- Degree Level
- Industry
- Graduation Year

The dashboard reimplements the filters, summary statistics and a bar chart from the python version

---

## Live Application

The deployed application can be accessed here:

**Dashboard:**


---

## Features

* Interactive **filters** for exploring graduate employment data
* **Summary statistics** for employment rates and starting salaries
* **Bar chart visualization** of average starting salary by industry
* Dynamic updates based on user-selected filters
* Collapsible sidebar filters using accordion panels

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.ubc.ca/hli76/DSCI532_GradSkills
cd DSCI532_GradSkills
```

---

### 2. Install required R packages

Open **RStudio** and run:

```r
install.packages(c(
  "shiny",
  "bslib",
  "tidyverse",
  "scales",
  "readr"
))
```

---

## Running the Application

To run the dashboard locally:

1. Open **RStudio**
2. Set the working directory to the project folder
3. Run the following command:

```r
shiny::runApp("src")
```

Alternatively, if the main file is `app.R`, you can simply click **Run App** in RStudio.

---

## Data

The dashboard uses processed graduate employment data located in:

```
data/processed/processed_data.csv
```

The raw data can be accessed from [kaggle](https://www.kaggle.com/datasets/zulqarnain11/global-graduate-skills-and-employability-index)

This dataset contains information about:
- Universities
- Fields of study
- Employment rates (6 months and 12 months)
- Average starting salaries
- Graduation year
- Region and country
- Industry of employment
