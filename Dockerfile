# Use Ubuntu as a base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget curl build-essential libssl-dev libreadline-dev zlib1g-dev libsqlite3-dev sqlite3 \
    autoconf bison libgdbm-dev libncurses5-dev automake libtool bison pkg-config libx11-dev \
    libxrender1 libxtst6 libxi6 python3 python3-pip ruby ca-certificates

# Download and Install EnergyPlus
RUN wget https://github.com/NREL/EnergyPlus/releases/download/v23.2.0/EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu22.04-x86_64.sh -O /tmp/EnergyPlus.sh && \
    chmod +x /tmp/EnergyPlus.sh && echo "y" | /tmp/EnergyPlus.sh && rm /tmp/EnergyPlus.sh

# Download and Install Ruby
RUN wget https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.0.tar.gz -O /tmp/ruby-2.7.0.tar.gz && \
    mkdir /tmp/ruby && tar -xzf /tmp/ruby-2.7.0.tar.gz -C /tmp/ruby && cd /tmp/ruby/ruby-2.7.0 && \
    ./configure && make && make install && cd / && rm -rf /tmp/ruby/ruby-2.7.0 /tmp/ruby-2.7.0.tar.gz

# Install Python libraries
RUN pip3 install jupyter openstudio pyenergyplus esoreader pandas plotly

# Expose port for Jupyter Notebook
EXPOSE 8888

# Start Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
