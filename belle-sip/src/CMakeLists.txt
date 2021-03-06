############################################################################
# CMakeLists.txt
# Copyright (C) 2014  Belledonne Communications, Grenoble France
#
############################################################################
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
############################################################################

set(INCLUDES ${ANTLR3C_INCLUDE_DIR})
set(LIBS ${ANTLR3C_LIBRARIES})

if(${Threads_FOUND})
	if(CMAKE_USE_PTHREADS_INIT AND NOT CMAKE_SYSTEM_NAME MATCHES "QNX")
		list(APPEND LIBS pthread)
	endif(CMAKE_USE_PTHREADS_INIT AND NOT CMAKE_SYSTEM_NAME MATCHES "QNX")
endif(${Threads_FOUND})
if(${HAVE_LIBDL})
	list(APPEND LIBS dl)
endif(${HAVE_LIBDL})
if(${HAVE_LIBRT})
	list(APPEND LIBS rt)
endif()
if(${HAVE_RESINIT})
	list(APPEND LIBS resolv)
endif(${HAVE_RESINIT})
if(WIN32)
	list(APPEND LIBS ws2_32)
endif(WIN32)

set(SDP_GENERATED_SOURCE_FILES
	${CMAKE_CURRENT_BINARY_DIR}/grammars/belle_sdpLexer.c
	${CMAKE_CURRENT_BINARY_DIR}/grammars/belle_sdpLexer.h
	${CMAKE_CURRENT_BINARY_DIR}/grammars/belle_sdpParser.c
	${CMAKE_CURRENT_BINARY_DIR}/grammars/belle_sdpParser.h
)
add_custom_command(
	OUTPUT ${SDP_GENERATED_SOURCE_FILES}
	COMMAND ${ANTLR3_COMMAND} -make -Xmultithreaded -fo ${CMAKE_CURRENT_BINARY_DIR}/grammars ${CMAKE_CURRENT_SOURCE_DIR}/grammars/belle_sdp.g
	DEPENDS grammars/belle_sdp.g
)

set(SIP_MESSAGE_GENERATED_SOURCE_FILES
	${CMAKE_CURRENT_BINARY_DIR}/grammars/belle_sip_messageLexer.c
	${CMAKE_CURRENT_BINARY_DIR}/grammars/belle_sip_messageLexer.h
	${CMAKE_CURRENT_BINARY_DIR}/grammars/belle_sip_messageParser.c
	${CMAKE_CURRENT_BINARY_DIR}/grammars/belle_sip_messageParser.h
)
add_custom_command(
	OUTPUT ${SIP_MESSAGE_GENERATED_SOURCE_FILES}
	COMMAND ${ANTLR3_COMMAND} -make -Xmultithreaded -fo ${CMAKE_CURRENT_BINARY_DIR}/grammars ${CMAKE_CURRENT_SOURCE_DIR}/grammars/belle_sip_message.g
	DEPENDS grammars/belle_sip_message.g
)

set_source_files_properties(${GRAMMARS_SOURCE_FILES} ${SIP_MESSAGE_GENERATED_SOURCE_FILES} PROPERTIES GENERATED TRUE)

if(${ENABLE_TLS})
	set(TLS_SOURCE_FILES
		transports/tls_listeningpoint_polarssl.c
		transports/tls_channel_polarssl.c
	)
	list(APPEND INCLUDES ${POLARSSL_INCLUDE_DIR})
	list(APPEND LIBS ${POLARSSL_LIBRARIES})
endif(${ENABLE_TLS})

if(${ENABLE_TUNNEL})
	set(TUNNEL_SOURCE_FILES
		transports/tunnel_listeningpoint.c
		transports/tunnel_channel.c
		transports/tunnel_wrapper.cc
	)
	set_source_files_properties(transports/tunnel_wrapper.cc PROPERTIES LANGUAGE CXX)
	list(APPEND LIBS ${TUNNEL_LIBRARIES})
endif(${ENABLE_TUNNEL})

set(SOURCE_FILES
	auth_event.c
	auth_helper.c
	belle_sdp_impl.c
	belle_sip_dict.c
	belle_sip_headers_impl.c
	belle_sip_internal.h
	belle_sip_loop.c
	belle_sip_object.c
	belle_sip_parameters.c
	belle_sip_resolver.c
	belle_sip_uri_impl.c
	belle_sip_utils.c
	bodyhandler.c
	channel.c
	channel.h
	clock_gettime.c
	clock_gettime.h
	dialog.c
	dns.c
	dns.h
	generic-uri.c
	http-listener.c
	http-message.c
	http-provider.c
	ict.c
	ist.c
	listeningpoint.c
	listeningpoint_internal.h
	md5.c
	md5.h
	message.c
	nict.c
	nist.c
	parserutils.h
	port.c
	port.h
	provider.c
	refresher.c
	siplistener.c
	sipstack.c
	transaction.c
	transports/stream_channel.c
	transports/stream_channel.h
	transports/stream_listeningpoint.c
	transports/udp_channel.c
	transports/udp_listeningpoint.c
	${SDP_GENERATED_SOURCE_FILES}
	${SIP_MESSAGE_GENERATED_SOURCE_FILES}
	${TLS_SOURCE_FILES}
	${TUNNEL_SOURCE_FILES}
)

if(${ENABLE_STATIC})
	add_library(bellesip STATIC ${SOURCE_FILES})
else(${ENABLE_STATIC})
	add_library(bellesip SHARED ${SOURCE_FILES})
	set_target_properties(bellesip PROPERTIES VERSION ${PACKAGE_VERSION} SOVERSION 0)
	if(MSVC)
		if(CMAKE_BUILD_TYPE STREQUAL "Debug")
			install(FILES ${CMAKE_CURRENT_BINARY_DIR}/Debug/bellesip.pdb
				DESTINATION bin
				PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
			)
		endif()
	endif(MSVC)
endif(${ENABLE_STATIC})
set_target_properties(bellesip PROPERTIES LINKER_LANGUAGE CXX LINK_FLAGS "${LINK_FLAGS}")
if("${CMAKE_VERSION}" VERSION_GREATER "2.8.10")
	target_include_directories(bellesip PUBLIC ${INCLUDES})
else("${CMAKE_VERSION}" VERSION_GREATER "2.8.10")
	include_directories(${INCLUDES})
endif("${CMAKE_VERSION}" VERSION_GREATER "2.8.10")
target_link_libraries(bellesip ${LIBS})

install(TARGETS bellesip
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
	PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
)
