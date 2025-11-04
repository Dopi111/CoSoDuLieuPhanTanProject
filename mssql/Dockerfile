FROM mcr.microsoft.com/mssql/server:2019-latest

# Switch to root to install and setup
USER root

# Copy setup scripts
COPY setup.sql /usr/src/app/setup.sql
COPY run-setup.sh /usr/src/app/run-setup.sh

# Grant permissions
RUN chmod +x /usr/src/app/run-setup.sh

# Run SQL Server and setup script as entrypoint
ENTRYPOINT ["/usr/src/app/run-setup.sh"]
