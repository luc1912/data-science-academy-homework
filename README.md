# SofaScore Data Science Academy

## Data Engineering

### Homework 1
- Event-based analytics  
- Data quality assessment  
- Data pipeline exploration using SQL  

### Homework 2
- Hands-on task for the ETL process  
- Extracting Data – retrieving data from various sources using paramiko, zipfile, and clickhouse-driver  
- Transforming Data – Processing and cleaning the data using pandas  
- Loading Data – storing the processed data using the ClickHouse client  

### Homework 3
- Explored different ClickHouse table engines, compression methods, and codecs for optimized storage and query performance  
- Used dictionaries and (materialized) views for efficient data access and query management  

## Data Analytics

### Homework 4
- Deployed ClickHouse and Grafana using Docker Compose and configured Grafana to visualize data from ClickHouse  
- Dockerized data import into ClickHouse, processed the dataset, and created visualizations in Grafana  

### Homework 5
- Created visualizations for product and growth metrics using SQL queries with the Superset visualization tool 

### Homework 6
- Decomposed time series data using classical decomposition and STL  
- Ensured stationarity of the time series by applying unit root tests and first or second order differencing as needed  
- Visualized and interpreted ACF and PACF plots  
- Forecasted data using various methods (ARIMA, exponential smoothing, naive forecast, seasonal naive forecast, mean forecast)  
- Created visualizations of forecast results in Superset  

### Homework 7
- Performed an A/B test to compare metrics for the new feature between control and treatment group  
- Statistically analyzed the metrics of both groups  
- Wrote a report interpreting the results for stakeholders
  
## Machine Learning

### Homework 8
- Built machine learning models to classify users as organic or paid  
- Evaluated and compared models 
- Improved model performance through hyperparameter tuning with grid search  
- Saved the best-performing model using pickle for future use

### Homework 9
- Extracted data about users and the teams they follow from the ClickHouse database using Python clickhouse-driver
- Created a simple system for personalized event recommendations for users on a weekly basis based on the teams they follow
- For users without direct recommendations, found the 10 most similar users and generated recommendations based on their preferences
