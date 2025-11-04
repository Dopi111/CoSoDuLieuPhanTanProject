#!/bin/bash
set -e

# Start SQL Server in the background as mssql user
echo "Starting SQL Server..."
/opt/mssql/bin/sqlservr &

# Get the SQL Server PID
SQLSERVR_PID=$!

# Wait for SQL Server to be ready
echo "Waiting for SQL Server to start..."
sleep 40

# Check if SQL Server is running
for i in {1..60}; do
    if /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${SA_PASSWORD}" -Q "SELECT 1" &> /dev/null; then
        echo "SQL Server is ready!"
        break
    fi
    echo "Waiting for SQL Server... ($i/60)"
    sleep 1
done

# Run the setup script
echo "Running setup script..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${SA_PASSWORD}" -i /usr/src/app/setup.sql

echo "Setup completed successfully!"

# Wait for SQL Server process to keep container running
wait $SQLSERVR_PID
