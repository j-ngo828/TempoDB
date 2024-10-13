# Use the latest Ubuntu LTS as the base image
FROM ubuntu:22.04

# Install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    zip \
    unzip \
    tar \
    pkg-config \
    ninja-build \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Clone vcpkg
RUN git clone https://github.com/microsoft/vcpkg.git /vcpkg

# Set environment variable for vcpkg on ARM architecture
ENV VCPKG_FORCE_SYSTEM_BINARIES=1

# Bootstrap vcpkg
RUN /vcpkg/bootstrap-vcpkg.sh -disableMetrics

# Set environment variables for vcpkg
ENV VCPKG_ROOT=/vcpkg
ENV VCPKG_DEFAULT_TRIPLET=arm64-linux

# Set the working directory
WORKDIR /app

# Copy the project files into the container
COPY . /app

# Ensure that your_program.sh has execute permissions
RUN chmod +x /app/your_program.sh

# Set the default command to run your_program.sh
CMD ["/app/your_program.sh"]
