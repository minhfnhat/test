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
    default-jdk \
    nodejs \
    npm \
    php \
    && rm -rf /var/lib/apt/lists/*

# Install TensorFlow, PyTorch, Keras, scikit-learn, NLTK
RUN pip3 install --no-cache-dir \
    tensorflow==2.13.1 \
    torch==1.10.0 \
    torchvision==0.11.1 \
    torchaudio==0.10.0 \
    keras==2.13.1 \
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

# Install Java Spring
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get install -y git && \
    git clone https://github.com/spring-projects/spring-petclinic.git && \
    cd spring-petclinic && \
    ./mvnw package && \
    apt-get purge -y maven && \
    rm -rf /var/lib/apt/lists/*

# Install Python Django and Flask
RUN pip3 install --no-cache-dir \
    Django \
    Flask

# Install React Native
RUN npm install -g react-native-cli

# Install Chrome
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Install Android SDK
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip && \
    mkdir -p /usr/local/android-sdk/cmdline-tools && \
    unzip -d /usr/local/android-sdk/cmdline-tools commandlinetools-linux-*.zip && \
    rm commandlinetools-linux-*.zip && \
    yes | /usr/local/android-sdk/cmdline-tools/bin/sdkmanager --licenses && \
    /usr/local/android-sdk/cmdline-tools/bin/sdkmanager "platform-tools" "platforms;android-30" && \
    rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN apt-get update && \
    apt-get install -y unzip && \
    git clone https://github.com/flutter/flutter.git /usr/local/flutter && \
    export PATH="$PATH:/usr/local/flutter/bin" && \
    flutter doctor --android-licenses && \
    flutter doctor && \
    rm -rf /var/lib/apt/lists/*

# Expose the ports for PostgreSQL, MongoDB, MySQL, and any other services
EXPOSE 5432 27017 3306

# Start services
CMD service postgresql start && \
    service mongodb start && \
    service mysql start && \
    bash
