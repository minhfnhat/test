# Use the official Ubuntu 20.04 base image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libpq-dev \
    libmysqlclient-dev \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install TensorFlow, PyTorch, Keras, scikit-learn, NLTK
RUN pip3 install --no-cache-dir \
    tensorflow \
    torch torchvision torchaudio \
    keras \
    scikit-learn \
    nltk

# Install OpenCV
RUN pip3 install --no-cache-dir opencv-python

# Install PostgreSQL
RUN apt-get update && \
    apt-get install -y postgresql postgresql-contrib && \
    rm -rf /var/lib/apt/lists/*

# Install MongoDB
RUN apt-get update && \
    apt-get install -y mongodb && \
    rm -rf /var/lib/apt/lists/*

# Install MySQL
RUN apt-get update && \
    apt-get install -y mysql-server && \
    rm -rf /var/lib/apt/lists/*

# Expose the ports for PostgreSQL, MongoDB, and MySQL
EXPOSE 5432 27017 3306

# Start services
CMD service postgresql start && \
    service mongodb start && \
    service mysql start && \
    bash
