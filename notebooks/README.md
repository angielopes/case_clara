# Data Ingestion Notebook - README

This repository contains a series of notebooks for handling data operations in the "case_clara" project. The notebooks cover:

* Data ingestion from CSV files into a MySQL database
* Analysis of funnel metrics and conversion rates
* Exporting data from MySQL back to CSV format

The notebooks were developed and executed using **Anaconda**, in a virtual environment (`.conda`) with **Python 3.11.11**.

---

## Notebooks Overview

### 1. `ingestion.ipynb`
This notebook demonstrates the process of ingesting data into a MySQL database using Python. It includes:
- Loading ingestion configuration from a JSON file
- Reading multiple CSV data files into pandas DataFrames
- Connecting to a MySQL database using SQLAlchemy
- Uploading data to the appropriate database tables

### 2. `analysis.ipynb`
This notebook performs comprehensive analysis of funnel metrics data, including:
- Conversion and drop-off rate calculations by device and gender
- Time-based trend analysis (weekly and monthly)
- Identification of top-performing segments
- Summary statistics for key performance metrics

### 3. `exportations.ipynb`
This notebook handles data export operations:
- Connecting to the MySQL database
- Selecting specific tables for export
- Converting database tables to pandas DataFrames
- Exporting data to CSV files for further use

---

## Prerequisites

To execute these notebooks, the following Python libraries must be installed in your environment:

```bash
pip install pandas python-dotenv sqlalchemy pymysql cryptography
```

### Libraries Explanation

* **pandas**: Used for reading and manipulating tabular data from CSV files and database operations.
* **os** and **dotenv**: `os` is a standard Python library, and `dotenv` is used to securely load environment variables from a `.env` file (e.g., database passwords).
* **sqlalchemy**: A SQL toolkit for Python, used to create the database engine and handle connections.
* **pymysql**: A lightweight MySQL client required by SQLAlchemy to interact with MySQL databases using the `mysql+pymysql` dialect.
* **cryptography**: Required by some secure operations in `pymysql`, especially when encrypted connections or password management are involved.
* **urllib.parse.quote\_plus**: Used to safely encode special characters in the password before constructing the connection string.

---

## Setting up the `.env` File

To avoid exposing sensitive information such as database passwords in the code, a `.env` file should be created in the root directory of your project with the following content:

```
DB_PASSWORD=your_password_here
```

Replace `your_password_here` with the actual password for your MySQL root user.

---

## Database Connection

The SQLAlchemy engine is created using the following connection string pattern:

```python
create_engine("mysql+pymysql://root:{password}@localhost/case_clara")
```

Make sure you meet the following requirements:

* The **username** is set to `root` (default for MySQL installations).
* The **host** is set to `localhost` (assuming the MySQL server is running locally).
* The **database** name is `case_clara`. You must create this database manually in MySQL before running the notebooks:

  ```sql
  CREATE DATABASE case_clara;
  ```

* The **password** will be loaded from the `.env` file and URL-encoded using `quote_plus()`.

---

## Data Files and Configuration

### For Ingestion:
The `ingestion.ipynb` notebook reads instructions from a JSON file located at:

```
../config/ingestion.json
```

This file must follow the structure below:

```json
[
  {
    "table": "table_name",
    "path": "../data/table_file.csv"
  },
]
```

### For Analysis:
The `analysis.ipynb` notebook reads data from:

```
../data/funnel_metrics.csv
```

### For Export:
The `exportations.ipynb` notebook exports data to CSV files in:

```
../data/
```

---

## Workflow Summary

1. **Data Ingestion**: Use `ingestion.ipynb` to load CSV data into the MySQL database
2. **Data Analysis**: Use `analysis.ipynb` to examine conversion rates and funnel metrics
3. **Data Export**: Use `exportations.ipynb` to save database tables back to CSV format

---

## Notes

* It is assumed that the MySQL server is running and accessible locally.
* The user must have appropriate privileges to insert and read data from the `case_clara` database.
* If any special characters are used in the MySQL password, they will be correctly encoded by `quote_plus()` to avoid connection issues.
* The notebooks follow a modular design, allowing them to be executed independently or as part of a complete data pipeline.
