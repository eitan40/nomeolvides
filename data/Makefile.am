NULL=

desktopdir = $(datadir)/applications
desktop_in_files = nomeolvides-beta.desktop.in
desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)

@INTLTOOL_DESKTOP_RULE@

@INTLTOOL_XML_RULE@

appdatadir = $(datadir)/appdata
appdata_in_files = nomeolvides-beta.appdata.xml.in
appdata_DATA = $(appdata_in_files:.xml.in=.xml)

appicondir=$(datadir)/icons/hicolor/scalable/apps
appicon_DATA=nomeolvides-beta.svg

EXTRA_DIST = \
	     $(desktop_in_files) \
	     $(appicon_DATA) \
	     $(appdata_DATA)
	     $(NULL)

DISTCLEANFILES = \
	$(desktop_DATA) \
	$(desktop_in_files) \
	$(NULL)
