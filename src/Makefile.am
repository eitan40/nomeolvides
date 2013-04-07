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
	nomeolvides-main-toolbar.vala \
	nomeolvides-text-view-hecho.vala \
	nomeolvides-hecho.vala \
	nomeolvides-main.vala \
	nomeolvides-panel.vala \
	nomeolvides-lista-hechos.vala \
	nomeolvides-liststore-hechos.vala \
	nomeolvides-dialogo-hecho.vala \
	nomeolvides-openfile-dialog.vala \
	nomeolvides-borrar-hecho-dialogo.vala \
	nomeolvides-hechos-fuentes.vala \
	nomeolvides-fuente.vala \
	nomeolvides-liststore-fuentes.vala \
	nomeolvides-treeview-fuentes.vala \
	nomeolvides-fuentes-dialog.vala \
	nomeolvides-add-hecho-dialog.vala \
	nomeolvides-app.vala \
	nomeolvides-edit-hecho-dialog.vala \
	nomeolvides-add-fuente-dialog.vala \
	nomeolvides-borrar-fuente-dialogo.vala \
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
	nomeolvides-application-window-ventana-principal.vala


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

