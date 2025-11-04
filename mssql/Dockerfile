FROM mcr.microsoft.com/mssql/server:2019-latest

USER root

# Copy setup scripts
COPY setup.sql /usr/src/app/setup.sql
COPY run-setup.sh /usr/src/app/run-setup.sh

# Grant permissions
RUN chmod +x /usr/src/app/run-setup.sh

USER mssql

# Run SQL Server and setup script
CMD /bin/bash /usr/src/app/run-setup.sh
