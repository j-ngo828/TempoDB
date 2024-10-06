add_library(tempodb-core
    cache_entry.cpp
    lru_cache.cpp
)

target_include_directories(tempodb-core
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../..>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(tempodb-core
    PUBLIC
        tempodb-utils
        Threads::Threads
)
