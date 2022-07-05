project(mac-syphon)

find_library(COCOA Cocoa)
find_library(IOSURF IOSurface)
find_library(SCRIPTINGBRIDGE ScriptingBridge)
find_package(OpenGL REQUIRED)

include_directories(${COCOA}
		    ${IOSURF}
		    ${SCRIPTINGBIRDGE}
		    ${OPENGL_INCLUDE_DIR})

set(syphon_HEADERS
	syphon-framework/Syphon_Prefix.pch
	syphon-framework/Syphon.h
	syphon-framework/SyphonBuildMacros.h
	syphon-framework/SyphonCFMessageReceiver.h
	syphon-framework/SyphonCFMessageSender.h
	syphon-framework/SyphonClient.h
	syphon-framework/SyphonClientConnectionManager.h
	syphon-framework/SyphonDispatch.h
	syphon-framework/SyphonIOSurfaceImage.h
	syphon-framework/SyphonImage.h
	syphon-framework/SyphonMachMessageReceiver.h
	syphon-framework/SyphonMachMessageSender.h
	syphon-framework/SyphonMessageQueue.h
	syphon-framework/SyphonMessageReceiver.h
	syphon-framework/SyphonMessageSender.h
	syphon-framework/SyphonMessaging.h
	syphon-framework/SyphonOpenGLFunctions.h
	syphon-framework/SyphonPrivate.h
	syphon-framework/SyphonServer.h
	syphon-framework/SyphonServerConnectionManager.h
	syphon-framework/SyphonServerDirectory.h
	)

set(syphon_SOURCES
	syphon-framework/SyphonCFMessageReceiver.m
	syphon-framework/SyphonCFMessageSender.m
	syphon-framework/SyphonClient.m
	syphon-framework/SyphonClientConnectionManager.m
	syphon-framework/SyphonDispatch.c
	syphon-framework/SyphonImage.m
	syphon-framework/SyphonIOSurfaceImage.m
	syphon-framework/SyphonMachMessageReceiver.m
	syphon-framework/SyphonMachMessageSender.m
	syphon-framework/SyphonMessageQueue.m
	syphon-framework/SyphonMessageReceiver.m
	syphon-framework/SyphonMessageSender.m
	syphon-framework/SyphonMessaging.m
	syphon-framework/SyphonOpenGLFunctions.c
	syphon-framework/SyphonPrivate.m
	syphon-framework/SyphonServer.m
	syphon-framework/SyphonServerConnectionManager.m
	syphon-framework/SyphonServerDirectory.m
	)

set(mac-syphon_HEADERS
	)

set(mac-syphon_SOURCES
	syphon.m
	plugin-main.c)

set_source_files_properties(${mac-syphon_SOURCES} ${syphon_SOURCES}
	PROPERTIES LANGUAGE C)

add_definitions(-DSYPHON_UNIQUE_CLASS_NAME_PREFIX=OBS_ -include
	${PROJECT_SOURCE_DIR}/syphon-framework/Syphon_Prefix.pch)

add_library(mac-syphon MODULE
	${mac-syphon_SOURCES}
	${mac-syphon_HEADERS}
	${syphon_HEADERS}
	${syphon_SOURCES})

target_link_libraries(mac-syphon
	libobs
	${COCOA}
	${IOSURF}
	${SCRIPTINGBRIDGE}
	${OPENGL_gl_LIBRARY})

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
	"mac-syphon"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
	"com.obsproject.mac-syphon"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
	"${MACOSX_BUNDLE_BUNDLE_VERSION}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
	"${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
	"mac-syphon"
	PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
	"BNDL"
	PARENT_SCOPE)

set_target_properties(
  mac-syphon
  PROPERTIES BUNDLE ON
			 BUNDLE_EXTENSION "plugin"
			 OUTPUT_NAME "mac-syphon"
			 XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
			 "com.obsproject.mac-syphon"
			 XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
			 "${OBS_BUNDLE_CODESIGN_IDENTITY}"
			 XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
			 "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "mac-syphon")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
	  message("zhongling123")
	  message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("mac-syphon" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end