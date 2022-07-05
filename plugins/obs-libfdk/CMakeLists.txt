project(obs-libfdk)

if(DISABLE_LIBFDK)
	message(STATUS "Libfdk support disabled")
	return()
endif()

find_package(Libfdk QUIET)
if(NOT LIBFDK_FOUND AND ENABLE_LIBFDK)
	message(FATAL_ERROR "Libfdk not found but set as enabled")
elseif(NOT LIBFDK_FOUND)
	message(STATUS "Libfdk not found - obs-libfdk plugin disabled")
	return()
endif()

include_directories(${LIBFDK_INCLUDE_DIRS})
add_definitions(${LIBFDK_DEFINITIONS})

set(obs-libfdk_SOURCES
	obs-libfdk.c)

add_library(obs-libfdk MODULE
	${obs-libfdk_SOURCES})
target_link_libraries(obs-libfdk
	libobs
	${LIBFDK_LIBRARIES})

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
	"obs-libfdk"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
	"com.obsproject.obs-libfdk"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
	"${MACOSX_BUNDLE_BUNDLE_VERSION}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
	"${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
	"obs-libfdk"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
	"BNDL"
	PARENT_SCOPE)

set_target_properties(
  obs-libfdk
  PROPERTIES BUNDLE ON
			 BUNDLE_EXTENSION "plugin"
			 OUTPUT_NAME "obs-libfdk"
			 XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
			 "com.obsproject.obs-libfdk"
			 XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
			 "${OBS_BUNDLE_CODESIGN_IDENTITY}"
			 XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
			 "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "obs-libfdk")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
	  message("zhongling123")
	  message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("obs-libfdk" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end
