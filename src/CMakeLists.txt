add_subdirectory(core)
add_subdirectory(network)
add_subdirectory(cluster)
add_subdirectory(client)
add_subdirectory(utils)

# Main server executable
add_executable(tempodb-server main.cpp)
target_link_libraries(tempodb-server
    PRIVATE
        tempodb-core
        tempodb-network
        tempodb-cluster
        tempodb-utils
        Threads::Threads
)

# Client library
add_library(tempodb-client-lib STATIC)
target_link_libraries(tempodb-client-lib
    PUBLIC
        tempodb-client
        tempodb-network
        tempodb-cluster
        tempodb-utils
)

# Install targets
install(TARGETS tempodb-server tempodb-client-lib
    EXPORT TempoDBTargets
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)
