#pragma once

#include <iostream>
#include <string>

namespace tempodb {

enum class LogLevel { DEBUG, INFO, WARN, ERROR };

class Logger {
 public:
  static void log(LogLevel level, const std::string& message);
  static void set_log_level(LogLevel level);

 private:
  static LogLevel current_level_;
};

}  // namespace tempodb
