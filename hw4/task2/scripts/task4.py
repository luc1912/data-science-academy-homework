import pandas as pd
import os
import helper
import logging

# configuration
LOCAL_FOLDER_PATH = 'raw_data/'
OUTPUT_FILE = 'processed_data.csv'
DATE_CUTOFF = '2024-03-15'
OUTPUT_FOLDER = 'data'

# camel case mapping
camel_case_columns = {
    "event_date": "eventDate",
    "event_name": "eventName",
    "user_pseudo_id": "userPseudoId",
    "platform": "platform",
    "status": "status",
    "geo_country": "geoCountry",
    "id": "id"
}

# columns from bq_events table
all_cols = ['event_date', 'event_timestamp', 'event_name', 'user_pseudo_id', 'geo_country', 
            'app_info_version', 'platform', 'firebase_experiments', 'id', 'item_name', 
            'previous_first_open_count', 'name', 'event_id', 'status' 
            ]

# columns that we want to select
needed_cols = ["event_date", "event_name", "user_pseudo_id", "platform", "status", "geo_country", "id"]

# logging configuration
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler()]
)

def load_month_data_from_directory(directory):
    all_data = []  # list to store data from each CSV file
    if os.path.exists(directory):
        for file in os.listdir(directory):
            # Only processing March files
            filter = {f'events_{i}.csv': i for i in range(20240316, 20240332)}
            if file.endswith('.csv') and not file.startswith('._') and file not in filter:
                file_path = os.path.join(directory, file)
                logging.info(f"Processing {file_path}")
                df = pd.read_csv(file_path, usecols=needed_cols, encoding='utf-8', low_memory=False)
                all_data.append(df)
    else:
        logging.warning(f"{directory} not found.")
    
    return pd.concat(all_data, ignore_index=True) if all_data else pd.DataFrame()

def process_data():

    # load only March data
    march_data = load_month_data_from_directory(os.path.join(LOCAL_FOLDER_PATH, 'march'))

    # combine all data into a single DataFrame (only March data)
    final_df = march_data

    # remove duplicates
    final_df.drop_duplicates(inplace=True)

    # rename columns to camelCase
    final_df.rename(columns=camel_case_columns, inplace=True)

    return final_df

if __name__ == '__main__':
    output_folder = input("Enter the output folder path: ")
    helper.create_local_folder(output_folder)
    OUTPUT_FOLDER = output_folder

    final_df = process_data()
    final_df.to_csv(os.path.join(OUTPUT_FOLDER, OUTPUT_FILE), index=False)
