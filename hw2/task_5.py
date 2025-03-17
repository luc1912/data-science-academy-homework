import pandas as pd
from clickhouse_driver import Client
import logging

# configuration
FILE_PATH = 'data/processed_data.csv'
MAX_TRIES = 4

# logging configuration
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler()]
)

# SQL query to create table
SQL_QUERY = """ 
CREATE TABLE IF NOT EXISTS lrunjic.l2_dataset 
( 
    eventDate String,            
    eventName String,          
    userPseudoId String,      
    platform LowCardinality(String),               
    status LowCardinality(String),                  
    geoCountry LowCardinality(String),         
    id Nullable(Int64)                         
) 
ENGINE = MergeTree()
ORDER BY eventDate
SETTINGS index_granularity = 8192
"""

# clickHouse connection parameters
CLICKHOUSE_HOST = '37.59.22.112'
CLICKHOUSE_PORT = '9000'
CLICKHOUSE_USER = 'lrunjic'
CLICKHOUSE_PASSWORD = 'frB210Ajo88Y8H9afHv5'
CLICKHOUSE_DATABASE = 'lrunjic'

def upload_to_clickhouse():

    retries = 0
    while retries < MAX_TRIES:
        try:
            logging.info("Trying to connect to ClickHouse")
            client = Client(
                host=CLICKHOUSE_HOST,
                port=CLICKHOUSE_PORT,
                user=CLICKHOUSE_USER,
                password=CLICKHOUSE_PASSWORD,
                database=CLICKHOUSE_DATABASE
            )
            break # if the connection is successful, exit the loop
        except Exception as e:
            logging.error(f"Error during connection to ClickHouse: {e}")
            retries += 1
            logging.info(f"Retrying")

    logging.info("Executing SQL query to create table")
    client.execute(SQL_QUERY)
    logging.info("Table creation completed")
    
    logging.info(f"Reading data from {FILE_PATH} in chunks")
    try:
        data = pd.read_csv(FILE_PATH, chunksize=50000)  # reading CSV in chunks of 50k rows
        for chunk_num, chunk in enumerate(data, start=1):
            chunk["id"] = pd.to_numeric(chunk["id"]).astype("Int64")
            chunk["eventDate"] = chunk["eventDate"].astype(str)
            chunk["eventName"] = chunk["eventName"].astype(str)
            chunk["userPseudoId"] = chunk["userPseudoId"].astype(str)
            chunk["geoCountry"] = chunk["geoCountry"].astype(str)
            chunk["platform"] = chunk["platform"].astype(str)
            chunk["status"] = chunk["status"].astype(str)

            logging.info(f"Uploading chunk {chunk_num} to ClickHouse")
    
            records = chunk.to_dict(orient="records")  # Pretvorba u listu rječnika
    
            client.execute(
            'INSERT INTO lrunjic.l2_dataset(eventDate,eventName,userPseudoId,platform,status,geoCountry,id) VALUES',
            records
            )
        logging.info("Data upload completed.")
    except Exception as e:
        logging.error(f"Error during data upload: {e}")

if __name__ == '__main__':

    logging.info("Starting the ClickHouse upload process")
    upload_to_clickhouse()
    logging.info("Process completed")
