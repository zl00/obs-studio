project(mac-vth264)

find_library(AVFOUNDATION AVFoundation)
find_library(COCOA Cocoa)
find_library(COREFOUNDATION CoreFoundation)
find_library(COREVIDEO CoreVideo)
find_library(VIDEOTOOLBOX VideoToolbox)
find_library(COREMEDIA CoreMedia)

include_directories(${AVFOUNDATION}
	${COCOA}
	${COREFOUNDATION}
	${COREVIDEO}
	${VIDEOTOOLBOX}
	${COREMEDIA})

set(mac-vth264_SOURCES
	encoder.c)

add_library(mac-vth264 MODULE
	${mac-vth264_SOURCES})

target_link_libraries(mac-vth264
	libobs
	${AVFOUNDATION}
	${COCOA}
	${COREFOUNDATION}
	${COREVIDEO}
	${VIDEOTOOLBOX}
	${COREMEDIA})

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
	"mac-vth264"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
	"com.obsproject.mac-vth264"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
	"${MACOSX_BUNDLE_BUNDLE_VERSION}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
	"${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
	"mac-vth264"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
	"BNDL"
	PARENT_SCOPE)

set_target_properties(
  mac-vth264
  PROPERTIES BUNDLE ON
			 BUNDLE_EXTENSION "plugin"
			 OUTPUT_NAME "mac-vth264"
			 XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
			 "com.obsproject.mac-vth264"
			 XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
			 "${OBS_BUNDLE_CODESIGN_IDENTITY}"
			 XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
			 "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "mac-vth264")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
	  message("zhongling123")
	  message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("mac-vth264" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end
