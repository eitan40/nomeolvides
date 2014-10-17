## Process this file with automake to produce Makefile.in

## Created by Anjuta

AM_CPPFLAGS = \
	-include config.h \
	$(NOMEOLVIDES_CFLAGS) \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\"

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = nomeolvides

nomeolvides_SOURCES = \
	config.vapi \
	nomeolvides-hecho.vala \
	nomeolvides-main.vala \
	nomeolvides-liststore-hechos.vala \
	nomeolvides-app.vala \
	nomeolvides-edit-hecho-dialog.vala \
	nomeolvides-datos.vala \
	nomeolvides-box-anios-hechos-vista.vala \
	nomeolvides-configuracion.vala \
	nomeolvides-archivo.vala \
	nomeolvides-box-vista-hecho.vala \
	nomeolvides-box-selector-fecha.vala \
	nomeolvides-file-chooser-dialog-savefile-dialog.vala \
	nomeolvides-application-window-ventana-principal.vala \
	nomeolvides-dialog-borrar-hecho-dialogo.vala \
	nomeolvides-dialog-dialogo-hecho.vala \
	nomeolvides-file-chooser-dialog-open-file-dialog.vala \
	nomeolvides-treeview-listas.vala \
	nomeolvides-liststore-listas.vala \
	nomeolvides-lista.vala \
	nomeolvides-dialog-borrar-lista-dialog.vala \
	nomeolvides-add-lista-dialog.vala \
	nomeolvides-dialog-lista.vala \
	nomeolvides-edit-lista-dialog.vala \
	nomeolvides-deshacer.vala \
	nomeolvides-deshacer-item.vala \
	nomeolvides-coleccion.vala \
	nomeolvides-add-hecho-lista-dialog.vala \
	nomeolvides-borrar-hecho-lista-dialog.vala \
	nomeolvides-base-de-datos.vala \
	nomeolvides-sqlite.vala \
	nomeolvides-acciones-db.vala \
	nomeolvides-liststore-colecciones.vala \
	nomeolvides-treeview-colecciones.vala \
	nomeolvides-dialog-borrar-coleccion-dialogo.vala \
	nomeolvides-edit-coleccion-dialog.vala \
	nomeolvides-dialog-coleccion.vala \
	nomeolvides-dialog-migrador.vala \
	nomeolvides-importar-hechos.vala \
	nomeolvides-box-colecciones-config.vala \
	nomeolvides-box-listas-config.vala \
	nomeolvides-resources.c \
	nomeolvides-box-toolbar.vala \
	nomeolvides-button-nmo-button.vala \
	nomeolvides-box-headerbar.vala \
	nomeolvides-liststore-anios.vala \
	nomeolvides-treeview-nmobase.vala \
	nomeolvides-nmobase.vala \
	nomeolvides-liststore-nmobase.vala \
	nomeolvides-utiles.vala \
	nomeolvides-treeview-hechos.vala \
	nomeolvides-treeview-anios.vala \
	nomeolvides-dialog-preferencias.vala \
	nomeolvides-dialog-coleccion-agregar.vala \
	nomeolvides-dialog-hecho-agregar.vala


nomeolvides-resources.c: nomeolvides.gresource.xml
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) $(srcdir)/nomeolvides.gresource.xml \
	--target=$@ --sourcedir=$(srcdir) --c-name nomeolvides --generate-source

if DISABLE_GNOME3
nomeolvides_VALAFLAGS = \
	--pkg sqlite3 \
	--pkg gtk+-3.0 \
	-g \
	-D DISABLE_GNOME3
else
nomeolvides_VALAFLAGS = \
	--pkg sqlite3 \
	--pkg gtk+-3.0 \
	-g
endif

nomeolvides_LDFLAGS = \
	-Wl,--export-dynamic

nomeolvides_LDADD = $(NOMEOLVIDES_LIBS)


EXTRA_DIST = 	$(ui_DATA) \
		app-menu.ui

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

CLEANFILES = \
	$(vala_sources:.vala=.c)
clean-local:
	-rm *.c
