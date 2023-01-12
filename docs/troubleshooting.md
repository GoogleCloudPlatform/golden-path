# Troubleshooting

## GCE Startup Scripts

- View the startup script output

  ```
  sudo journalctl -u google-startup-scripts.service
  ```

- Rerun the startup script

  ```
  sudo google_metadata_script_runner startup
  ```

## Verify the service

- Connect to the `ledger-service` instance

  ```
  gcloud compute ssh ledger-service --zone ${GKE_GP_ZONE}
  ```

- Source the environment file

  ```
  source /opt/monolith/ledgermonolith.env
  ```

- Verify the service is running

  ```
  curl http://ledger-service:8080/version
  ```

  Expected output:

  ```
  v##.##.##
  ```

- Verify connectivity to the database

  ```
  pg_isready --dbname ${POSTGRES_DB} --host ledger-database --user ${POSTGRES_USER}
  ```

  Expected output:

  ```
  ledger-database:5432 - accepting connections
  ```

- Logout of the `ledger-service` instance

  ```
  logout
  ```

## Verify the database

- Connect to the `ledger-database` instance

  ```
  gcloud compute ssh ledger-database
  ```

- Source the environment file

  ```
  source /opt/monolith/ledgermonolith.env
  ```

- Verify the database

  ```
  pg_isready --dbname ${POSTGRES_DB} --host ledger-database --user ${POSTGRES_USER}
  ```

  Expected output:

  ```output
  ledger-database:5432 - accepting connections
  ```

- Logout of the `ledger-database` instance

  ```
  logout
  ```
