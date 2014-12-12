## Process this file with automake to produce Makefile.in
## Created by Anjuta

ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}

SUBDIRS = src po data
PREFIX=/usr

nomeolvides_betadocdir = $(docdir)-beta
nomeolvides_betadoc_DATA = \
	README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS

EXTRA_DIST = $(nomeolvides_betadoc_DATA) intltool-extract.in intltool-merge.in intltool-update.in


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(nomeolvides_betadocdir)


AM_VALAFLAGS =--pkg sqlite3 -v
