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

public class Nomeolvides.ListasPreferencias: Gtk.Box {
	public TreeViewListas listas_view { get; private set; }
	public bool cambios { get; private set; }
	private AccionesDB db;
	private Deshacer<Lista> deshacer;
	private Toolbar toolbar;
		
	public ListasPreferencias ( ListStoreListas liststore_lista ) {
		this.db = new AccionesDB ( Configuracion.base_de_datos() );
		this.set_orientation ( Orientation.VERTICAL );
		this.deshacer = new Deshacer<Lista> ();
		
		this.cambios = false;
		this.listas_view = new TreeViewListas ();
		this.listas_view.set_model ( liststore_lista );
		this.listas_view.cursor_changed.connect ( elegir_lista );
		this.toolbar = new Toolbar ();
		this.conectar_signals ();

		var scroll_listas_view = new ScrolledWindow (null,null);
		scroll_listas_view.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		scroll_listas_view.add ( this.listas_view );
 
		this.pack_start ( toolbar, false, false, 0 );
		this.pack_start ( scroll_listas_view, true, true, 0);
		this.show_all ();
	}

	public void actualizar_model ( ListStoreListas liststore_listas ) {
		this.listas_view.set_model ( liststore_listas );
	}

	private void conectar_signals () {
		this.toolbar.add_button.clicked.connect ( this.add_lista_dialog );
		this.toolbar.delete_button.clicked.connect ( this.borrar_lista_dialog );
		this.toolbar.edit_button.clicked.connect ( this.edit_lista_dialog );
		this.toolbar.undo_button.clicked.connect ( this.deshacer_cambios );
		this.toolbar.redo_button.clicked.connect ( this.rehacer_cambios );

		this.deshacer.deshacer_sin_items.connect ( this.toolbar.desactivar_deshacer );
		this.deshacer.deshacer_con_items.connect ( this.toolbar.activar_deshacer );
		this.deshacer.rehacer_sin_items.connect ( this.toolbar.desactivar_rehacer );
		this.deshacer.rehacer_con_items.connect ( this.toolbar.activar_rehacer );
	}

	private void add_lista_dialog () {
		ListStoreListas liststore;
		Lista lista;
		
		var add_dialog = new DialogLstaAgregar ( );
		add_dialog.show_all ();

		if (add_dialog.run() == ResponseType.APPLY) {
			lista = add_dialog.respuesta as Lista;
			if ( this.db.insert_lista ( lista )) {
				lista.id = this.db.ultimo_rowid();
				liststore = this.listas_view.get_model () as ListStoreListas;
				liststore.agregar ( lista, 0 );
				this.cambios = true;
			}
		}
		
		add_dialog.destroy ();
	}

	private void edit_lista_dialog () {
		ListStoreListas liststore;
		Lista lista = this.db.select_lista ( "WHERE rowid=\"" 
											+ this.listas_view.get_elemento_id ().to_string() + "\"");
		
		var edit_dialog = new DialogListaEditar ();
		edit_dialog.set_datos ( lista );
		edit_dialog.show_all ();

		if (edit_dialog.run() == ResponseType.APPLY) {
			if ( this.db.update_lista ( edit_dialog.respuesta as Lista )) {
				liststore = this.listas_view.get_model () as ListStoreListas;
				var cantidad_hechos = this.listas_view.get_cantidad_hechos ();
				this.listas_view.eliminar( lista );
				liststore.agregar (edit_dialog.respuesta, cantidad_hechos);
				this.cambios = true;
			}
		}	
		edit_dialog.destroy ();
	}

	private void borrar_lista_dialog () {
		Lista lista = this.db.select_lista ( "WHERE rowid=\"" 
		                                                + this.listas_view.get_elemento_id ().to_string() + "\"");
		var borrar_dialog = new DialogListaBorrar ( lista, this.listas_view.get_cantidad_hechos () );
		borrar_dialog.show_all ();

		if (borrar_dialog.run() == ResponseType.APPLY) {
			this.db.lista_a_borrar ( lista );
			this.deshacer.guardar_borrado ( lista, DeshacerTipo.BORRAR );
			this.deshacer.borrar_rehacer ();
			this.listas_view.eliminar (lista );
		}
		borrar_dialog.destroy ();

		this.cambios = true;
	}

	private void elegir_lista () {
		if( this.listas_view.get_elemento_id () != -1 ) {
			this.toolbar.set_buttons_visible ();
		} else {
			this.toolbar.set_buttons_invisible ();
		}
	}

	public void actualizar_liststore () {
		var liststore = new ListStoreListas ();
		var listas = this.db.select_listas ();

		for ( int i=0; i < listas.length; i++ ) {
			var lista = listas.index (i);
			var cantidad_hechos = this.db.count_hechos_lista ( lista );
			liststore.agregar ( lista, cantidad_hechos );			
		}

		this.listas_view.set_model ( liststore );
	}

	public void deshacer_cambios () {
		DeshacerItem<Lista> item;
		bool hay_listas_deshacer = this.deshacer.deshacer ( out item ); 
		if ( hay_listas_deshacer ){
			this.db.lista_no_borrar ( item.get_borrado() );
			var liststore = this.listas_view.get_model () as ListStoreListas;
			var cantidad_hechos = this.db.count_hechos_lista ( item.get_borrado() );
			liststore.agregar ( item.get_borrado(), cantidad_hechos);
			this.cambios = true;
		}
	}

	public void rehacer_cambios () {
		DeshacerItem<Lista> item;

		bool hay_listas_rehacer = this.deshacer.rehacer ( out item ); 
		if ( hay_listas_rehacer ){
			this.db.lista_a_borrar ( item.get_borrado() );
			this.listas_view.eliminar ( item.get_borrado() );
			this.cambios = true;
		}
	}

	public void set_buttons_invisible () {
		this.toolbar.set_buttons_invisible ();
	}
}
