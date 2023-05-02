# Migration Infrastructure

## APIs & Services

| API | Description |
|-----|-------------|
| `datamigration.googleapis.com` | [Database Migration Service](https://cloud.google.com/database-migration/docs) |

## Resources

| Resource | Description |
|----------|-------------|
| `processing-cluster` Google Kubernetes Engine (GKE) - Standard cluster | Migrate to Containers (M2C) processing cluster |
| `m2c-gce-source` Google service account (GSA) | Service account used by Migrate to containers (M2C) to connect to Google Compute Engined (GCE) source instances |
| `m2c-install` Google service account (GSA) | Service account used by Migrate to containers (M2C) to install resources in the GKE processing cluster |
| `psc-ip-alloc` internal static IP address allocation | Internal IP address allocation for Private Service Connect (PSC) communication between Database Migration Service (DMS) and the Virtual Private Network (VPN) |
| `database-psc` firewall rule | Firewall rule to allow Database Migration Service (DMS) to communicate with the database instance |

## IAM

| Member | Role | Description |
|--------|------|-------------|
| `m2c-gce-source` GSA | `roles/compute.storageAdmin` | Permissions to create, modify, and delete disks, images, and snapshots |
| `m2c-gce-source` GSA | `roles/compute.viewer` | Read-only access to get and list Compute Engine resources, without being able to read the data stored on them |
| `m2c-install` GSA | `roles/storage.admin` | Grants full control of buckets and objects |
