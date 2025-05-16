# E-commerce Funnel Analysis – Case Clara

This repository contains the complete solution for a data analyst case study focused on analyzing the conversion funnel of a simple e-commerce website. The goal is to provide actionable insights and strategies to improve the site's conversion rates, especially for new users.

## Case Study Overview

**Scenario:**  
You are analyzing data from an e-commerce website with four main pages:
1. **Home Page:** The entry point for all users.
2. **Search Page:** Accessed from the home page when a user performs a search.
3. **Payment Page:** Accessed from the search page when a user clicks on a product.
4. **Confirmation Page:** Accessed after a successful payment.

The CEO is concerned about low sales volume, particularly from new users, and wants to understand where users drop off in the funnel and how to improve conversion rates.
 
Investigate the conversion funnel, identify bottlenecks or issues, and suggest strategies to increase conversions.

## Repository Structure

- **data/**  
  Contains raw and processed CSV files, including funnel metrics and user activity data.

- **sql/**  
  SQL scripts for schema creation, ETL, and funnel metrics calculation (both wide and long formats).

- **notebooks/**  
  Jupyter notebooks for data ingestion, analysis, and export, using Python and pandas.

- **config/**  
  Configuration files for data ingestion.

## Data Files

The analysis is based on the following daily data files:
- `Home_page_table.csv` – Users landing on the home page
- `Search_page_table.csv` – Users landing on the search page
- `Payment_page_table.csv` – Users landing on the payment page
- `Payment_confirmation_table.csv` – Users landing on the confirmation page
- `User_table.csv` – User demographic and device information

## How to Use

1. **Database Setup:**  
   - Use the SQL scripts in `sql/` to create the schema and compute funnel metrics.
   - Load the CSV data into the database using the ingestion notebook.

2. **Analysis:**  
   - Run the analysis notebook to explore conversion rates, drop-off points, and trends by device and gender.
   - Use the generated metrics to identify bottlenecks and suggest improvements.

3. **Export:**  
   - Export processed data for reporting or further analysis using the export notebook.

## Technologies

- Python (pandas, SQLAlchemy, dotenv, Anaconda)
- MySQL
- Jupyter Notebooks

## Insights & Strategies

The repository provides:
- Conversion and drop-off metrics at each funnel stage
- Segmentation by device and gender
- Time-based trend analysis
- Identification of top-performing segments
- Actionable recommendations for funnel optimization

---

**Note:**  
All scripts and notebooks are designed to be modular and reproducible. See the `notebooks/README.md` and `sql/README.md` for detailed instructions.
