# TempoDB - Distributed Cache System
# Makefile for Docker-based development workflow

.PHONY: help build dev shell compile test clean debug valgrind asan tsan cluster-up cluster-down cluster-logs logs stop clean-all format lint

# Docker image name
IMAGE_NAME := tempodb-dev
CONTAINER_NAME := tempodb-dev-container
PORT := 6379

# Default target
help: ## Show this help message
	@echo "TempoDB Development Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

# Docker Development Environment
build: ## Build the Docker development image
	docker buildx build --platform=linux/arm64 -t $(IMAGE_NAME) .

dev: ## Start development container with volume mounts (detached)
	docker run -d --name $(CONTAINER_NAME) \
		-p $(PORT):$(PORT) \
		-v $(PWD):/workspace \
		-v /tmp/tempodb-build:/workspace/build \
		--workdir /workspace \
		$(IMAGE_NAME) \
		sleep infinity

shell: ## Access interactive shell in development container
	docker exec -it $(CONTAINER_NAME) bash

stop: ## Stop the development container
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true

logs: ## View container logs
	docker logs -f $(CONTAINER_NAME)

# Build and Compilation
compile: ## Compile the project inside container
	docker exec $(CONTAINER_NAME) bash -c "mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j$(nproc)"

compile-debug: ## Compile with debug symbols
	docker exec $(CONTAINER_NAME) bash -c "mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Debug && make -j$(nproc)"

# Testing
test: ## Run Google Test suite
	docker exec $(CONTAINER_NAME) bash -c "cd build && ctest --output-on-failure -j$(nproc)"

test-verbose: ## Run tests with verbose output
	docker exec $(CONTAINER_NAME) bash -c "cd build && ctest --output-on-failure -V"

# Debugging and Analysis Tools
debug: ## Start container with debugging tools (GDB, Valgrind, Sanitizers)
	docker exec -it $(CONTAINER_NAME) bash -c "apt-get update && apt-get install -y gdb valgrind clang-tools && bash"

valgrind: ## Run with Valgrind memory leak detection
	docker exec $(CONTAINER_NAME) bash -c "mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Debug && make -j$(nproc) && valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./tempodb-server --port $(PORT)"

asan: ## Compile and run with AddressSanitizer
	docker exec $(CONTAINER_NAME) bash -c "mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS='-fsanitize=address -fno-omit-frame-pointer' -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address' && make -j$(nproc) && ASAN_OPTIONS=detect_leaks=1 ./tempodb-server --port $(PORT)"

tsan: ## Compile and run with ThreadSanitizer
	docker exec $(CONTAINER_NAME) bash -c "mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS='-fsanitize=thread -fno-omit-frame-pointer' -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=thread' && make -j$(nproc) && ./tempodb-server --port $(PORT)"

ubsan: ## Compile and run with UndefinedBehaviorSanitizer
	docker exec $(CONTAINER_NAME) bash -c "mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS='-fsanitize=undefined -fno-omit-frame-pointer' -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=undefined' && make -j$(nproc) && ./tempodb-server --port $(PORT)"

# Code Quality
format: ## Format code using clang-format
	docker exec $(CONTAINER_NAME) bash -c "find src tests -name '*.cpp' -o -name '*.hpp' | xargs clang-format -i"

lint: ## Run clang-tidy for static analysis
	docker exec $(CONTAINER_NAME) bash -c "mkdir -p build && cd build && cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && make -j$(nproc) && clang-tidy -p . ../src/**/*.cpp ../tests/**/*.cpp"

# Multi-Node Testing (using Docker Compose)
cluster-up: ## Start multi-node cluster for testing
	docker-compose -f docker-compose.test.yml up -d

cluster-down: ## Stop multi-node cluster
	docker-compose -f docker-compose.test.yml down

cluster-logs: ## View cluster logs
	docker-compose -f docker-compose.test.yml logs -f

cluster-scale: ## Scale cluster to N nodes (usage: make cluster-scale N=3)
	docker-compose -f docker-compose.test.yml up -d --scale tempodb=$(N)

# Performance Testing
bench: ## Run performance benchmarks
	docker exec $(CONTAINER_NAME) bash -c "cd build && ./tempodb-bench --port $(PORT) --clients 50 --requests 10000"

bench-distributed: ## Run distributed performance benchmarks
	@echo "Starting distributed benchmark..."
	@make cluster-up
	@sleep 5
	docker exec tempodb-test_tempodb_1 bash -c "cd build && ./tempodb-bench --port $(PORT) --clients 100 --requests 50000 --distributed"
	@make cluster-down

# Cleanup
clean: ## Clean build artifacts inside container
	docker exec $(CONTAINER_NAME) bash -c "rm -rf build/*"

clean-all: ## Complete cleanup - stop containers and remove images
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true
	docker rmi $(IMAGE_NAME) || true
	docker system prune -f
	rm -rf /tmp/tempodb-build

# Development Utilities
deps: ## Install additional development dependencies
	docker exec $(CONTAINER_NAME) bash -c "apt-get update && apt-get install -y htop iotop strace tcpdump netcat-openbsd"

# Quick Development Workflow
setup: build dev ## Full setup: build image and start container
	@echo "Development environment ready!"
	@echo "Run 'make shell' to access the container"

run: compile ## Compile and run the server
	docker exec -it $(CONTAINER_NAME) bash -c "cd build && ./tempodb-server --port $(PORT)"

# CI/CD Simulation
ci: ## Simulate CI pipeline
	@echo "Running CI pipeline..."
	@make build
	@make dev
	@sleep 2
	@make compile
	@make test
	@make format
	@echo "CI pipeline completed successfully!"

# Information
info: ## Show development environment information
	@echo "TempoDB Development Environment"
	@echo "================================"
	@echo "Image: $(IMAGE_NAME)"
	@echo "Container: $(CONTAINER_NAME)"
	@echo "Port: $(PORT)"
	@echo "Source: $(PWD)"
	@echo "Build: /tmp/tempodb-build"
	@echo ""
	@echo "Container Status:"
	@docker ps -f name=$(CONTAINER_NAME) --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
	@echo ""
	@echo "Available commands: make help"

# Aliases for common commands
b: build
d: dev
s: shell
c: compile
t: test
r: run
