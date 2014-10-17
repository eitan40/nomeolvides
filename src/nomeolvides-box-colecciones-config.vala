/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2013 Andres Fernandez <andres@softwareperonista.com.ar>
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
 *   bullit - 39 escalones - silent love (japonesa) 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.ColeccionesConfig : Gtk.Box {
	public TreeViewColecciones colecciones_view { get; private set; }
	public bool cambios { get; private set; }
	public bool cambio_toggle { get; private set; }
	private Toolbar toolbar;
	private AccionesDB db;
	private Deshacer<Coleccion> deshacer;
		
	public ColeccionesConfig ( ListStoreColecciones liststore_colecciones ) {
		this.set_orientation ( Orientation.VERTICAL );

		this.db = new AccionesDB ( Configuracion.base_de_datos() );
		this.deshacer = new Deshacer<Coleccion> ();

		this.cambios = false;
		this.cambio_toggle = false;
		this.colecciones_view = new TreeViewColecciones ();
		this.colecciones_view.set_model ( liststore_colecciones );
		this.colecciones_view.cursor_changed.connect ( elegir_coleccion );
		this.colecciones_view.coleccion_visible_toggle_change.connect ( signal_toggle_change );
		this.toolbar = new Toolbar ();
		this.conectar_signals ();

		var scroll_colecciones_view = new ScrolledWindow (null,null);
		scroll_colecciones_view.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		scroll_colecciones_view.add ( this.colecciones_view );
 
		this.pack_start ( toolbar, false, false, 0 );
		this.pack_start ( scroll_colecciones_view, true, true, 0 );
		this.show_all ();
	}

	public void actualizar_model ( ListStoreColecciones liststore_colecciones ) {
		this.colecciones_view.set_model ( liststore_colecciones );
	}

	private void conectar_signals () {
		this.toolbar.add_button.clicked.connect ( this.add_coleccion_dialog );
		this.toolbar.delete_button.clicked.connect ( this.borrar_coleccion_dialog );
		this.toolbar.edit_button.clicked.connect ( this.edit_coleccion_dialog );
		this.toolbar.undo_button.clicked.connect ( this.deshacer_cambios );
		this.toolbar.redo_button.clicked.connect ( this.rehacer_cambios );
		
		this.deshacer.deshacer_sin_items.connect ( this.toolbar.desactivar_deshacer );
		this.deshacer.deshacer_con_items.connect ( this.toolbar.activar_deshacer );
		this.deshacer.rehacer_sin_items.connect ( this.toolbar.desactivar_rehacer );
		this.deshacer.rehacer_con_items.connect ( this.toolbar.activar_rehacer );
	}

	private void add_coleccion_dialog () {
		ListStoreColecciones liststore;
		Coleccion coleccion;
		
		var add_dialog = new DialogColeccionAgregar ( );
		add_dialog.show_all ();

		if (add_dialog.run() == ResponseType.APPLY) {
			coleccion = add_dialog.respuesta;
			if ( this.db.insert_coleccion ( coleccion ) ) {
				coleccion.id = this.db.ultimo_rowid();
				liststore = this.colecciones_view.get_model () as ListStoreColecciones;
				liststore.agregar (coleccion, 0);
				this.cambios = true;
			}
		}
		
		add_dialog.destroy ();
	}

	private void edit_coleccion_dialog () {
		ListStoreColecciones liststore;

		Coleccion coleccion = this.db.select_coleccion ( "WHERE rowid=\"" 
		                                                + this.colecciones_view.get_elemento_id ().to_string() + "\"");
		var edit_dialog = new EditColeccionDialog ();
		edit_dialog.set_datos ( coleccion );
		edit_dialog.show_all ();

		if (edit_dialog.run() == ResponseType.APPLY) {
			if ( this.db.update_coleccion ( edit_dialog.respuesta ) ) {
				liststore = this.colecciones_view.get_model () as ListStoreColecciones;
				var cantidad_hechos = this.colecciones_view.get_hechos ();
				this.colecciones_view.eliminar ( coleccion );
				liststore.agregar ( edit_dialog.respuesta, cantidad_hechos );
				this.cambios = true;
			}
		}
		
		edit_dialog.destroy ();
	}

	private void borrar_coleccion_dialog () {
		Coleccion coleccion = this.db.select_coleccion ( "WHERE rowid=\"" + this.colecciones_view.get_elemento_id ().to_string() + "\"");
		int cantidad_hechos = this.db.count_hechos_coleccion ( coleccion );
		var borrar_dialog = new BorrarColeccionDialogo ( coleccion, cantidad_hechos );
		borrar_dialog.show_all ();

		if (borrar_dialog.run() == ResponseType.APPLY) {
			this.db.coleccion_a_borrar ( coleccion );
			this.deshacer.guardar_borrado ( coleccion, DeshacerTipo.BORRAR );
			this.deshacer.borrar_rehacer ();
			this.colecciones_view.eliminar( coleccion );
			this.cambio_colecciones_signal ();
		}
		borrar_dialog.destroy ();

		this.cambios = true;
	}

	private void elegir_coleccion () {
		if( this.colecciones_view.get_elemento_id () > (int64)(-1) ) {
			this.toolbar.set_buttons_visible ();
		} else {
			this.toolbar.set_buttons_invisible ();
		}

		if ( this.cambio_toggle ) {
			Coleccion coleccion = this.db.select_coleccion ( "WHERE rowid=\"" + this.colecciones_view.get_elemento_id().to_string() + "\"");
			coleccion.visible = this.colecciones_view.get_coleccion_cursor_visible ();
			this.db.update_coleccion ( coleccion );
			this.cambio_toggle = false;
		}
	}

	void deshacer_cambios () {
		DeshacerItem<Coleccion> item;
		bool hay_colecciones_deshacer = this.deshacer.deshacer ( out item ); 
		if ( hay_colecciones_deshacer ){
			this.db.coleccion_no_borrar ( item.get_borrado() );
			var liststore = this.colecciones_view.get_model () as ListStoreColecciones;
			var cantidad_hechos = this.db.count_hechos_coleccion ( item.get_borrado() );
			liststore.agregar ( item.get_borrado(), cantidad_hechos);
			this.cambio_colecciones_signal ();
		}
	}

	public void rehacer_cambios () {
		DeshacerItem<Coleccion> item;

		bool hay_colecciones_rehacer = this.deshacer.rehacer ( out item ); 
		if ( hay_colecciones_rehacer ){
			this.db.coleccion_a_borrar ( item.get_borrado() );
			this.colecciones_view.eliminar ( item.get_borrado() );
			this.cambio_colecciones_signal ();
		}
	}

	public void set_buttons_invisible () {
		this.toolbar.set_buttons_invisible ();
	}

	private void signal_toggle_change () {
		this.cambio_toggle = true;
	}

	public signal void cambio_colecciones_signal ();
}
