add_library(tempodb-network
    protocol.cpp
    server.cpp
    connection.cpp
)

target_include_directories(tempodb-network
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../..>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(tempodb-network
    PUBLIC
        tempodb-core
        tempodb-utils
        Threads::Threads
)
