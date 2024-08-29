# Use Ubuntu as a base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libsqlite3-dev \
    sqlite3 \
    autoconf \
    bison \
    libgdbm-dev \
    libncurses5-dev \
    automake \
    libtool \
    bison \
    pkg-config \
    libx11-dev \
    libxrender1 \
    libxtst6 \
    libxi6

# Copy EnergyPlus and Ruby installation files to the Docker container
COPY EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu20.04-x86_64.sh /tmp/EnergyPlus.sh
COPY ruby-2.7.0.tar.gz /tmp/ruby-2.7.0.tar.gz

# Install EnergyPlus
RUN chmod +x /tmp/EnergyPlus.sh && \
    echo "y" | /tmp/EnergyPlus.sh && \
    rm /tmp/EnergyPlus.sh

# Install Ruby
WORKDIR /tmp
RUN tar -xzf ruby-2.7.0.tar.gz && \
    cd ruby-2.7.0 && \
    ./configure && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/ruby-2.7.0 /tmp/ruby-2.7.0.tar.gz

# Clean up unnecessary files
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the default command to run when the container starts
CMD ["bash"]
