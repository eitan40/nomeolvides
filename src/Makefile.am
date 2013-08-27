## Process this file with automake to produce Makefile.in

## Created by Anjuta


uidir = $(pkgdatadir)/ui


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(NOMEOLVIDES_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = nomeolvides

nomeolvides_SOURCES = \
	config.vapi \
	nomeolvides-text-view-hecho.vala \
	nomeolvides-hecho.vala \
	nomeolvides-main.vala \
	nomeolvides-panel.vala \
	nomeolvides-lista-hechos.vala \
	nomeolvides-liststore-hechos.vala \
	nomeolvides-add-hecho-dialog.vala \
	nomeolvides-app.vala \
	nomeolvides-edit-hecho-dialog.vala \
	nomeolvides-datos.vala \
	nomeolvides-box-anios-hechos-vista.vala \
	nomeolvides-configuracion.vala \
	nomeolvides-box-descripcion-hecho.vala \
	nomeolvides-archivo.vala \
	nomeolvides-treeview-view-anios.vala \
	nomeolvides-treeview-view-hechos.vala \
	nomeolvides-box-vista-hecho.vala \
	nomeolvides-box-selector-fecha.vala \
	nomeolvides-file-chooser-dialog-savefile-dialog.vala \
	nomeolvides-application-window-ventana-principal.vala \
	nomeolvides-dialog-borrar-hecho-dialogo.vala \
	nomeolvides-dialog-dialogo-hecho.vala \
	nomeolvides-tooblar-main-toolbar.vala \
	nomeolvides-file-chooser-dialog-open-file-dialog.vala \
	nomeolvides-dialog-listas-dialog.vala \
	nomeolvides-treeview-listas.vala \
	nomeolvides-liststore-listas.vala \
	nomeolvides-lista.vala \
	nomeolvides-dialog-borrar-lista-dialog.vala \
	nomeolvides-add-lista-dialog.vala \
	nomeolvides-dialog-lista.vala \
	nomeolvides-edit-lista-dialog.vala \
	nomeolvides-listas.vala \
	nomeolvides-deshacer.vala \
	nomeolvides-deshacer-item.vala \
	nomeolvides-hechos.vala \
	nomeolvides-coleccion.vala \
	nomeolvides-add-hecho-lista-dialog.vala \
	nomeolvides-borrar-hecho-lista-dialog.vala \
	nomeolvides-base-de-datos.vala \
	nomeolvides-sqlite.vala \
	nomeolvides-acciones-db.vala \
	nomeolvides-mapa-hecho.vala \
	nomeolvides-liststore-colecciones.vala \
	nomeolvides-treeview-colecciones.vala \
	nomeolvides-add-coleccion-dialog.vala \
	nomeolvides-dialog-borrar-coleccion-dialogo.vala \
	nomeolvides-edit-coleccion-dialog.vala \
	nomeolvides-dialog-coleccion.vala \
	nomeolvides-dialog-colecciones-dialog.vala \
	nomeolvides-hechos-colecciones.vala


nomeolvides_VALAFLAGS = \
	--pkg sqlite3 \
	--pkg gee-0.8 \
	--pkg gtk+-3.0 -g
	-g

nomeolvides_LDFLAGS = \
	-Wl,--export-dynamic

nomeolvides_LDADD = $(NOMEOLVIDES_LIBS)


EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

