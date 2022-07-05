project(obs-filters)

option(DISABLE_SPEEXDSP "Disable building of the SpeexDSP-based Noise Suppression filter" OFF)

if(DISABLE_SPEEXDSP)
	message(STATUS "SpeexDSP support disabled")
	set(LIBSPEEXDSP_FOUND FALSE)
else()
	find_package(Libspeexdsp QUIET)

	if(NOT LIBSPEEXDSP_FOUND)
		message(STATUS "SpeexDSP support not found")
		set(LIBSPEEXDSP_FOUND FALSE)
	else()
		message(STATUS "SpeexDSP supported")
		set(obs-filters_LIBSPEEXDSP_SOURCES
			noise-suppress-filter.c)
		set(obs-filters_LIBSPEEXDSP_LIBRARIES
			${LIBSPEEXDSP_LIBRARIES})
	endif()
endif()

configure_file("${CMAKE_CURRENT_SOURCE_DIR}/obs-filters-config.h.in"
	"${CMAKE_BINARY_DIR}/plugins/obs-filters/config/obs-filters-config.h")

set(obs-filters_config_HEADERS
	"${CMAKE_BINARY_DIR}/plugins/obs-filters/config/obs-filters-config.h")
include_directories(${LIBSPEEXDSP_INCLUDE_DIRS}
	"${CMAKE_BINARY_DIR}/plugins/obs-filters/config")

if(MSVC)
	set(obs-filters_PLATFORM_DEPS
		w32-pthreads)
endif()

set(obs-filters_SOURCES
	obs-filters.c
	color-correction-filter.c
	async-delay-filter.c
	gpu-delay.c
	crop-filter.c
	scale-filter.c
	scroll-filter.c
	chroma-key-filter.c
	color-key-filter.c
	color-grade-filter.c
	sharpness-filter.c
	gain-filter.c
	noise-gate-filter.c
	mask-filter.c
	invert-audio-polarity.c
	compressor-filter.c
	limiter-filter.c
	expander-filter.c
	luma-key-filter.c)

add_library(obs-filters MODULE
	${obs-filters_SOURCES}
	${obs-filters_config_HEADERS}
	${obs-filters_LIBSPEEXDSP_SOURCES})
target_link_libraries(obs-filters
	libobs
	${obs-filters_PLATFORM_DEPS}
	${obs-filters_LIBSPEEXDSP_LIBRARIES})

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
	"obs-filters"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
	"com.obsproject.obs-filters"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
	"${MACOSX_BUNDLE_BUNDLE_VERSION}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
	"${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
	"obs-filters"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
	"BNDL"
	PARENT_SCOPE)

set_target_properties(
  obs-filters
  PROPERTIES BUNDLE ON
			 BUNDLE_EXTENSION "plugin"
			 OUTPUT_NAME "obs-filters"
			 XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
			 "com.obsproject.obs-filters"
			 XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
			 "${OBS_BUNDLE_CODESIGN_IDENTITY}"
			 XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
			 "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "obs-filters")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
	  message("zhongling123")
	  message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("obs-filters" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end
