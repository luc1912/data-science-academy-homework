# Deploy ClickHouse and Grafana using Docker Compose

## Prerequisites
Ensure that you have the following installed on your system:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Deployment Instructions
### 1. Clone the repository
```sh
git clone <repository-url>
cd <repository-folder>
```

### 2. Start the services
Run the following command in the project directory:
```sh
docker-compose up -d
```
This will start ClickHouse and Grafana as background services.

### 3. Verify that services are running
Check running containers using:
```sh
docker ps
```
You should see two containers: `clickhouse` and `grafana`.

## Accessing the Services
### ClickHouse
- HTTP Interface: [http://localhost:8123](http://localhost:8123)
- Native Protocol: `localhost:9000`
- To connect via terminal inside Docker Desktop:
  ```sh
  clickhouse-client --host=localhost --port=9000 --user=<USER>
  ```
  You will be prompted to enter your password. Once logged in, you can execute commands such as:
  ```sh
  SHOW TABLES;
  SHOW DATABASES;
  USE <database_name>;
  ```

### Grafana
- Web UI: [http://localhost:3000](http://localhost:3000)
- Default Login:
  - **Username**: `admin`
  - **Password**: `admin`

## Configuring ClickHouse as a Data Source in Grafana
1. Log in to Grafana at [http://localhost:3000](http://localhost:3000).
2. Navigate to **Configuration** → **Data Sources**.
3. Click **Add Data Source** and select **ClickHouse**.
4. Configure the data source:
   - **Server address**: `37.59.22.112`
   - **Server port**: `9000`
   - **Username**: (your ClickHouse username)
   - **Password**: (your ClickHouse password)
5. Click **Save & Test** to verify the connection.

## Stopping the Services
To stop and remove the containers, run:
```sh
docker-compose down
```
This will stop and remove both ClickHouse and Grafana containers but keep the stored data.

## Data Persistence
The setup includes Docker volumes to persist data:
- `clickhouse_data`: Stores ClickHouse database files.
- `grafana_data`: Stores Grafana configurations and dashboards.
These volumes ensure that data is not lost when the containers are restarted.

