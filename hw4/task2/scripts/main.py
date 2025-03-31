import logging
from task3 import download_data
from task4 import process_data
from task5 import upload_to_clickhouse

logging.basicConfig(level=logging.INFO)

if __name__ == "__main__":
    logging.info("Starting data pipeline...")

    logging.info("Step 1: Downloading data...")
    download_data()

    logging.info("Step 2: Processing data...")
    final_df = process_data()
    final_df.to_csv("data/processed_data.csv", index=False)

    logging.info("Step 3: Uploading data to ClickHouse...")
    upload_to_clickhouse()

    logging.info("Data pipeline completed successfully!")
