##
## Android.mk -Android build script-
##
##
## Copyright (C) 2013  Belledonne Communications, Grenoble, France
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
##

LOCAL_PATH:= $(call my-dir)/../../src
include $(CLEAR_VARS)

LOCAL_MODULE := libbellesip

LOCAL_CFLAGS += \
	-DHAVE_CONFIG_H \
	-DBELLESIP_VERSION=\"$(BELLESIP_VERSION)\"

LOCAL_C_INCLUDES += \
	$(LOCAL_PATH)/../../externals/antlr3/runtime/C/include \
	$(LOCAL_PATH)/../include \
	$(LOCAL_PATH)/../build/android 

LOCAL_SRC_FILES := \
	auth_event.c \
	auth_helper.c \
	belle_sdp_impl.c \
	http-listener.c \
	http-provider.c \
	http-message.c \
	generic-uri.c \
	belle_sip_headers_impl.c \
	belle_sip_loop.c \
	grammars/belle_sip_messageLexer.c \
	grammars/belle_sip_messageParser.c \
	grammars/belle_sdpLexer.c \
	grammars/belle_sdpParser.c \
	belle_sip_object.c \
	belle_sip_dict.c \
	belle_sip_parameters.c \
	belle_sip_resolver.c \
	belle_sip_uri_impl.c \
	belle_sip_utils.c \
	channel.c \
	clock_gettime.c \
	dialog.c \
	dns.c \
	ict.c \
	ist.c \
	listeningpoint.c \
	md5.c \
	message.c \
	nict.c \
	nist.c \
	port.c \
	provider.c \
	refresher.c \
	siplistener.c \
	sipstack.c \
	transaction.c \
	bodyhandler.c \
	transports/stream_channel.c \
	transports/stream_listeningpoint.c \
	transports/tls_channel_polarssl.c \
	transports/tls_listeningpoint_polarssl.c \
	transports/udp_channel.c \
	transports/udp_listeningpoint.c

ifeq ($(BUILD_TUNNEL), 1)
LOCAL_CFLAGS += -DHAVE_TUNNEL
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../tunnel/include
LOCAL_SRC_FILES += \
	transports/tunnel_listeningpoint.c \
	transports/tunnel_channel.c \
	transports/tunnel_wrapper.cc
endif

ifeq ($(BUILD_RTP_MAP),1)
LOCAL_CFLAGS += -DBELLE_SDP_FORCE_RTP_MAP
endif

ifeq ($(BUILD_DONT_CHECK_HEADERS_IN_MESSAGE),1)
LOCAL_CFLAGS += -DBELLE_SIP_DONT_CHECK_HEADERS_IN_MESSAGE
endif

LOCAL_STATIC_LIBRARIES := \
	antlr3 

ifeq ($(BUILD_TLS),1)
LOCAL_STATIC_LIBRARIES += polarssl
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../externals/polarssl/include
LOCAL_CFLAGS += -DHAVE_POLARSSL=1
endif

include $(BUILD_STATIC_LIBRARY)	
