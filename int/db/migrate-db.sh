#!/bin/bash

# Check if the RDS hostname is provided as an argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <rds-hostname>"
  exit 1
fi

RDS_HOSTNAME=$1

# Execute SQL scripts
psql -h $RDS_HOSTNAME -U postgres -a -f createDB.sql && \
psql -h $RDS_HOSTNAME -U postgres -a -f initDB.sql -d petclinic && \
psql -h $RDS_HOSTNAME -U postgres -a -f populateDB.sql -d petclinic
