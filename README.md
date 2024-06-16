## README for NYC Jobs Data Warehouse Project

### Project Overview

This project involves creating a data warehouse to analyze NYC job postings. The data warehouse is designed using fact and dimension tables to support efficient querying and reporting on job data.

### Data Sources

The primary data source is the NYC Open Data platform, which provides detailed job posting information including job titles, agencies, posting dates, job categories, and salary ranges.

### Data Warehouse Schema

The data warehouse follows a star schema design:

- **Fact Table**
  - `Fact_Job_Postings`: Contains job posting details and references to dimension tables.
  
- **Dimension Tables**
  - `Dim_Date`: Stores date-related information.
  - `Dim_Agency`: Contains details about the agencies.
  - `Dim_Job_Category`: Lists job categories.
  - `Dim_Job_Title`: Holds job titles and descriptions.
  - `Dim_Salary`: Includes salary ranges.

### Fact and Dimension Tables

#### Fact Table

- `Fact_Job_Postings`
  - `job_posting_id`: Unique identifier for each job posting.
  - `date_id`: Foreign key to the `Dim_Date` table.
  - `agency_id`: Foreign key to the `Dim_Agency` table.
  - `job_category_id`: Foreign key to the `Dim_Job_Category` table.
  - `job_title_id`: Foreign key to the `Dim_Job_Title` table.
  - `salary_id`: Foreign key to the `Dim_Salary` table.
  - `num_positions`: Number of positions available.
  - `posting_duration`: Duration for which the job posting is active.
  - `posting_date`: Date the job was posted.
  - `closing_date`: Date the job posting closes.

#### Dimension Tables

- `Dim_Date`
  - `date_id`: Unique identifier for each date.
  - `date`: Full date.
  - `year`: Year part of the date.
  - `month`: Month part of the date.
  - `day`: Day part of the date.
  - `weekday`: Day of the week.

- `Dim_Agency`
  - `agency_id`: Unique identifier for each agency.
  - `agency_name`: Name of the agency.

- `Dim_Job_Category`
  - `job_category_id`: Unique identifier for each job category.
  - `job_category_name`: Name of the job category.

- `Dim_Job_Title`
  - `job_title_id`: Unique identifier for each job title.
  - `job_title_name`: Name of the job title.

- `Dim_Salary`
  - `salary_id`: Unique identifier for each salary range.
  - `salary_from`: Starting range of the salary.
  - `salary_to`: Ending range of the salary.

### ETL Process

The ETL (Extract, Transform, Load) process is a critical part of the data warehousing project. Here’s a detailed breakdown:

1. **Extract**:
   - Data is extracted from the NYC Open Data platform in CSV format.
   - Tools: Python, Pandas library.

2. **Transform**:
   - Data cleaning: Removing duplicates, handling missing values, and correcting data types.
   - Data normalization: Ensuring consistency in format and structure.
   - Creating surrogate keys for dimension tables.
   - Mapping job postings to the appropriate dimensions.
   - Tools: Python, Pandas library.

3. **Load**:
   - Creating the database schema based on the star schema design.
   - Loading transformed data into the dimension tables.
   - Populating the fact table with references to dimension tables.
   - Tools: SQL, PostgreSQL.

### Detailed ETL Steps

#### Extract Step
```python
import pandas as pd

# Load job postings data
job_data = pd.read_csv('nyc_jobs.csv')

# Display first few rows
print(job_data.head())
```

#### Transform Step
```python
# Data cleaning example: Remove duplicates
job_data.drop_duplicates(inplace=True)

# Data normalization example: Normalize date format
job_data['posting_date'] = pd.to_datetime(job_data['posting_date'])

# Creating surrogate keys for dimensions
job_data['agency_id'] = job_data['agency_name'].factorize()[0] + 1
job_data['job_category_id'] = job_data['job_category_name'].factorize()[0] + 1
job_data['job_title_id'] = job_data['job_title_name'].factorize()[0] + 1

# Create Dim_Date
dim_date = job_data[['posting_date']].drop_duplicates().reset_index(drop=True)
dim_date['date_id'] = dim_date.index + 1
dim_date['year'] = dim_date['posting_date'].dt.year
dim_date['month'] = dim_date['posting_date'].dt.month
dim_date['day'] = dim_date['posting_date'].dt.day
dim_date['weekday'] = dim_date['posting_date'].dt.weekday

# Display transformed data
print(dim_date.head())
```

#### Load Step
```sql
-- Create Dim_Date table
CREATE TABLE Dim_Date (
    date_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    year INT,
    month INT,
    day INT,
    weekday INT
);

-- Create Dim_Agency table
CREATE TABLE Dim_Agency (
    agency_id SERIAL PRIMARY KEY,
    agency_name VARCHAR(255) NOT NULL
);

-- Create Dim_Job_Category table
CREATE TABLE Dim_Job_Category (
    job_category_id SERIAL PRIMARY KEY,
    job_category_name VARCHAR(255) NOT NULL
);

-- Create Dim_Job_Title table
CREATE TABLE Dim_Job_Title (
    job_title_id SERIAL PRIMARY KEY,
    job_title_name VARCHAR(255) NOT NULL
);

-- Create Dim_Salary table
CREATE TABLE Dim_Salary (
    salary_id SERIAL PRIMARY KEY,
    salary_from DECIMAL(10, 2),
    salary_to DECIMAL(10, 2)
);

-- Create Fact_Job_Postings table
CREATE TABLE Fact_Job_Postings (
    job_posting_id SERIAL PRIMARY KEY,
    date_id INT REFERENCES Dim_Date(date_id),
    agency_id INT REFERENCES Dim_Agency(agency_id),
    job_category_id INT REFERENCES Dim_Job_Category(job_category_id),
    job_title_id INT REFERENCES Dim_Job_Title(job_title_id),
    salary_id INT REFERENCES Dim_Salary(salary_id),
    num_positions INT,
    posting_duration INT,
    posting_date DATE,
    closing_date DATE
);

-- Insert data into Dim_Date table
INSERT INTO Dim_Date (date, year, month, day, weekday)
VALUES ('2024-06-16', 2024, 6, 16, 6);
```

### Usage Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/nyc-jobs-data-warehouse.git
   cd nyc-jobs-data-warehouse
   ```

2. **Set Up the Database**: Create the database and schema using provided SQL scripts.
   ```sql
   CREATE DATABASE nyc_jobs_data_warehouse;
   \c nyc_jobs_data_warehouse
   \i schema.sql
   ```

3. **Run the ETL Process**: Execute ETL scripts to load data into the warehouse.
   ```bash
   python etl.py
   ```

4. **Query the Data Warehouse**: Use SQL queries for analysis.

### Example Queries

- **Top 10 Agencies by Number of Job Postings**
  ```sql
  SELECT a.agency_name, COUNT(f.job_posting_id) AS num_postings
  FROM Fact_Job_Postings f
  JOIN Dim_Agency a ON f.agency_id = a.agency_id
  GROUP BY a.agency_name
  ORDER BY num_postings DESC
  LIMIT 10;
  ```

- **Job Postings by Month**
  ```sql
  SELECT d.year, d.month, COUNT(f.job_posting_id) AS num_postings
  FROM Fact_Job_Postings f
  JOIN Dim_Date d ON f.date_id = d.date_id
  GROUP BY d.year, d.month
  ORDER BY d.year, d.month;
  ```

### Tools and Technologies

- **SQL**: For database creation and querying.
- **Python**: For ETL processes.
- **PostgreSQL**: As the DBMS.

### Conclusion

This project demonstrates the process of creating a data warehouse using NYC job posting data. The structured approach of using fact and dimension tables allows for efficient data storage and retrieval, facilitating in-depth analysis of job trends in NYC.

Thank you for using the NYC Jobs Data Warehouse Project! If you have questions or need assistance, please contact us.
