# Start with the specified Ruby 2.7 image using the provided SHA256 hash
FROM ruby:2.7@sha256:2347de892e419c7160fc21dec721d5952736909f8c3fbb7f84cb4a07aaf9ce7d as ruby

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

# Use EnergyPlus Docker image to locate the correct files
FROM nrel/energyplus:23.2.0@sha256:b9cef68f0c70a6ab396968ce897a8b65b33bce1b21f1577c376facd90be8bece as energyplus

# Use multi-stage build to copy EnergyPlus binaries
FROM ruby
# Correct path based on the directory found in the container
COPY --from=energyplus /EnergyPlus-23.2.0-7636e6b3e9-Linux-Ubuntu20.04-x86_64 /usr/local/EnergyPlus-23.2.0

# Set EnergyPlus environment variables
ENV PATH="/usr/local/EnergyPlus-23.2.0:/usr/local/EnergyPlus-23.2.0/bin:$PATH"
ENV ENERGYPLUS_INSTALL_PATH="/usr/local/EnergyPlus-23.2.0"

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
