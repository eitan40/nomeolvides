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
	nomeolvides-hechos-fuentes.vala \
	nomeolvides-fuente.vala \
	nomeolvides-liststore-fuentes.vala \
	nomeolvides-treeview-fuentes.vala \
	nomeolvides-add-hecho-dialog.vala \
	nomeolvides-app.vala \
	nomeolvides-edit-hecho-dialog.vala \
	nomeolvides-add-fuente-dialog.vala \
	nomeolvides-edit-fuente-dialog.vala \
	nomeolvides-datos.vala \
	nomeolvides-box-anios-hechos-vista.vala \
	nomeolvides-configuracion.vala \
	nomeolvides-box-descripcion-hecho.vala \
	nomeolvides-archivo.vala \
	nomeolvides-dialog-fuente.vala \
	nomeolvides-treeview-view-anios.vala \
	nomeolvides-treeview-view-hechos.vala \
	nomeolvides-box-vista-hecho.vala \
	nomeolvides-box-selector-fecha.vala \
	nomeolvides-file-chooser-dialog-savefile-dialog.vala \
	nomeolvides-application-window-ventana-principal.vala \
	nomeolvides-dialog-borrar-fuente-dialogo.vala \
	nomeolvides-dialog-borrar-hecho-dialogo.vala \
	nomeolvides-dialog-dialogo-hecho.vala \
	nomeolvides-dialog-fuentes-dialog.vala \
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
	nomeolvides-listas.vala


nomeolvides_VALAFLAGS = \
	--pkg gee-1.0 \
	--pkg gtk+-3.0 -g

nomeolvides_LDFLAGS = \
	-Wl,--export-dynamic

nomeolvides_LDADD = $(NOMEOLVIDES_LIBS)


EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

