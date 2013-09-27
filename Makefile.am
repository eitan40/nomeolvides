## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = src po data
PREFIX=/usr

nomeolvidesdocdir = $(docdir)
nomeolvidesdoc_DATA = \
	README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS

EXTRA_DIST = $(nomeolvidesdoc_DATA) intltool-extract.in intltool-merge.in intltool-update.in


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(nomeolvidesdocdir)


AM_VALAFLAGS =--pkg sqlite3

