# Start with a minimal Ubuntu base image
FROM ubuntu:20.04

# Set environment variables to avoid user interaction during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libsqlite3-dev \
    libxi6 \
    libxtst6 \
    git \
    ca-certificates \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Ruby 2.7 from the official link
WORKDIR /tmp
RUN wget https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.0.tar.gz && \
    tar -xzf ruby-2.7.0.tar.gz && \
    cd ruby-2.7.0 && \
    ./configure && make && make install && \
    cd / && rm -rf /tmp/ruby-2.7.0 /tmp/ruby-2.7.0.tar.gz

# Install EnergyPlus 23.2.0 from the official link
RUN wget https://github.com/NREL/EnergyPlus/releases/download/v23.2.0/EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu22.04-x86_64.sh -O /tmp/EnergyPlus.sh && \
    chmod +x /tmp/EnergyPlus.sh && \
    echo "y" | /tmp/EnergyPlus.sh && \
    rm /tmp/EnergyPlus.sh

# Install Python dependencies and Jupyter
RUN pip3 install --no-cache-dir \
    jupyter \
    openstudio \
    pyenergyplus-lbnl \
    esoreader \
    pandas \
    plotly

# Expose port for Jupyter Notebook
EXPOSE 8888

# Set command to start Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
