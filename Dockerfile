# Start with the Docker image for EnergyPlus from NREL
FROM nrel/energyplus:23.2.0

# Install system dependencies needed for Ruby and Python
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

# Use the Ruby Docker image to install Ruby 2.7
COPY --from=ruby:2.7 /usr/local/ /usr/local/

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
