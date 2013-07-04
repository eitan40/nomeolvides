## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = src 
PREFIX=/usr

nomeolvidesdocdir = $(docdir)
nomeolvidesdoc_DATA = \
	README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS


EXTRA_DIST = $(nomeolvidesdoc_DATA)


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(nomeolvidesdocdir)


AM_VALAFLAGS = --pkg \
	gee-0.8 \
	--pkg \
	sqlite3 

nomeolvidesdesktofiledir = $(datadir)/applications
nomeolvidesdesktofile_DATA = data/nomeolvides.desktop

nomeolvidesicondir = $(datadir)/pixmaps/
nomeolvidesicon_DATA = data/nomeolvides.svg
