# Case Clara: Funnel Metrics SQL Project

This project provides SQL scripts and schema definitions to analyze user progression through a multi-step funnel for the "case_clara" project. The scripts are designed to generate metrics and insights about user behavior segmented by date, device, and gender.

## Project Structure

- **sql/case_clara_schema.sql**  
  Defines the database schema, including tables for users and each funnel step (home, search, payment, confirmation). It also sets up foreign key relationships.

- **sql/funnel_etl.sql**  
  Generates daily funnel metrics, including counts at each funnel stage, conversion rates between stages, and drop-off counts. The output is segmented by date, device, and gender, and includes the minimum and maximum dates in the dataset.

- **sql/create_funnel_metrics.sql**  
  Creates the `funnel_metrics` table and populates it with the same funnel metrics as in `funnel_etl.sql`. This script is intended for persistent storage of the metrics.

- **sql/create_funnel_metrics_long_format.sql**  
  Creates and populates the `funnel_metrics_long_format` table, which presents the funnel data in a "long format." Each row represents a single funnel step for a given date, device, and gender, making it suitable for visualization and stepwise analysis.

## Funnel Steps

The funnel consists of the following stages:
1. **Home**: User visits the home page.
2. **Search**: User performs a search.
3. **Payment**: User reaches the payment page.
4. **Confirmation**: User completes payment confirmation.

## Metrics Generated

- **Counts**: Number of unique users at each funnel stage.
- **Conversion Rates**: Percentage of users progressing from one stage to the next.
- **Drop-off Counts**: Number of users who did not proceed to the next stage.
- **Date Range**: Minimum and maximum dates in the user data for reference.

## Usage

1. Run `case_clara_schema.sql` to create the necessary tables.
2. Use `funnel_etl.sql` for ad-hoc analysis or reporting.
3. Use `create_funnel_metrics.sql` to create and populate the persistent `funnel_metrics` table.
4. Use `create_funnel_metrics_long_format.sql` to create and populate the `funnel_metrics_long_format` table for detailed, stepwise analysis.

---
**Note:** All scripts assume the presence of the required tables and appropriate data loaded into them.
