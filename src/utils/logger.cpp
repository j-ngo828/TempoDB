#include "src/utils/logger.hpp"

namespace tempodb {

LogLevel Logger::current_level_ = LogLevel::INFO;

void Logger::log(LogLevel level, const std::string& message) {
  // TODO: Implement logging with different levels
}

void Logger::set_log_level(LogLevel level) {
  // TODO: Implement log level setting
}

}  // namespace tempodb
