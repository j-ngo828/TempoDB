# TempoDB - Distributed Cache System

A high-performance, Redis-like distributed cache system built in modern C++20, designed to handle massive workloads with low latency and high availability.

## Overview

TempoDB is a distributed in-memory key-value store that provides Redis-compatible operations with horizontal scalability. Built from the ground up in C++20, it implements core caching functionality including TTL support, LRU eviction, and distributed operations across multiple nodes.

### Key Features

- **Core Operations**: SET, GET, DELETE with Redis-compatible protocol
- **TTL Support**: Configurable time-to-live for automatic key expiration
- **LRU Eviction**: Least Recently Used policy for memory management
- **Distributed Architecture**: Consistent hashing for horizontal scaling
- **High Availability**: Asynchronous replication with eventual consistency
- **High Performance**: Designed for <10ms latency and 100k+ requests/second
- **Docker-First Development**: Complete development environment in containers

### Architecture

TempoDB follows a distributed cache design with the following components:

- **Single Node Core**: Hash table + doubly-linked list for O(1) LRU operations
- **Network Layer**: TCP server with custom protocol (Redis-compatible)
- **Distribution Layer**: Consistent hashing for key sharding
- **Replication**: Asynchronous replication for fault tolerance
- **Background Services**: TTL cleanup and metrics collection

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Git

### Get Started

```bash
# Clone the repository
git clone https://github.com/j-ngo828/TempoDB.git
cd TempoDB

# Build and start development environment
make build
make dev

# In another terminal, access the container
make shell

# Build and run the cache server
make compile
./build/tempodb-server --port 6379
```

### Basic Usage

Connect to TempoDB using any Redis client:

```bash
# Using redis-cli (if available)
redis-cli -p 6379
SET mykey "Hello World"
GET mykey
TTL mykey 3600  # Set TTL to 1 hour
```

## Development Environment

TempoDB uses a Docker-first development approach. All development, building, testing, and debugging happens inside containers.

### Setting Up Development

1. **Clone and Build**:
   ```bash
   git clone https://github.com/j-ngo828/TempoDB.git
   cd TempoDB
   make build
   ```

2. **Start Development Container**:
   ```bash
   make dev
   ```

3. **Access Container Shell**:
   ```bash
   make shell
   ```

4. **Build the Project**:
   ```bash
   make compile
   ```

### Project Structure

```
TempoDB/
├── CMakeLists.txt          # CMake build configuration
├── Dockerfile             # Development environment
├── Makefile              # Build and development automation
├── README.md             # This file
├── src/                  # Source code
│   ├── cache/           # Core cache implementation
│   ├── network/         # TCP server and protocol
│   ├── cluster/         # Distributed components
│   └── utils/           # Utilities and helpers
├── tests/               # Unit and integration tests
├── scripts/             # Build and deployment scripts
└── docs/                # Documentation
```

### Building and Testing

```bash
# Compile the project
make compile

# Run tests
make test

# Clean build artifacts
make clean
```

### Debugging and Analysis

TempoDB includes comprehensive debugging tools:

```bash
# Debug build with sanitizers
make debug

# Memory leak detection with Valgrind
make valgrind

# Address sanitizer
make asan

# Thread sanitizer
make tsan
```

## API Documentation

TempoDB implements a Redis-compatible protocol. Here are the core operations:

### Basic Operations

- **SET key value [TTL seconds]**: Store a key-value pair
  - Optional TTL parameter for expiration
  - Returns: OK on success

- **GET key**: Retrieve a value by key
  - Returns: value or nil if not found/expired

- **DELETE key**: Remove a key-value pair
  - Returns: 1 if deleted, 0 if not found

### TTL Operations

- **TTL key seconds**: Set expiration time for a key
- **PTTL key milliseconds**: Set expiration in milliseconds
- **EXPIRE key seconds**: Set expiration from now
- **PEXPIRE key milliseconds**: Set expiration in milliseconds from now

### Configuration

- **CONFIG SET maxmemory bytes**: Set maximum memory usage
- **CONFIG SET maxmemory-policy policy**: Set eviction policy (LRU)
- **INFO**: Get server information and statistics

### Example Session

```bash
$ redis-cli -p 6379
127.0.0.1:6379> SET user:123 "John Doe"
OK
127.0.0.1:6379> GET user:123
"John Doe"
127.0.0.1:6379> TTL user:123 3600
OK
127.0.0.1:6379> GET user:123
"John Doe"
127.0.0.1:6379> DELETE user:123
(integer) 1
```

## Development Roadmap

### Week 1: Foundation (Complete)
- [ ] Project setup with Docker environment
- [ ] Basic hash table cache implementation
- [ ] LRU eviction policy
- [ ] TTL support with background cleanup

### Week 2: Network Layer
- [ ] TCP server implementation
- [ ] Redis-compatible protocol parsing
- [ ] Connection handling and pooling
- [ ] Basic client library

### Week 3: Distribution Basics
- [ ] Consistent hashing for sharding
- [ ] Simple node discovery
- [ ] Asynchronous replication
- [ ] Multi-node testing setup

### Week 4: Production Readiness
- [ ] Monitoring and metrics
- [ ] Health checks and failover
- [ ] Performance optimization
- [ ] Comprehensive testing

## Performance Targets

- **Latency**: <10ms for GET/SET operations
- **Throughput**: 100k+ requests per second
- **Data Scale**: Support for 1TB+ of cached data
- **Availability**: 99.9% uptime with replication

## Contributing

### Development Workflow

1. **Fork and Clone**:
   ```bash
   git clone https://github.com/your-username/TempoDB.git
   cd TempoDB
   ```

2. **Create Feature Branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Development**:
   ```bash
   make dev          # Start development container
   make shell        # Access container
   make compile      # Build changes
   make test         # Run tests
   ```

4. **Code Quality**:
   - Follow C++20 best practices
   - Add unit tests for new features
   - Update documentation
   - Run `make debug` to check for issues

5. **Submit PR**:
   - Ensure all tests pass
   - Update README if needed
   - Provide clear description of changes

### Code Standards

- **Language**: C++20 standard
- **Formatting**: clang-format (included in Docker environment)
- **Testing**: Google Test framework
- **Documentation**: Doxygen comments for public APIs
- **Error Handling**: Use exceptions for exceptional cases, return codes for expected failures

### Testing

```bash
# Run all tests
make test

# Run specific test
make shell
cd build && ctest -R TestName

# Debug test failures
make debug
cd build && gdb ./test_executable
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by Redis design and architecture
- Built using modern C++20 features
- Docker environment based on LLVM project tooling

## Contact

For questions, issues, or contributions:
- GitHub Issues: [https://github.com/j-ngo828/TempoDB/issues](https://github.com/j-ngo828/TempoDB/issues)
- Email: [your-email@example.com]

---

**TempoDB** - Fast, reliable, distributed caching for modern applications.
