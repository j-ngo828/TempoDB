add_library(tempodb-cluster
    consistent_hash.cpp
    cluster_manager.cpp
    replication.cpp
)

target_include_directories(tempodb-cluster
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../..>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(tempodb-cluster
    PUBLIC
        tempodb-core
        tempodb-network
        tempodb-utils
        Threads::Threads
)
