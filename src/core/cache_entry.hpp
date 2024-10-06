#pragma once

#include <chrono>
#include <list>
#include <string>

namespace tempodb {

class CacheEntry {
 public:
  CacheEntry(const std::string& value,
             std::chrono::seconds ttl = std::chrono::seconds(0));

  bool is_expired() const;
  const std::string& get_value() const { return value_; }
  void update_value(const std::string& value);
  void set_lru_iterator(std::list<std::string>::iterator it) {
    lru_iterator_ = it;
  }
  std::list<std::string>::iterator get_lru_iterator() const {
    return lru_iterator_;
  }

 private:
  std::string value_;
  std::chrono::steady_clock::time_point expiry_time_;
  std::list<std::string>::iterator lru_iterator_;
  bool has_ttl_;
};

}  // namespace tempodb
