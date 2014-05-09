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
 *   bullit - 39 escalones - silent love (japonesa) 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.EtiquetasConfig: Gtk.Box {
	public TreeViewEtiquetas etiquetas_view { get; private set; }
	private Toolbar toolbar;
	public bool cambios { get; private set; }
	private AccionesDB db;
	private Deshacer<Etiqueta> deshacer;
		
	public EtiquetasConfig ( ListStoreEtiquetas liststore_etiquetas ) {
		this.db = new AccionesDB ( Configuracion.base_de_datos() );
		this.set_orientation ( Orientation.VERTICAL );

		this.toolbar = new Toolbar ();

		this.deshacer = new Deshacer<Etiqueta> ();
		
		this.conectar_signals ();
		this.cambios = false;
		this.etiquetas_view = new TreeViewEtiquetas ();
		this.etiquetas_view.set_model ( liststore_etiquetas );
		this.etiquetas_view.cursor_changed.connect ( elegir_etiqueta );

		var scroll_etiquetas_view = new ScrolledWindow (null,null);
		scroll_etiquetas_view.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		scroll_etiquetas_view.add ( this.etiquetas_view );
 
		this.add ( toolbar );
		this.pack_start ( scroll_etiquetas_view, true, true, 0);
		this.show_all ();
	}

	public void actualizar_model ( ListStoreEtiquetas liststore_etiquetas ) {
		this.etiquetas_view.set_model ( liststore_etiquetas );
	}

	private void conectar_signals () {
		this.toolbar.add_button.clicked.connect ( this.add_etiqueta_dialog );
		this.toolbar.delete_button.clicked.connect ( this.borrar_etiqueta_dialog );
		this.toolbar.edit_button.clicked.connect ( this.edit_etiqueta_dialog );
		this.toolbar.undo_button.clicked.connect ( this.deshacer_cambios );
		this.toolbar.redo_button.clicked.connect ( this.rehacer_cambios );

		this.deshacer.deshacer_sin_items.connect ( this.toolbar.desactivar_deshacer );
		this.deshacer.deshacer_con_items.connect ( this.toolbar.activar_deshacer );
		this.deshacer.rehacer_sin_items.connect ( this.toolbar.desactivar_rehacer );
		this.deshacer.rehacer_con_items.connect ( this.toolbar.activar_rehacer );
}

	private void add_etiqueta_dialog () {
		ListStoreEtiquetas liststore;
		Etiqueta etiqueta;
		
		var add_dialog = new AddEtiquetaDialog ( );
		add_dialog.show_all ();

		if (add_dialog.run() == ResponseType.APPLY) {
			etiqueta = add_dialog.respuesta;
			if ( this.db.insert_etiqueta ( etiqueta )) {
				etiqueta.id = this.db.ultimo_rowid();
				liststore = this.etiquetas_view.get_model () as ListStoreEtiquetas;
				liststore.agregar ( etiqueta, 0 );
				this.cambios = true;
			}
		}
		
		add_dialog.destroy ();
	}

	private void edit_etiqueta_dialog () {
		ListStoreEtiquetas liststore;
		Etiqueta etiqueta = this.db.select_etiqueta ( "WHERE rowid=\"" 
		                                                + this.etiquetas_view.get_elemento_id ().to_string() + "\"");
		
		var edit_dialog = new EditEtiquetaDialog ();
		edit_dialog.set_datos ( etiqueta );
		edit_dialog.show_all ();

		if (edit_dialog.run() == ResponseType.APPLY) {
			if ( this.db.update_etiqueta ( edit_dialog.respuesta )) {
				liststore = this.etiquetas_view.get_model () as ListStoreEtiquetas;
				var cantidad_hechos = this.etiquetas_view.get_hechos ();
				this.etiquetas_view.eliminar( etiqueta );
				liststore.agregar (edit_dialog.respuesta, cantidad_hechos);
				this.cambios = true;
			}
		}	
		edit_dialog.destroy ();
	}

	private void borrar_etiqueta_dialog () {
		Etiqueta etiqueta = this.db.select_etiqueta ( "WHERE rowid=\"" 
		                                                + this.etiquetas_view.get_elemento_id ().to_string() + "\"");
		var borrar_dialog = new BorrarEtiquetaDialogo ( etiqueta, this.etiquetas_view.get_hechos () );
		borrar_dialog.show_all ();

		if (borrar_dialog.run() == ResponseType.APPLY) {
			this.db.etiqueta_a_borrar ( etiqueta );
			this.deshacer.guardar_borrado ( etiqueta, DeshacerTipo.BORRAR );
			this.deshacer.borrar_rehacer ();
			this.etiquetas_view.eliminar ( etiqueta );
		}
		borrar_dialog.destroy ();

		this.cambios = true;
	}

	public void set_buttons_invisible () {
		this.toolbar.set_buttons_invisible ();
	}

	private void elegir_etiqueta () {
		if( this.etiquetas_view.get_elemento_id () != -1 ) {
			this.toolbar.set_buttons_visible ();
		} else {
			this.toolbar.set_buttons_invisible ();
		}
	}

	public void actualizar_liststore () {
		var liststore = new ListStoreEtiquetas ();
		var etiquetas = this.db.select_etiquetas ();

		for ( int i=0; i < etiquetas.length; i++ ) {
			var etiqueta = etiquetas.index (i);
			var cantidad_hechos = this.db.count_hechos_etiqueta ( etiqueta );
			liststore.agregar ( etiqueta, cantidad_hechos );			
		}

		this.etiquetas_view.set_model ( liststore );
	}

	public void deshacer_cambios () {
		DeshacerItem<Etiqueta> item;
		bool hay_etiqueta_deshacer = this.deshacer.deshacer ( out item ); 
		if ( hay_etiqueta_deshacer ){
			this.db.etiqueta_no_borrar ( item.get_borrado() );
			var liststore = this.etiquetas_view.get_model () as ListStoreEtiquetas;
			var cantidad_hechos = this.db.count_hechos_etiqueta ( item.get_borrado() );
			liststore.agregar ( item.get_borrado(), cantidad_hechos);
			this.cambios = true;
		}
	}

	public void rehacer_cambios () {
		DeshacerItem<Etiqueta> item;

		bool hay_etiquetas_rehacer = this.deshacer.rehacer ( out item ); 
		if ( hay_etiquetas_rehacer ){
			this.db.etiqueta_a_borrar ( item.get_borrado() );
			this.etiquetas_view.eliminar ( item.get_borrado() );
			this.cambios = true;
		}
	}

	public signal void cambio_colecciones_signal ();
}
