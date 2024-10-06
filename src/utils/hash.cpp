#include "src/utils/hash.hpp"

namespace tempodb {

uint64_t Hash::xxhash(const std::string& key) {
  // TODO: Implement xxHash algorithm
  return 0;
}

uint64_t Hash::xxhash(const void* data, size_t length) {
  // TODO: Implement xxHash for raw data
  return 0;
}

uint64_t Hash::hash_for_consistent_hashing(const std::string& key) {
  // TODO: Implement consistent hashing function
  return 0;
}

}  // namespace tempodb
