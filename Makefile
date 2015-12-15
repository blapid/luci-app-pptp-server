#
# Copyright (C) 2008-2015 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-pptp-server

# Version == major.minor.patch
# increase on new functionality (minor) or patches (patch)
PKG_VERSION:=0.1

# Release == build
# increase on changes of translation files
PKG_RELEASE:=1

PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=Ben Lapid <ben.lapid@gmail.com>

# LuCI specific settings
LUCI_TITLE:=LuCI GUI For PPTP Server
LUCI_DEPENDS:=+pptpd +kmod-mppe +ppp
LUCI_PKGARCH:=all
# call BuildPackage - OpenWrt buildroot signature

#
# Copyright (C) 2009
#
# This is free software, licensed under the Apache License, Version 2.0 .
#


include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=admin
  CATEGORY:=services
  SUBMENU:=PPTP Server
  TITLE:=$(LUCI_TITLE)
  DEPENDS:=
endef

define Package/$(PKG_NAME)/description
  $(LUCI_TITLE)
endef

define Build/Prepare
	for d in luasrc htdocs root; do \
	  if [ -d ./$$$$d ]; then \
	    mkdir -p $(PKG_BUILD_DIR)/$$$$d; \
		$(CP) ./$$$$d/* $(PKG_BUILD_DIR)/$$$$d/; \
	  fi; \
	done
endef

define Build/Configure
endef

define Build/Compile
endef

HTDOCS = /www
LUA_LIBRARYDIR = /usr/lib/lua
LUCI_LIBRARYDIR = $(LUA_LIBRARYDIR)/luci

define Package/$(PKG_NAME)/install
	if [ -d $(PKG_BUILD_DIR)/luasrc ]; then \
	  $(INSTALL_DIR) $(1)$(LUCI_LIBRARYDIR); \
	  cp -pR $(PKG_BUILD_DIR)/luasrc/* $(1)$(LUCI_LIBRARYDIR)/; \
	else true; fi
	if [ -d $(PKG_BUILD_DIR)/htdocs ]; then \
	  $(INSTALL_DIR) $(1)$(HTDOCS); \
	  cp -pR $(PKG_BUILD_DIR)/htdocs/* $(1)$(HTDOCS)/; \
	else true; fi
	if [ -d $(PKG_BUILD_DIR)/root ]; then \
	  $(INSTALL_DIR) $(1)/; \
	  cp -pR $(PKG_BUILD_DIR)/root/* $(1)/; \
	else true; fi
endef

$(eval $(call BuildPackage,$(PKG_NAME)))


