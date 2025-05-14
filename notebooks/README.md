# Data Ingestion Notebook - README

This notebook is part of a case study and demonstrates the process of ingesting data into a MySQL database using Python. It walks through the following steps:

* Loading ingestion configuration from a JSON file
* Reading multiple CSV data files into pandas DataFrames
* Connecting to a MySQL database using SQLAlchemy
* Uploading data to the appropriate database tables

It was developed and executed using **Anaconda**, in a virtual environment (`.conda`) with **Python 3.11.11**.

---

## Prerequisites

To execute this notebook, the following Python libraries must be installed in your environment:

```bash
pip install pandas python-dotenv sqlalchemy pymysql cryptography
```

### Libraries Explanation

* **pandas**: Used for reading and manipulating tabular data from CSV files.
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

* The **database** name is `case_clara`. You must create this database manually in MySQL before running the notebook:

  ```sql
  CREATE DATABASE case_clara;
  ```

* The **password** will be loaded from the `.env` file and URL-encoded using `quote_plus()`.

---

## Data Files and Configuration

The notebook reads ingestion instructions from a JSON file located at:

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
  ...
]
```

Each entry defines:

* The name of the table in the database.
* The path to the CSV file containing the data for that table.

---

## Uploading the Data

Each CSV file defined in the configuration is read into a pandas DataFrame. These DataFrames are then uploaded to their respective tables in the MySQL database using `to_sql()`:

```python
df.to_sql("table_name", con=engine, if_exists="append", index=False)
```

The notebook uses `if_exists="append"` to ensure that new rows are added without deleting existing data.

The process can be executed in batch for all configured files, or customized to upload specific tables as needed.

---

## Notes

* It is assumed that the MySQL server is running and accessible locally.
* The user must have appropriate privileges to insert data into the `case_clara` database.
* If any special characters are used in the MySQL password, they will be correctly encoded by `quote_plus()` to avoid connection issues.

---

## Summary

This notebook is structured for clarity, maintainability, and secure handling of credentials. It is suitable for real-world data workflows and can be extended to integrate with ETL pipelines or scheduling systems. All decisions made in this notebook follow best practices for local development with MySQL and Python.
