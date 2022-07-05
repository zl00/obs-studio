project(text-freetype2)

if(DISABLE_FREETYPE)
	message(STATUS "Freetype text plugin disabled")
	return()
endif()

find_package(Freetype QUIET)
if(NOT FREETYPE_FOUND AND ENABLE_FREETYPE)
	message(FATAL_ERROR "Freetype library not found but set as enabled")
elseif(NOT FREETYPE_FOUND)
	message(STATUS "Freetype library not found, Freetype text plugin disabled")
	return()
endif()

if(WIN32)
	set(text-freetype2_PLATFORM_SOURCES
		find-font.c
		find-font-windows.c)
elseif(APPLE)
	find_package(Iconv QUIET)
	if(NOT ICONV_FOUND AND ENABLE_FREETYPE)
		message(FATAL_ERROR "Iconv library not found but plugin set as enabled")
	elseif(NOT ICONV_FOUND)
		message(STATUS "Iconv library not found, Freetype text plugin disabled")
		return()
	endif()

	find_library(COCOA Cocoa)

	set(text-freetype2_PLATFORM_SOURCES
		find-font.c
		find-font-cocoa.m
		find-font-iconv.c)

	include_directories(${COCOA}
		${ICONV_INCLUDE_DIRS})

	set(text-freetype2_PLATFORM_DEPS
		${COCOA}
		${ICONV_LIBRARIES})

	set_source_files_properties(find-font-cocoa.m
		PROPERTIES LANGUAGE C)
else()
	find_package(Fontconfig QUIET)
	if(NOT FONTCONFIG_FOUND AND ENABLE_FREETYPE)
		message(FATAL_ERROR "fontconfig not found but plugin set as enabled")
	elseif(NOT FONTCONFIG_FOUND)
		message(STATUS "fontconfig not found, Freetype text plugin disabled")
		return()
	endif()

	set(text-freetype2_PLATFORM_SOURCES
		find-font-unix.c)

	include_directories(${FONTCONFIG_INCLUDE_DIRS})
endif()

include_directories(${FREETYPE_INCLUDE_DIRS})

set(text-freetype2_SOURCES
	find-font.h
	obs-convenience.c
	text-functionality.c
	text-freetype2.c
	obs-convenience.h
	text-freetype2.h)

add_library(text-freetype2 MODULE
	${text-freetype2_PLATFORM_SOURCES}
	${text-freetype2_SOURCES})
target_link_libraries(text-freetype2
	libobs
	${text-freetype2_PLATFORM_DEPS}
	${FREETYPE_LIBRARIES})

if(NOT WIN32)
	if(FONTCONFIG_FOUND)
		target_link_libraries(text-freetype2 ${FONTCONFIG_LIBRARIES})
	endif()
endif()

if(APPLE AND ICONV_FOUND)
	target_link_libraries(text-freetype2 ${ICONV_LIBRARIES})
endif()

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
	"text-freetype2"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
	"com.obsproject.text-freetype2"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
	"${MACOSX_BUNDLE_BUNDLE_VERSION}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
	"${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
	"text-freetype2"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
	"BNDL"
	PARENT_SCOPE)

set_target_properties(
  text-freetype2
  PROPERTIES BUNDLE ON
			 BUNDLE_EXTENSION "plugin"
			 OUTPUT_NAME "text-freetype2"
			 XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
			 "com.obsproject.text-freetype2"
			 XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
			 "${OBS_BUNDLE_CODESIGN_IDENTITY}"
			 XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
			 "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "text-freetype2")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
	  message("zhongling123")
	  message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("text-freetype2" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end
