# Use the prebuilt Docker image for Ruby 2.7
FROM ruby:2.7

# Install system dependencies required for EnergyPlus and Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    python3-pip \
    git \
    libxi6 \
    libxtst6 \
    && rm -rf /var/lib/apt/lists/*

# Use the prebuilt Docker image for EnergyPlus by pulling it directly
RUN wget -qO- https://github.com/NREL/docker-energyplus/archive/refs/heads/main.tar.gz | tar xz -C /tmp && \
    cd /tmp/docker-energyplus-main && \
    ./build_docker_image.sh && \
    rm -rf /tmp/docker-energyplus-main

# Install Python packages and Jupyter
RUN pip3 install --no-cache-dir \
    jupyter \
    openstudio \
    pyenergyplus-lbnl \
    esoreader \
    pandas \
    plotly

# Set the working directory for Jupyter and copy the notebook file
WORKDIR /home/jovyan
COPY Shoe_Box_Modeling_Final.ipynb /home/jovyan/

# Debugging: List all files in the working directory to verify that everything is in place
RUN ls -alh /home/jovyan/

# Expose port for Jupyter Notebook
EXPOSE 8888

# Start Jupyter Notebook with no token for easier access
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
