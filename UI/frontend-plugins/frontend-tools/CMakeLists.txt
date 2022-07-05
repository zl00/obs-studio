project(frontend-tools)

if(APPLE)
	find_library(COCOA Cocoa)
	include_directories(${COCOA})
endif()

if(UNIX AND NOT APPLE)
	find_package(X11 REQUIRED)
	link_libraries(${X11_LIBRARIES})
	include_directories(${X11_INCLUDE_DIR})
endif()

include_directories(SYSTEM "${CMAKE_SOURCE_DIR}/deps/obs-scripting")

configure_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/frontend-tools-config.h.in"
	"${CMAKE_BINARY_DIR}/config/frontend-tools-config.h")

set(frontend-tools_HEADERS
	${frontend-tools_HEADERS}
	"${CMAKE_BINARY_DIR}/config/frontend-tools-config.h"
	auto-scene-switcher.hpp
	output-timer.hpp
	tool-helpers.hpp
	../../properties-view.hpp
	../../properties-view.moc.hpp
	../../horizontal-scroll-area.hpp
	../../vertical-scroll-area.hpp
	../../double-slider.hpp
	../../slider-ignorewheel.hpp
	../../combobox-ignorewheel.hpp
	../../spinbox-ignorewheel.hpp
	)
set(frontend-tools_SOURCES
	${frontend-tools_SOURCES}
	auto-scene-switcher.cpp
	frontend-tools.c
	output-timer.cpp
	../../properties-view.cpp
	../../horizontal-scroll-area.cpp
	../../vertical-scroll-area.cpp
	../../double-slider.cpp
	../../slider-ignorewheel.cpp
	../../combobox-ignorewheel.cpp
	../../spinbox-ignorewheel.cpp
	)
set(frontend-tools_UI
	${frontend-tools_UI}
	forms/auto-scene-switcher.ui
	forms/output-timer.ui
	)

if(SCRIPTING_ENABLED)
	set(frontend-tools_HEADERS
		${frontend-tools_HEADERS}
		scripts.hpp
		)
	set(frontend-tools_SOURCES
		${frontend-tools_SOURCES}
		scripts.cpp
		)
	set(frontend-tools_UI
		${frontend-tools_UI}
		forms/scripts.ui
		)
	set(EXTRA_LIBS
		${EXTRA_LIBS}
		obs-scripting
		)
endif()

if(WIN32)
	set(frontend-tools_PLATFORM_SOURCES
		auto-scene-switcher-win.cpp)

	if(BUILD_CAPTIONS)
		set(frontend-tools_PLATFORM_SOURCES
			${frontend-tools_PLATFORM_SOURCES}
			captions.cpp
			captions-handler.cpp
			captions-mssapi.cpp
			captions-mssapi-stream.cpp)
		set(frontend-tools_PLATFORM_HEADERS
			captions.hpp
			captions-handler.hpp
			captions-mssapi.hpp
			captions-mssapi-stream.hpp)
		set(frontend-tools_PLATFORM_UI
			forms/captions.ui)
	endif()
elseif(APPLE)
	set(frontend-tools_PLATFORM_SOURCES
		auto-scene-switcher-osx.mm)
	set_source_files_properties(auto-scene-switcher-osx.mm
		PROPERTIES COMPILE_FLAGS "-fobjc-arc")

	set(frontend-tools_PLATFORM_LIBS
		${COCOA})
else()
	set(frontend-tools_PLATFORM_SOURCES
		auto-scene-switcher-nix.cpp)
endif()

qt5_wrap_ui(frontend-tools_UI_HEADERS
	${frontend-tools_UI}
	${frontend-tools_PLATFORM_UI})

add_library(frontend-tools MODULE
	${frontend-tools_HEADERS}
	${frontend-tools_SOURCES}
	${frontend-tools_UI_HEADERS}
	${frontend-tools_PLATFORM_SOURCES}
	${frontend-tools_PLATFORM_HEADERS}
	)
target_link_libraries(frontend-tools
	${frontend-tools_PLATFORM_LIBS}
	${EXTRA_LIBS}
	obs-frontend-api
	Qt5::Widgets
	libobs)

# - Linda: Add start
set(MACOSX_PLUGIN_BUNDLE_NAME
    "frontend-tools"
    PARENT_SCOPE)
set(MACOSX_PLUGIN_GUI_IDENTIFIER
    "com.obsproject.frontend-tools"
    PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_VERSION
    "${MACOSX_BUNDLE_BUNDLE_VERSION}"
    PARENT_SCOPE)
set(MACOSX_PLUGIN_SHORT_VERSION_STRING
    "${MACOSX_BUNDLE_SHORT_VERSION_STRING}"
    PARENT_SCOPE)
set(MACOSX_PLUGIN_EXECUTABLE_NAME
    "frontend-tools"
    PARENT_SCOPE)
set(MACOSX_PLUGIN_BUNDLE_TYPE
    "BNDL"
    PARENT_SCOPE)

set_target_properties(
  frontend-tools
  PROPERTIES BUNDLE ON
             BUNDLE_EXTENSION "plugin"
             OUTPUT_NAME "frontend-tools"
             XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
             "com.obsproject.frontend-tools"
             XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY
             "${OBS_BUNDLE_CODESIGN_IDENTITY}"
             XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
             "${CMAKE_SOURCE_DIR}/cmake/bundle/macOS/entitlements.plist")

set_property(GLOBAL APPEND PROPERTY OBS_MODULE_LIST "frontend-tools")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data")
    file(GLOB_RECURSE _DATA_FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/*")
    foreach(_DATA_FILE IN LISTS _DATA_FILES)
      file(RELATIVE_PATH _RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/data/
           ${_DATA_FILE})
      message("zhongling123")
      message(${_DATA_FILE})
      get_filename_component(_RELATIVE_PATH "${_RELATIVE_PATH}" PATH)
      target_sources("frontend-tools" PRIVATE ${_DATA_FILE})
      set_source_files_properties(
        ${_DATA_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION
                                 "Resources/${_RELATIVE_PATH}")
      string(REPLACE "\\" "\\\\" _GROUP_NAME "${_RELATIVE_PATH}")
      source_group("Resources\\${_GROUP_NAME}" FILES ${_DATA_FILE})
    endforeach()
  endif()

  # - Linda: Add end
