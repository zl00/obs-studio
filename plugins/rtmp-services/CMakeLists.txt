project(rtmp-services)

include_directories(${OBS_JANSSON_INCLUDE_DIRS})

set(rtmp-services_SOURCES
	twitch.c
	rtmp-common.c
	rtmp-custom.c
	rtmp-services-main.c)

set(rtmp-services_HEADERS
	twitch.h
	rtmp-format-ver.h)

set(RTMP_SERVICES_URL
	"https://obsproject.com/obs2_update/rtmp-services"
	CACHE STRING "Default services package URL")
option(CHECK_FOR_SERVICE_UPDATES "Checks for service updates" OFF)

configure_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/lookup-config.h.in"
	"${CMAKE_BINARY_DIR}/plugins/rtmp-services/lookup-config.h")

set(rtmp-services_config_HEADERS
	"${CMAKE_BINARY_DIR}/plugins/rtmp-services/lookup-config.h")

add_library(rtmp-services MODULE
	${rtmp-services_SOURCES}
	${rtmp-services_HEADERS}
	${rtmp-services_config_HEADERS})
target_link_libraries(rtmp-services
	libobs
	file-updater
	${OBS_JANSSON_IMPORT})

target_include_directories(rtmp-services
	PUBLIC
		"$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/plugins/rtmp-services>")

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
	"rtmp-services"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
	"com.obsproject.rtmp-services"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
	"${MACOSX_BUNDLE_BUNDLE_VERSION}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
	"${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
	"rtmp-services"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
	"BNDL"
	PARENT_SCOPE)

set_target_properties(
  rtmp-services
  PROPERTIES BUNDLE ON
			 BUNDLE_EXTENSION "plugin"
			 OUTPUT_NAME "rtmp-services"
			 XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
			 "com.obsproject.rtmp-services"
			 XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
			 "${OBS_BUNDLE_CODESIGN_IDENTITY}"
			 XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
			 "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "rtmp-services")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
	  message("zhongling123")
	  message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("rtmp-services" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end
