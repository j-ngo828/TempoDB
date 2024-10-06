#pragma once

#include <cstdint>
#include <string>

namespace tempodb {

class Hash {
 public:
  // xxHash for fast, high-quality hashing
  static uint64_t xxhash(const std::string& key);
  static uint64_t xxhash(const void* data, size_t length);

  // Consistent hashing for distribution
  static uint64_t hash_for_consistent_hashing(const std::string& key);
};

}  // namespace tempodb
