#include <chrono>
#include <iostream>
#include <string>
#include <thread>

#include "src/core/lru_cache.hpp"
#include "src/utils/logger.hpp"

int main(int argc, char* argv[]) {
  tempodb::Logger::set_log_level(tempodb::LogLevel::INFO);
  tempodb::Logger::log(tempodb::LogLevel::INFO, "Starting TempoDB server...");

  // Create cache with capacity of 1000 entries
  tempodb::LRUCache cache(1000);

  // Basic functionality test
  std::string value;

  // Test SET and GET
  cache.set("key1", "value1");
  if (cache.get("key1", value)) {
    tempodb::Logger::log(tempodb::LogLevel::INFO, "GET key1: " + value);
  }

  // Test TTL
  cache.set("key2", "value2", std::chrono::seconds(2));
  if (cache.get("key2", value)) {
    tempodb::Logger::log(tempodb::LogLevel::INFO, "GET key2: " + value);
  }

  // Wait for TTL to expire
  std::this_thread::sleep_for(std::chrono::seconds(3));

  if (!cache.get("key2", value)) {
    tempodb::Logger::log(tempodb::LogLevel::INFO, "key2 expired as expected");
  }

  // Test LRU eviction
  for (int i = 0; i < 1100; ++i) {
    cache.set("key" + std::to_string(i), "value" + std::to_string(i));
  }

  tempodb::Logger::log(
      tempodb::LogLevel::INFO,
      "Cache size after LRU test: " + std::to_string(cache.size()));

  tempodb::Logger::log(tempodb::LogLevel::INFO,
                       "TempoDB core functionality test completed!");
  return 0;
}
