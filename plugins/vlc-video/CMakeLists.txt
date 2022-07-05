project(vlc-video)

if(DISABLE_VLC)
	message(STATUS "VLC video plugin disabled")
	return()
endif()

find_package(LibVLC QUIET)

if(NOT LIBVLC_INCLUDES_FOUND AND ENABLE_VLC)
	message(FATAL_ERROR "LibVLC includes not found but set as enabled")
elseif(NOT LIBVLC_INCLUDES_FOUND)
	message(STATUS "LibVLC includes not found, VLC video plugin disabled")
	return()
endif()

include_directories(${LIBVLC_INCLUDE_DIRS})
add_definitions(${LIBVLC_DEFINITIONS})

if(MSVC)
	set(vlc-video_PLATFORM_DEPS
		w32-pthreads)
endif()

set(vlc-video_HEADERS
	vlc-video-plugin.h
	)

set(vlc-video_SOURCES
	vlc-video-plugin.c
	vlc-video-source.c
	)

add_library(vlc-video MODULE
	${vlc-video_SOURCES}
	${vlc-video_HEADERS})
target_link_libraries(vlc-video
	libobs
	${vlc-video_PLATFORM_DEPS})

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
	"vlc-video"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
	"com.obsproject.vlc-video"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
	"${MACOSX_BUNDLE_BUNDLE_VERSION}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
	"${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
	"vlc-video"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
	"BNDL"
	PARENT_SCOPE)

set_target_properties(
  vlc-video
  PROPERTIES BUNDLE ON
			 BUNDLE_EXTENSION "plugin"
			 OUTPUT_NAME "vlc-video"
			 XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
			 "com.obsproject.vlc-video"
			 XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
			 "${OBS_BUNDLE_CODESIGN_IDENTITY}"
			 XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
			 "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "vlc-video")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
	  message("zhongling123")
	  message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("vlc-video" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end
