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
	nomeolvides-datos.vala \
	nomeolvides-configuracion.vala \
	nomeolvides-archivo.vala \
	nomeolvides-treeview-listas.vala \
	nomeolvides-liststore-listas.vala \
	nomeolvides-lista.vala \
	nomeolvides-dialog-lista.vala \
	nomeolvides-deshacer.vala \
	nomeolvides-deshacer-item.vala \
	nomeolvides-coleccion.vala \
	nomeolvides-base-de-datos.vala \
	nomeolvides-sqlite.vala \
	nomeolvides-acciones-db.vala \
	nomeolvides-liststore-colecciones.vala \
	nomeolvides-treeview-colecciones.vala \
	nomeolvides-dialog-coleccion.vala \
	nomeolvides-dialog-migrador.vala \
	nomeolvides-importar-hechos.vala \
	nomeolvides-resources.c \
	nomeolvides-liststore-anios.vala \
	nomeolvides-utiles.vala \
	nomeolvides-treeview-hechos.vala \
	nomeolvides-treeview-anios.vala \
	nomeolvides-dialog-preferencias.vala \
	nomeolvides-dialog-coleccion-agregar.vala \
	nomeolvides-dialog-hecho-agregar.vala \
	nomeolvides-dialog-hecho.vala \
	nomeolvides-dialog-hecho-editar.vala \
	nomeolvides-dialog-hecho-lista-agregar.vala \
	nomeolvides-dialog-lista-agregar.vala \
	nomeolvides-dialog-hecho-lista-borrar.vala \
	nomeolvides-dialog-coleccion-borrar.vala \
	nomeolvides-dialog-lista-borrar.vala \
	nomeolvides-dialog-coleccion-editar.vala \
	nomeolvides-dialog-lista-editar.vala \
	nomeolvides-dialog-hecho-borrar.vala \
	nomeolvides-headerbar.vala \
	nomeolvides-toolbar.vala \
	nomeolvides-selector-fecha.vala \
	nomeolvides-base.vala \
	nomeolvides-boton.vala \
	nomeolvides-interfaz-principal.vala \
	nomeolvides-colecciones-preferencias.vala \
	nomeolvides-listas-preferencias.vala \
	nomeolvides-ventana-principal.vala \
	nomeolvides-dialog-archivo-abrir.vala \
	nomeolvides-dialog-archivo-guardar.vala \
	nomeolvides-treeview-base.vala \
	nomeolvides-liststore-base.vala \
	nomeolvides-portada.vala \
	nomeolvides-dialog-base-borrar.vala \
	nomeolvides-dialog-base.vala \
	nomeolvides-preferencias-base.vala



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
