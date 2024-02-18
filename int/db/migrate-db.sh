#!/bin/bash

# Check if the RDS hostname is provided as an argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <rds-hostname>"
  exit 1
fi

RDS_HOSTNAME=$1
SCRIPT_DIR=$(dirname "$0")

# Execute SQL scripts
psql -h $RDS_HOSTNAME -U postgres -a -f "$SCRIPT_DIR/createDB.sql" && \
psql -h $RDS_HOSTNAME -U postgres -a -f "$SCRIPT_DIR/initDB.sql" -d petclinic && \
psql -h $RDS_HOSTNAME -U postgres -a -f "$SCRIPT_DIR/populateDB.sql" -d petclinic
