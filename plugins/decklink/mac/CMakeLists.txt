project(mac-decklink)

if(DISABLE_DECKLINK)
	message(STATUS "decklink plugin disabled")
	return()
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}")

find_library(COREFOUNDATION CoreFoundation)

set(mac-decklink-sdk_HEADERS
	decklink-sdk/DeckLinkAPI.h
	decklink-sdk/DeckLinkAPIConfiguration.h
	decklink-sdk/DeckLinkAPIDeckControl.h
	decklink-sdk/DeckLinkAPIDiscovery.h
	decklink-sdk/DeckLinkAPIModes.h
	decklink-sdk/DeckLinkAPIStreaming.h
	decklink-sdk/DeckLinkAPITypes.h
	decklink-sdk/DeckLinkAPIVersion.h)

set(mac-decklink-sdk_SOURCES
	decklink-sdk/DeckLinkAPIDispatch.cpp
	)

set(mac-decklink_HEADERS
	../decklink-devices.hpp
	../const.h
	../DecklinkOutput.hpp
	../platform.hpp
	../DecklinkInput.hpp
	../DecklinkBase.h
	../decklink-device-instance.hpp
	../decklink-device-discovery.hpp
	../decklink-device.hpp
	../decklink-device-mode.hpp
	../audio-repack.h
	../audio-repack.hpp
	../util.hpp
	)

set(mac-decklink_SOURCES
	../plugin-main.cpp
	../decklink-devices.cpp
	../decklink-output.cpp
	../decklink-source.cpp
	../DecklinkOutput.cpp
	../DecklinkInput.cpp
	../DecklinkBase.cpp
	../decklink-device-instance.cpp
	../decklink-device-discovery.cpp
	../decklink-device.cpp
	../decklink-device-mode.cpp
	../audio-repack.c
	platform.cpp
	../util.cpp
	)

list(APPEND decklink_HEADERS ${decklink_UI_HEADERS})

include_directories(
	${COREFOUNDATION}
	"${CMAKE_SOURCE_DIR}/UI/obs-frontend-api")

list(APPEND mac-decklink_HEADERS ${decklink_UI_HEADERS})

add_library(mac-decklink MODULE
	${mac-decklink_SOURCES}
	${mac-decklink_HEADERS}
	${mac-decklink-sdk_HEADERS}
	${mac-decklink-sdk_SOURCES}
	)

target_link_libraries(mac-decklink
	libobs
	${COREFOUNDATION})

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
    "mac-decklink"
    PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
    "com.obsproject.mac-decklink"
    PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
    "${MACOSX_BUNDLE_BUNDLE_VERSION}"
    PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
    "${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
    PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
    "mac-decklink"
    PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
    "BNDL"
    PARENT_SCOPE)

set_target_properties(
  mac-decklink
  PROPERTIES BUNDLE ON
             BUNDLE_EXTENSION "plugin"
             OUTPUT_NAME "mac-decklink"
             XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
             "com.obsproject.mac-decklink"
             XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
             "${OBS_BUNDLE_CODESIGN_IDENTITY}"
             XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
             "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "mac-decklink")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
      message("zhongling123")
      message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("mac-decklink" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end

