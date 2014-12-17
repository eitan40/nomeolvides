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
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.PreferenciasBase : Gtk.Box {
	protected TreeViewBase treeview { get; protected set; }
	protected ScrolledWindow scroll_view;
	protected Nomeolvides.Toolbar toolbar;
	protected AccionesDB db;
	protected Deshacer<Base> deshacer;
	protected DialogBase agregar_dialog;
	protected DialogBase editar_dialog;
	protected DialogBaseBorrar borrar_dialog;

	public PreferenciasBase () {
		this.set_orientation ( Orientation.VERTICAL );

		this.db = new AccionesDB ( Configuracion.base_de_datos() );
		this.deshacer = new Deshacer<Base> ();

		this.toolbar = new Nomeolvides.Toolbar ();
		this.toolbar.set_border_width ( 1 );

#if DISABLE_GNOME3
#else
		this.toolbar.set_show_close_button ( false );
#endif

		this.scroll_view = new ScrolledWindow (null,null);
		this.scroll_view.set_policy ( PolicyType.NEVER, PolicyType.AUTOMATIC );
		this.scroll_view.set_border_width ( 1 );

		this.pack_start ( toolbar, false, false, 0 );
		this.show_all ();
	}

	public void actualizar_model ( ListStoreBase liststore ) {
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
		this.treeview.cursor_changed.connect ( this.elegir );
	#if DISABLE_GNOME3
	#else
		this.agregar_dialog.signal_agregar.connect ( this.agregar );
		this.editar_dialog.signal_actualizar.connect ( this.actualizar );
	#endif
	}

	protected virtual void add_dialog () {
		this.agregar_dialog.show_all ();
	#if DISABLE_GNOME3
		if ( agregar_dialog.run() == ResponseType.APPLY ) {
 			this.agregar ( agregar_dialog.respuesta );
		}
	#endif
		this.agregar_dialog.borrar_datos ();
	}

	public virtual void edit_dialog () {
		Base objeto = this.treeview.get_elemento ();
		this.editar_dialog.set_datos ( objeto );
		this.editar_dialog.show_all ();

	#if DISABLE_GNOME3
		if (this.editar_dialog.run() == ResponseType.APPLY) {
			if ( this.actualizar ( objeto, this.editar_dialog.respuesta ) ) {
				this.cambio_signal ();
			}
		}
	#endif
	}

	private void delete_dialog () {
		Base objeto = this.treeview.get_elemento ();
		this.borrar_dialog.set_datos ( objeto, this.treeview.get_cantidad_hechos () );
		this.borrar_dialog.show_all ();

		if ( this.borrar_dialog.run() == ResponseType.APPLY ) {
			this.borrar ( objeto );
			this.cambio_signal ();
		}
		this.borrar_dialog.hide();
	}

	protected virtual void elegir () {
		if( this.treeview.get_selection ().count_selected_rows () > -1 ) {
			this.toolbar.set_buttons_visible ();
		} else {
			this.toolbar.set_buttons_invisible ();
		}
	}

	void deshacer_cambios () {
		DeshacerItem<Base> item;
		bool hay_colecciones_deshacer = this.deshacer.deshacer ( out item );
		if ( hay_colecciones_deshacer ){
			this.efectuar_deshacer ( item.get_borrado () );
			this.cambio_signal ();
		}
	}

	public void rehacer_cambios () {
		DeshacerItem<Base> item;

		bool hay_colecciones_rehacer = this.deshacer.rehacer ( out item );
		if ( hay_colecciones_rehacer ){
			this.efectuar_rehacer ( item.get_borrado () );
			this.cambio_signal ();
		}
	}

	public void set_buttons_invisible () {
		this.toolbar.set_buttons_invisible ();
	}

	protected virtual bool agregar ( Base objeto ) {
		return false;
	}

	protected virtual bool actualizar ( Base objeto_viejo, Base objeto_nuevo ) {
		return false;
	}

	protected virtual void borrar ( Base objeto ) {}
	protected virtual void efectuar_deshacer ( Base objeto ) {}
	protected virtual void efectuar_rehacer ( Base objeto ) {}

	public signal void cambio_signal ();
}
