#!/bin/bash

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to start up (30 seconds)
echo "Waiting for SQL Server to start..."
sleep 30

# Run the setup script
echo "Running setup script..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'Your_S@trong_P@ssword1' -i /usr/src/app/setup.sql

echo "Setup completed!"

# Keep the container running
wait
