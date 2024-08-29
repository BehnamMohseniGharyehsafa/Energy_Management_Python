# Start with the official Ruby 2.7 image from Docker Hub
FROM ruby:2.7

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    build-essential \
    python3-pip \
    libssl-dev \
    libcurl4-openssl-dev \
    libxi6 \
    libxtst6 \
    && rm -rf /var/lib/apt/lists/*

# Install EnergyPlus using the prebuilt Docker image from NREL
# Pull the Docker image for EnergyPlus 23.2
RUN wget https://github.com/NREL/docker-energyplus/releases/download/23.2.0/energyplus-23.2.0-7636e6b3e9-linux-amd64.tar.gz -O /tmp/energyplus.tar.gz && \
    tar -xzf /tmp/energyplus.tar.gz -C /usr/local && \
    rm /tmp/energyplus.tar.gz

# Set EnergyPlus environment variables
ENV PATH="/usr/local/EnergyPlus-23-2-0:/usr/local/EnergyPlus-23-2-0/bin:$PATH"
ENV ENERGYPLUS_INSTALL_PATH="/usr/local/EnergyPlus-23-2-0"

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
