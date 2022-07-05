project(obs-ffmpeg)

if(MSVC)
	set(obs-ffmpeg_PLATFORM_DEPS
		w32-pthreads)
endif()

option(ENABLE_FFMPEG_LOGGING "Enables obs-ffmpeg logging" OFF)

find_package(FFmpeg REQUIRED
	COMPONENTS avcodec avfilter avdevice avutil swscale avformat swresample)
include_directories(${FFMPEG_INCLUDE_DIRS})

configure_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/obs-ffmpeg-config.h.in"
	"${CMAKE_CURRENT_BINARY_DIR}/obs-ffmpeg-config.h")
include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(obs-ffmpeg_config_HEADERS
	"${CMAKE_CURRENT_BINARY_DIR}/obs-ffmpeg-config.h")

set(obs-ffmpeg_HEADERS
	obs-ffmpeg-formats.h
	obs-ffmpeg-compat.h
	closest-pixel-format.h)

set(obs-ffmpeg_SOURCES
	obs-ffmpeg.c
	obs-ffmpeg-audio-encoders.c
	obs-ffmpeg-nvenc.c
	obs-ffmpeg-output.c
	obs-ffmpeg-mux.c
	obs-ffmpeg-source.c)

if(UNIX AND NOT APPLE)
	list(APPEND obs-ffmpeg_SOURCES
		obs-ffmpeg-vaapi.c)
	LIST(APPEND obs-ffmpeg_PLATFORM_DEPS
		${LIBVA_LBRARIES})
endif()

if(ENABLE_FFMPEG_LOGGING)
	list(APPEND obs-ffmpeg_SOURCES
		obs-ffmpeg-logging.c)
endif()

if(WIN32)
	list(APPEND obs-ffmpeg_SOURCES
		jim-nvenc.c
		jim-nvenc-helpers.c)
	list(APPEND obs-ffmpeg_HEADERS
		jim-nvenc.h)
endif()

add_library(obs-ffmpeg MODULE
	${obs-ffmpeg_config_HEADERS}
	${obs-ffmpeg_HEADERS}
	${obs-ffmpeg_SOURCES})
target_link_libraries(obs-ffmpeg
	libobs
	media-playback
	${obs-ffmpeg_PLATFORM_DEPS}
	${FFMPEG_LIBRARIES})

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
	"obs-ffmpeg"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
	"com.obsproject.obs-ffmpeg"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
	"${MACOSX_BUNDLE_BUNDLE_VERSION}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
	"${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
	"obs-ffmpeg"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
	"BNDL"
	PARENT_SCOPE)

set_target_properties(
  obs-ffmpeg
  PROPERTIES BUNDLE ON
			 BUNDLE_EXTENSION "plugin"
			 OUTPUT_NAME "obs-ffmpeg"
			 XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
			 "com.obsproject.obs-ffmpeg"
			 XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
			 "${OBS_BUNDLE_CODESIGN_IDENTITY}"
			 XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
			 "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "obs-ffmpeg")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
	  message("zhongling123")
	  message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("obs-ffmpeg" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end

add_subdirectory(ffmpeg-mux)
