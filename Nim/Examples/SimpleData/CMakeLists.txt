file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/main.qml DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
add_nim_executable(TARGET SimpleData SOURCES main.nim PATHS ../../NimQml)