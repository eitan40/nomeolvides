NULL=

desktopdir = $(datadir)/applications
desktop_in_files = nomeolvides.desktop.in
desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)

@INTLTOOL_DESKTOP_RULE@

appicondir=$(datadir)/icons/hicolor/scalable/apps
appicon_DATA=nomeolvides.svg

EXTRA_DIST = \
	     nomeolvides.desktop.in \
	     $(nomeolvidesicon_DATA) \
	     $(NULL)

DISTCLEANFILES = \
	nomeolvides.desktop \
	nomeolvides.desktop.in
