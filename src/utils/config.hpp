#pragma once

#include <string>
#include <unordered_map>

namespace tempodb {

class Config {
 public:
  Config();
  bool load_from_file(const std::string& filename);
  std::string get(const std::string& key,
                  const std::string& default_value = "") const;
  void set(const std::string& key, const std::string& value);

 private:
  std::unordered_map<std::string, std::string> config_;
};

}  // namespace tempodb
