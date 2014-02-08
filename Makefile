#
# Simple makefile for the sample loadable builtins
#
# Copyright (C) 1996-2009 Free Software Foundation, Inc.     

#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Include some boilerplate Gnu makefile definitions.
prefix = ${DESTDIR}/usr

exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin
libdir = ${exec_prefix}/lib
infodir = /usr/share/info
includedir = ${prefix}/include

datarootdir = ${prefix}/share

# topdir = ../../../bash
# BUILD_DIR = /tmp/buildd/bash-4.2+dfsg/build-bash
# srcdir = ../../../bash/examples/loadables
# VPATH = .:../../../bash/examples/loadables


CC = gcc
RM = rm -f

SHELL = /bin/sh

# host_os = linux-gnu
# host_cpu = x86_64
# host_vendor = pc

CFLAGS = -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wall
LOCAL_CFLAGS = 
DEFS = -DHAVE_CONFIG_H
LOCAL_DEFS = -DSHELL

CPPFLAGS = -D_FORTIFY_SOURCE=2

BASHINCDIR = ${includedir}/bash

# LIBBUILD = ${BUILD_DIR}/lib

# INTL_LIBSRC = ${topdir}/lib/intl
# INTL_BUILDDIR = ${LIBBUILD}/intl
# INTL_INC = 
# LIBINTL_H = 

CCFLAGS = $(DEFS) $(LOCAL_DEFS) $(LOCAL_CFLAGS) $(CFLAGS)

#
# These values are generated for configure by ${topdir}/support/shobj-conf.
# If your system is not supported by that script, but includes facilities for
# dynamic loading of shared objects, please update the script and send the
# changes to bash-maintainers@gnu.org.
#
SHOBJ_CC = gcc
SHOBJ_CFLAGS = -fPIC
SHOBJ_LD = ${CC}
SHOBJ_LDFLAGS = -shared -Wl,-soname,$@ -Wl,-z,relro
SHOBJ_XLDFLAGS = 
SHOBJ_LIBS = 
SHOBJ_STATUS = supported

INC = -I. -I.. -I$(topdir) -I$(topdir)/lib -I$(topdir)/builtins \
      -I$(BASHINCDIR) -I$(BUILD_DIR) -I$(LIBBUILD) \
      -I$(BASHINCDIR)/builtins -I$(BASHINCDIR)/lib $(INTL_INC)

.c.o:
	$(SHOBJ_CC) $(SHOBJ_CFLAGS) $(CCFLAGS) $(INC) -c -o $@ $<


ALLPROG = tildeexp

all:	$(SHOBJ_STATUS)

supported:	$(ALLPROG)
others:		$(OTHERPROG)

unsupported:
	@echo "Your system (${host_os}) is not supported by the"
	@echo "${topdir}/support/shobj-conf script."
	@echo "If your operating system provides facilities for dynamic"
	@echo "loading of shared objects using the dlopen(3) interface,"
	@echo "please update the script and re-run configure.
	@echo "Please send the changes you made to bash-maintainers@gnu.org"
	@echo "for inclusion in future bash releases."

everything: supported others

tildeexp: tildeexp.o
	$(SHOBJ_LD) $(SHOBJ_LDFLAGS) $(SHOBJ_XLDFLAGS) -o $@ $< $(SHOBJ_LIBS)

clean:
	$(RM) $(ALLPROG) $(OTHERPROG) *.o

distclean maintainer-clean: clean
	$(RM) Makefile
