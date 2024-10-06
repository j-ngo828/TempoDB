#pragma once

#include <atomic>
#include <condition_variable>
#include <list>
#include <shared_mutex>
#include <thread>
#include <unordered_map>

#include "src/core/cache_entry.hpp"

namespace tempodb {

class LRUCache {
 public:
  explicit LRUCache(size_t capacity);
  ~LRUCache();

  // Core operations
  bool get(const std::string& key, std::string& value);
  void set(const std::string& key, const std::string& value,
           std::chrono::seconds ttl = std::chrono::seconds(0));
  bool remove(const std::string& key);

  // Utility functions
  size_t size() const;
  size_t capacity() const { return max_capacity_; }
  void clear();

 private:
  // Data structures
  std::unordered_map<std::string, CacheEntry> cache_;
  std::list<std::string> lru_list_;  // Most recent at front
  size_t max_capacity_;

  // Thread safety
  mutable std::shared_mutex cache_mutex_;

  // Background cleanup
  std::thread cleanup_thread_;
  std::atomic<bool> stop_cleanup_;
  mutable std::mutex cleanup_mutex_;
  std::condition_variable cleanup_cv_;

  // Helper methods
  void cleanup_expired_entries();
  void evict_lru();
  void move_to_front(const std::string& key);
};

}  // namespace tempodb
