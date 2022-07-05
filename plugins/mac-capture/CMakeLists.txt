project(mac-capture)

find_library(COREAUDIO CoreAudio)
find_library(AUDIOUNIT AudioUnit)
find_library(COREFOUNDATION CoreFoundation)
find_library(IOSURF IOSurface)
find_library(COCOA Cocoa)

include_directories(${COREAUDIO}
                    ${AUDIOUNIT}
                    ${COREFOUNDATION}
		    ${IOSURF}
		    ${COCOA})

set(mac-capture_HEADERS
	audio-device-enum.h
	window-utils.h)

set(mac-capture_SOURCES
	plugin-main.c
	audio-device-enum.c
	mac-audio.c
	mac-display-capture.m
	mac-window-capture.m
	window-utils.m)
	
set_source_files_properties(mac-display-capture.m
			    mac-window-capture.m
			    window-utils.m
	PROPERTIES LANGUAGE C)

add_library(mac-capture MODULE
	${mac-capture_SOURCES}
	${mac-capture_HEADERS})
target_link_libraries(mac-capture
	libobs
	${COREAUDIO}
	${AUDIOUNIT}
	${COREFOUNDATION}
	${IOSURF}
	${COCOA})


# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
"mac-capture"
PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
"com.obsproject.mac-capture"
PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
"${MACOSX_BUNDLE_BUNDLE_VERSION}"
PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
"${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
"mac-capture"
PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
"BNDL"
PARENT_SCOPE)

set_target_properties(
mac-capture
PROPERTIES BUNDLE ON
		 BUNDLE_EXTENSION "plugin"
		 OUTPUT_NAME "mac-capture"
		 XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
		 "com.obsproject.mac-capture"
		 XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
		 "${OBS_BUNDLE_CODESIGN_IDENTITY}"
		 XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
		 "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "mac-capture")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
foreach(_DATA_FILE IN LISTS _DATA_FILES)
  file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
	   ${_DATA_FILE})
  message("zhongling123")
  message(${_DATA_FILE})
  get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
  target_sources("mac-capture" PRIVATE ${_DATA_FILE})
  set_source_files_properties(
	${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
							 "Resources/${_RELATIVE_PATH}")
  string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
  source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
endforeach()
endif()

# - Linda: Add end
