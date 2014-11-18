/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2014 Andres Fernandez <andres@softwareperonista.com.ar>
 *
 * nomeolvides is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * nomeolvides is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.PanelConfiguracion : Gtk.Box {
	protected TreeViewNmoBase treeview { get; protected set; }
	protected ScrolledWindow scroll_view;
	protected Toolbar toolbar;
	protected AccionesDB db;
	protected Deshacer<NmoBase> deshacer;
	protected DialogNmoBase agregar_dialog;
	protected DialogNmoBase editar_dialog;
	protected DialogNmoBaseBorrar borrar_dialog;

	public PanelConfiguracion () {
		this.set_orientation ( Orientation.VERTICAL );

		this.db = new AccionesDB ( Configuracion.base_de_datos() );
		this.deshacer = new Deshacer<NmoBase> ();

		this.toolbar = new Toolbar ();

		this.scroll_view = new ScrolledWindow (null,null);
		this.scroll_view.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);

		this.pack_start ( toolbar, false, false, 0 );
		this.show_all ();
	}

	public void actualizar_model ( ListStoreNmoBase liststore ) {
		this.treeview.set_model ( liststore );
	}

	protected void conectar_signals () {
		this.toolbar.add_button.clicked.connect ( this.add_dialog );
		this.toolbar.delete_button.clicked.connect ( this.delete_dialog );
		this.toolbar.edit_button.clicked.connect ( this.edit_dialog );
		this.toolbar.undo_button.clicked.connect ( this.deshacer_cambios );
		this.toolbar.redo_button.clicked.connect ( this.rehacer_cambios );

		this.deshacer.deshacer_sin_items.connect ( this.toolbar.desactivar_deshacer );
		this.deshacer.deshacer_con_items.connect ( this.toolbar.activar_deshacer );
		this.deshacer.rehacer_sin_items.connect ( this.toolbar.desactivar_rehacer );
		this.deshacer.rehacer_con_items.connect ( this.toolbar.activar_rehacer );
		this.treeview.cursor_changed.connect ( elegir );
	}

	protected virtual void add_dialog () {
		this.agregar_dialog.show_all ();

		if ( agregar_dialog.run() == ResponseType.APPLY ) {
			this.agregar ( agregar_dialog.respuesta );
		}
		this.agregar_dialog.borrar_datos ();
		this.agregar_dialog.hide ();
	}

	public virtual void edit_dialog () {
		NmoBase objeto = this.treeview.get_elemento ();
		this.editar_dialog.set_datos ( objeto );
		this.editar_dialog.show_all ();

		if (this.editar_dialog.run() == ResponseType.APPLY) {
			if ( this.actualizar ( objeto, this.editar_dialog.respuesta ) ) {
				this.cambio_signal ();
			}
		}
		this.editar_dialog.borrar_datos ();
		this.editar_dialog.hide ();
	}

	private void delete_dialog () {
		NmoBase objeto = this.treeview.get_elemento ();
		this.borrar_dialog.set_datos ( objeto, this.treeview.get_cantidad_hechos () );
		this.borrar_dialog.show_all ();

		if ( this.borrar_dialog.run() == ResponseType.APPLY ) {
			this.borrar ( objeto );
			this.cambio_signal ();
		}
		borrar_dialog.hide ();
	}

	private void elegir () {
		if( this.treeview.get_selection ().count_selected_rows () > -1 ) {
			this.toolbar.set_buttons_visible ();
		} else {
			this.toolbar.set_buttons_invisible ();
		}
	}

	void deshacer_cambios () {
		DeshacerItem<NmoBase> item;
		bool hay_colecciones_deshacer = this.deshacer.deshacer ( out item );
		if ( hay_colecciones_deshacer ){
			this.cambio_signal ();
		}
	}

	public void rehacer_cambios () {
		DeshacerItem<NmoBase> item;

		bool hay_colecciones_rehacer = this.deshacer.rehacer ( out item );
		if ( hay_colecciones_rehacer ){
			this.cambio_signal ();
		}
	}

	public void set_buttons_invisible () {
		this.toolbar.set_buttons_invisible ();
	}

	protected virtual bool agregar ( NmoBase objeto ) {
		return false;
	}

	protected virtual bool actualizar ( NmoBase objeto_viejo, NmoBase objeto_nuevo ) {
		return false;
	}

	protected virtual void borrar ( NmoBase objeto ) {}

	public signal void cambio_signal ();
}

