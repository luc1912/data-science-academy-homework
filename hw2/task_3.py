import helper
import os
import logging

# configuration
REMOTE_FILE_PATH = '/home/dsa/l2_dataset/march'
LOCAL_FOLDER_PATH = 'raw_data/' + REMOTE_FILE_PATH.split('/')[-1]

# logging configuration
logging.basicConfig(
    level=logging.INFO, 
    format='%(asctime)s - %(levelname)s - %(message)s', 
    handlers=[logging.StreamHandler()]  
)

def download_data():
    helper.download_folder(REMOTE_FILE_PATH, LOCAL_FOLDER_PATH)

    for file_name in os.listdir(LOCAL_FOLDER_PATH):
        local_file_path = os.path.join(LOCAL_FOLDER_PATH, file_name)
        # check if the file exists before proceeding with extraction
        if os.path.exists(local_file_path):
            logging.info(f"File {local_file_path} exists, proceeding with extraction.")
            helper.unzip_file(local_file_path, LOCAL_FOLDER_PATH)
        else:
            logging.error(f"File {local_file_path} does not exist, skipping extraction.")


if __name__ == '__main__':
    download_data()