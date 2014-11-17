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
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.ColeccionesPreferencias : Gtk.Box {
	public bool cambio_toggle { get; private set; }

	public ColeccionesPreferencias ( ListStoreColecciones liststore_colecciones ) {
		base ();
		this.treeview = new TreeViewColecciones () as TreeViewNmoBase;
		this.treeview.set_border_width ( 20 );
		this.treeview.set_model ( liststore_colecciones );
//		this.treeview.coleccion_visible_toggle_change.connect ( signal_toggle_change );
		this.scroll_view.add ( this.treeview );
		this.pack_start ( scroll_view, true, true, 0 );

		this.conectar_signals ();

		this.agregar_dialog = new AddColeccionDialog () as DialogNmoBase;
		this.editar_dialog = new EditColeccionDialog () as DialogNmoBase;
//		this-borrar_dialog = new BorrarColeccionDialogo () as DialogNmoBaseBorrar;	
	}

	protected override bool agregar ( NmoBase objeto ) {
		ListStoreColecciones liststore;
		if ( this.db.insert_coleccion ( objeto as Coleccion ) ) {
			objeto.id = this.db.ultimo_rowid();
			liststore = this.treeview.get_model () as ListStoreColecciones;
			liststore.agregar (objeto as Coleccion, 0);
			this.cambio_colecciones_signal ();
			return true;
		} else {
			return false;
		}
	}

	protected override bool actualizar ( NmoBase objeto_viejo, NmoBase objeto_nuevo ) {
		if ( this.db.update_coleccion ( objeto_nuevo as Coleccion ) ) {
			var liststore = this.treeview.get_model () as ListStoreColecciones;
			var cantidad_hechos = this.treeview.get_hechos ();
			this.treeview.eliminar ( objeto_viejo );
			liststore.agregar ( objeto_nuevo as Coleccion, cantidad_hechos );
			this.cambio_colecciones_signal ();
			return true;
		} else {
			return false;
		}
	}

	public override void edit_dialog () {
		Coleccion coleccion = this.treeview.get_elemento () as Coleccion;
		this.editar_dialog.set_datos ( coleccion );
		base.edit_dialog ();
	}

/*	private void edit_coleccion_dialog () {
		ListStoreColecciones liststore;

		Coleccion coleccion = this.db.select_coleccion ( "WHERE rowid=\"" 
		                                                + this.colecciones_view.get_elemento_id ().to_string() + "\"");
		var edit_dialog = new DialogColeccionEditar ();
		edit_dialog.set_datos ( coleccion );
		edit_dialog.show_all ();

		if (edit_dialog.run() == ResponseType.APPLY) {
			if ( this.db.update_coleccion ( edit_dialog.respuesta as Coleccion ) ) {
				liststore = this.colecciones_view.get_model () as ListStoreColecciones;
				var cantidad_hechos = this.colecciones_view.get_hechos ();
				this.colecciones_view.eliminar ( coleccion );
				liststore.agregar ( edit_dialog.respuesta as Coleccion, cantidad_hechos );
				this.cambio_colecciones_signal ();
			}
		}
		
		edit_dialog.destroy ();
	}

	private void borrar_coleccion_dialog () {
		Coleccion coleccion = this.db.select_coleccion ( "WHERE rowid=\"" + this.colecciones_view.get_elemento_id ().to_string() + "\"");
		int cantidad_hechos = this.db.count_hechos_coleccion ( coleccion );
		var borrar_dialog = new DialogColeccionBorrar ( coleccion, cantidad_hechos );
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
	} */

	private void signal_toggle_change () {
		this.cambio_toggle = true;
	}

	public signal void cambio_colecciones_signal ();
}
