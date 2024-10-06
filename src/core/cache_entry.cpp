#include "src/core/cache_entry.hpp"

namespace tempodb {

CacheEntry::CacheEntry(const std::string& value, std::chrono::seconds ttl)
    : value_(value), has_ttl_(ttl.count() > 0) {
  // TODO: Implement CacheEntry constructor
}

bool CacheEntry::is_expired() const {
  // TODO: Implement is_expired method
  return false;
}

void CacheEntry::update_value(const std::string& value) {
  value_ = value;
  // TODO: Implement update_value method
}

}  // namespace tempodb
