add_library(tempodb-client
    tempodb_client.cpp
)

target_include_directories(tempodb-client
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../..>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(tempodb-client
    PUBLIC
        tempodb-network
        tempodb-cluster
        tempodb-utils
        Threads::Threads
)
