/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2012 Andres Fernandez <andres@softwareperonista.com.ar>
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
using GLib;
using Nomeolvides;

public class Nomeolvides.Datos : GLib.Object {
	public Deshacer<Hecho> deshacer;
	private AccionesDB db;

	public Datos () {
		this.deshacer = new Deshacer<Hecho> ();
		this.db = new AccionesDB ( Configuracion.base_de_datos() );

		this.db.borrar_deshacer ();
		this.conectar_signals ();
	}

	private void conectar_signals () {
		this.deshacer.deshacer_sin_items.connect ( this.signal_no_hechos_deshacer );
		this.deshacer.deshacer_con_items.connect ( this.signal_hechos_deshacer );
		this.deshacer.rehacer_sin_items.connect ( this.signal_no_hechos_rehacer );
		this.deshacer.rehacer_con_items.connect ( this.signal_hechos_rehacer );
	}

	public void agregar_hecho (Hecho hecho) {
		this.db.insert_hecho ( hecho );
		this.datos_cambio_anios ();
		this.datos_cambio_hechos ();
	}

	public void agregar_hecho_lista ( Hecho hecho, int64 id_lista ) {
		var lista = this.db.select_lista ( "WHERE id=\"" + id_lista.to_string() + "\"" );
		this.db.insert_hecho_lista ( hecho, lista );
		this.datos_cambio_hechos ();
	}

	public void quitar_hecho_lista ( Hecho hecho, Lista lista ) {
		this.db.delete_hecho_lista ( hecho, lista );		
		this.datos_cambio_hechos ();
	}

	public void eliminar_hecho ( Hecho hecho ) {
		this.deshacer.guardar_borrado ( hecho, DeshacerTipo.BORRAR );
		this.borrar_rehacer ();
		this.db.hecho_a_borrar ( hecho );
		this.datos_cambio_anios ();
		this.datos_cambio_hechos ();
	}

	public void edit_hecho ( Hecho hecho ) {
			var hecho_viejo = this.db.select_hechos ("WHERE hechos.id=" + hecho.id.to_string()).index(0);
			this.deshacer.guardar_borrado ( hecho_viejo, DeshacerTipo.EDITAR );
			this.deshacer.guardar_editado ( hecho );
			this.borrar_rehacer ();
			this.db.update_hecho ( hecho );
			this.datos_cambio_anios ();
			this.datos_cambio_hechos ();
	}

	public void deshacer_cambios () {
		DeshacerItem<Hecho> item;
		bool hay_hechos_deshacer = this.deshacer.deshacer ( out item ); 
		if ( hay_hechos_deshacer ){
			if ( item.get_tipo () == DeshacerTipo.EDITAR ) {
				this.db.update_hecho ( item.get_borrado() );
			} else {
				this.db.hecho_no_borrar ( item.get_borrado() );
			}
			this.datos_cambio_anios ();
			this.datos_cambio_hechos ();
		}
	}

	public void rehacer_cambios () {
		DeshacerItem<Hecho> item;

		bool hay_hechos_rehacer = this.deshacer.rehacer ( out item ); 
		if ( hay_hechos_rehacer ){
			if ( item.get_tipo () == DeshacerTipo.EDITAR ) {
			this.db.update_hecho ( item.get_borrado() );
			} else {
				this.db.hecho_a_borrar ( item.get_borrado() );
			}
			this.datos_cambio_anios ();
			this.datos_cambio_hechos ();
		}
	}

	public Array<int> lista_de_anios () {
		return this.db.lista_de_anios ();
	}

	public void open_file ( string nombre_archivo, int64 coleccion_id ) {
		string todo;
		string[] lineas;
		Hecho nuevoHecho;
		int i;	

		todo = Archivo.leer ( nombre_archivo );

		lineas = todo.split_set ("\n");

		for (i=0; i < (lineas.length - 1); i++) {
			nuevoHecho = new Hecho.json(lineas[i], coleccion_id);
			if ( nuevoHecho.nombre != "null" ) {
				this.agregar_hecho(nuevoHecho);
			}
		}
	}

	public void save_as_file ( string archivo ) {
		string a_guardar = "";
		var hechos = this.db.select_hechos ();
		
		for ( int i=0; i < hechos.length; i++ ) {
			var hecho = hechos.index (i);
			a_guardar += hecho.a_json () + "\n";			
		}

		Archivo.escribir ( archivo, a_guardar );
	}

	public void borrar_rehacer () {
		this.deshacer.borrar_rehacer ();
	}

	public Array<Hecho> get_hechos_anio ( int anio ) {
		Array<Hecho> hechos = new Array<Hecho>();

		if ( anio != 0 ) {
			hechos = this.db.select_hechos_visibles ( "WHERE anio=\"" + anio.to_string () +"\"" );
		}
		
		return hechos;
	}

	public Array<Hecho> get_hechos_lista ( Lista lista ) {
		Array<Hecho> hechos = new Array<Hecho> ();

		if ( lista != null ) {
			hechos = this.db.select_hechos_lista ( lista );
		}
		return hechos;
	}

	public ListStoreListas lista_de_listas () {
		var listas = this.db.select_listas ();
		
		return this.armar_liststore_listas ( listas );
	}

	public ListStoreColecciones lista_de_colecciones () {
		var colecciones = this.db.select_colecciones ( "WHERE colecciones.id NOT IN coleccionesborrar" );

		return this.armar_liststore_colecciones ( colecciones );
	}

	public bool hay_listas() {
		TreeIter iter;
		bool hay=false;

		var liststore = this.lista_de_listas();

		if ( liststore.get_iter_first ( out iter ) ) { 
			hay = true;
		}
		return hay;
	}

	public bool hay_colecciones_activas() {

		bool hay = false;
		var colecciones = this.db.select_colecciones ( "WHERE visible=\"true\" AND colecciones.id NOT IN coleccionesborrar" );
		if ( colecciones.length > 0 ) {
			hay = true;
		}
		return hay;
	}

	private ListStoreHechos armar_liststore_hechos ( Array<Hecho> hechos) {
		var liststore = new ListStoreHechos ();

		for ( int i=0; i < hechos.length; i++ ) {
			var hecho = hechos.index (i);
			liststore.agregar ( hecho );			
		}

		return liststore;
	}

	private ListStoreListas armar_liststore_listas ( Array<Lista> listas) {
		var liststore = new ListStoreListas ();

		for ( int i=0; i < listas.length; i++ ) {
			var lista = listas.index (i);
			var cantidad_hechos = this.db.count_hechos_lista ( lista );
			liststore.agregar ( lista, cantidad_hechos );			
		}

		return liststore;
	}

	private ListStoreColecciones armar_liststore_colecciones ( Array<Coleccion> colecciones ) {
		var liststore = new ListStoreColecciones ();

		for ( int i=0; i < colecciones.length; i++ ) {
			var coleccion = colecciones.index (i);
			var cantidad_hechos = this.db.count_hechos_coleccion ( coleccion );
			liststore.agregar ( coleccion, cantidad_hechos );
		}

		return liststore;
	}

	public void signal_cambio_anios () {
		this.datos_cambio_anios ();
	}

	public void signal_cambio_listas () {
		this.datos_cambio_listas ();
	}

	public void signal_cambio_hechos () {
		this.datos_cambio_hechos ();
	}

	public void signal_cambio_hechos_listas () {
		this.datos_cambio_hechos ();		
	}

	public void signal_hechos_deshacer () {
		this.datos_hechos_deshacer ();
	}

	public void signal_no_hechos_deshacer () {
		this.datos_no_hechos_deshacer ();
	}

	public void signal_hechos_rehacer () {
		this.datos_hechos_rehacer ();
	}

	public void signal_no_hechos_rehacer () {
		this.datos_no_hechos_rehacer ();
	}

	public signal void datos_cambio_anios ();
	public signal void datos_cambio_listas ();
	public signal void datos_cambio_hechos ();
	public signal void datos_hechos_deshacer ();
	public signal void datos_no_hechos_deshacer ();
	public signal void datos_hechos_rehacer ();
	public signal void datos_no_hechos_rehacer ();
}
