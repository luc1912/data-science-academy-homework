import paramiko
import zipfile
import tarfile
import logging
import os
from time import sleep

# configuration
REMOTE_HOST_ADRESS = '130.162.221.233'
USERNAME = 'dsa'
PASSWORD = 'academy2025'
L0G_FILE_PATH = 'logs/download.log'
MAX_TRIES = 4

# logging configuration
# configuration for logging to the console
logging.basicConfig(
    level=logging.INFO, 
    format='%(asctime)s - %(levelname)s - %(message)s', 
    handlers=[logging.StreamHandler()]  
)

# creating a local folder if it does not already exist
def create_local_folder(folder_path):
    try:
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            logging.info(f'Folder {folder_path} created')
    except Exception as e:
        logging.error('Error: %s', e)

def download_file(remote_file_path, local_folder_path):
    file_name = remote_file_path.split('/')[-1]
    retries = 0

    while retries < MAX_TRIES:
        try:
            # connecting to the remote server using paramiko - SSH protocol
            with paramiko.SSHClient() as ssh:
                ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                ssh.connect(REMOTE_HOST_ADRESS, username=USERNAME, password=PASSWORD)
                logging.info("Connected to remote server")

                # downloading the file using SFTP protocol
                with ssh.open_sftp() as sftp:
                    create_local_folder(local_folder_path)
                    sftp.get(remote_file_path, os.path.join(local_folder_path, file_name))
                    logging.info(f"File {file_name} downloaded")
                    return  # if the file is downloaded successfully, exit the loop

        except paramiko.AuthenticationException:
            logging.error("Authentication failed")
            break  # if authentication fails, exit the loop
        except paramiko.SSHException as e:
            logging.error(f"SSH connection failed: {e}")
            retries += 1
            logging.info(f"Retrying")
            sleep(2)  
        except Exception as e:
            logging.error(f"Error: {e}")
            retries += 1
            logging.info(f"Retrying")
            sleep(2)

    logging.error("Failed to download the file")
    raise Exception("Download failed")

def download_folder(remote_folder_path, local_folder_path):
    retries = 0

    while retries < MAX_TRIES:
        try:
            # connecting to the remote server using paramiko - SSH protocol
            with paramiko.SSHClient() as ssh:
                ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                ssh.connect(REMOTE_HOST_ADRESS, username=USERNAME, password=PASSWORD)
                logging.info("Connected to remote server")

                with ssh.open_sftp() as sftp:
                    create_local_folder(local_folder_path)

                    # iterating over the files in the remote folder
                    for file_attr in sftp.listdir_attr(remote_folder_path):
                        remote_file = f"{remote_folder_path}/{file_attr.filename}"
                        local_file = os.path.join(local_folder_path, file_attr.filename)

                        # downloadig the file using SFTP protocol
                        sftp.get(remote_file, local_file)
                        logging.info(f"File {file_attr.filename} downloaded")

                    return  # if the folder is downloaded successfully, exit the loop

        except paramiko.AuthenticationException:
            logging.error("Authentication failed")
            break # if the authentication fails, exit the loop
        except paramiko.SSHException as e:
            logging.error(f"SSH connection failed: {e}")
            retries += 1
            logging.info(f"Retrying")
            sleep(2)
        except Exception as e:
            logging.error(f"Error: {e}")
            retries += 1
            logging.info(f"Retrying")
            sleep(2)

    logging.error("Failed to download the folder")
    raise Exception("Download failed")


# unzipping using ZipFile
def unzip_file(local_file_path, local_folder_path):
    if zipfile.is_zipfile(local_file_path):
        try:
            logging.info(f'Extracting data {local_file_path}')
            with zipfile.ZipFile(local_file_path, 'r') as zip_file:
                zip_file.extractall(path=local_folder_path)
                logging.info(f'Data extracted to {local_folder_path}')
            os.remove(local_file_path)
        except Exception as e:
            logging.error(f"Error unzipping file on path {local_file_path}: {e}")
    else:
        logging.error(f"File {local_file_path} is not a zip file")


# unzipping using TarFile
def open_tar(local_file_path, local_folder_path):
    if not tarfile.is_tarfile(local_file_path):
        try:
            logging.info(f'Extracting data {local_file_path}')
            with tarfile.open(local_file_path, 'r:gz') as tar:
                tar.extractall(path=local_folder_path)
                logging.info(f'Data extracted to {local_folder_path}')
            os.remove(local_file_path)
        except Exception as e:
            logging.error(f"Error unzipping file on path {local_file_path}: {e}")
    else:
        logging.error(f"File {local_file_path} is not a tar file")
