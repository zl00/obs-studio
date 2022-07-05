project(win-capture)

set(win-capture_HEADERS
	nt-stuff.h
	obfuscate.h
	app-helpers.h
	hook-helpers.h
	inject-library.h
	cursor-capture.h
	graphics-hook-info.h
	window-helpers.h
	dc-capture.h)

set(win-capture_SOURCES
	dc-capture.c
	obfuscate.c
	app-helpers.c
	inject-library.c
	cursor-capture.c
	game-capture.c
	window-helpers.c
	monitor-capture.c
	window-capture.c
	load-graphics-offsets.c
	duplicator-monitor-capture.c
	plugin-main.c)

add_library(win-capture MODULE
	${win-capture_SOURCES}
	${win-capture_HEADERS})
target_link_libraries(win-capture
	libobs
	ipc-util
	psapi)

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
	"win-capture"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
	"com.obsproject.win-capture"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
	"${MACOSX_BUNDLE_BUNDLE_VERSION}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
	"${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
	"win-capture"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
	"BNDL"
	PARENT_SCOPE)

set_target_properties(
  win-capture
  PROPERTIES BUNDLE ON
			 BUNDLE_EXTENSION "plugin"
			 OUTPUT_NAME "win-capture"
			 XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
			 "com.obsproject.win-capture"
			 XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
			 "${OBS_BUNDLE_CODESIGN_IDENTITY}"
			 XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
			 "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "win-capture")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
	  message("zhongling123")
	  message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("win-capture" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end

add_subdirectory(graphics-hook)
add_subdirectory(get-graphics-offsets)
add_subdirectory(inject-helper)
