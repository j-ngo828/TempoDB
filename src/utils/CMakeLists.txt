add_library(tempodb-utils
    logger.cpp
    config.cpp
    hash.cpp
)

target_include_directories(tempodb-utils
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../..>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(tempodb-utils
    PUBLIC
        Threads::Threads
)
