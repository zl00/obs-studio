project(coreaudio-encoder)

set(coreaudio-encoder_SOURCES
	encoder.cpp)

if (WIN32)
	set(coreaudio-encoder_HEADERS windows-imports.h)
	set(coreaudio-encoder_LIBS )

	if (MINGW)
		set_source_files_properties(${coreaudio-encoder_SOURCES}
			PROPERTIES COMPILE_FLAGS "-Wno-multichar")
	endif()
else()
	find_library(COREFOUNDATION CoreFoundation)
	find_library(COREAUDIO CoreAudio)
	find_library(AUDIOTOOLBOX AudioToolbox)
	set(coreaudio-encoder_HEADERS )
	set(coreaudio-encoder_LIBS
		${COREFOUNDATION}
		${COREAUDIO}
		${AUDIOTOOLBOX})

	include_directories(${COREFOUNDATION}
		${COREAUDIO}
		${AUDIOTOOLBOX})
endif()

add_library(coreaudio-encoder MODULE
	${coreaudio-encoder_SOURCES}
	${coreaudio-encoder_HEADERS})

target_link_libraries(coreaudio-encoder
	libobs
	${coreaudio-encoder_LIBS})

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
	"coreaudio-encoder"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
	"com.obsproject.coreaudio-encoder"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
	"${MACOSX_BUNDLE_BUNDLE_VERSION}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
	"${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
	"coreaudio-encoder"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
	"BNDL"
	PARENT_SCOPE)

set_target_properties(
  coreaudio-encoder
  PROPERTIES BUNDLE ON
			 BUNDLE_EXTENSION "plugin"
			 OUTPUT_NAME "coreaudio-encoder"
			 XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
			 "com.obsproject.coreaudio-encoder"
			 XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
			 "${OBS_BUNDLE_CODESIGN_IDENTITY}"
			 XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
			 "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "coreaudio-encoder")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
	  message("zhongling123")
	  message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("coreaudio-encoder" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end