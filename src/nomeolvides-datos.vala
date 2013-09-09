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
using Gee;
using GLib;
using Nomeolvides;

public class Nomeolvides.Datos : GLib.Object {
	public Deshacer deshacer;
	private AccionesDB db;

	public Datos () {
		this.deshacer = new Deshacer ();
		this.db = new AccionesDB ( Configuracion.base_de_datos() );

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

	public void agregar_hecho_lista ( Hecho hecho, Lista lista ) {
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
		this.db.delete_hecho ( hecho );
		this.datos_cambio_anios ();
		this.datos_cambio_hechos ();
	}

	public void edit_hecho ( Hecho hecho ) {
			this.deshacer.guardar_borrado ( hecho, DeshacerTipo.EDITAR );
			this.deshacer.guardar_editado ( hecho );
			this.borrar_rehacer ();
			this.db.update_hecho ( hecho );
			this.datos_cambio_anios ();
			this.datos_cambio_hechos ();
	}

	public void deshacer_cambios () {
		DeshacerItem item;

		bool hay_hechos_deshacer = this.deshacer.deshacer ( out item ); 
		if ( hay_hechos_deshacer ){
			if ( item.get_tipo () == DeshacerTipo.EDITAR ) {
				this.eliminar_hecho ( item.get_editado() );
			}
			this.agregar_hecho ( item.get_borrado() );
		}
	}

	public void rehacer_cambios () {
		DeshacerItem item;

		bool hay_hechos_rehacer = this.deshacer.rehacer ( out item ); 
		if ( hay_hechos_rehacer ){
			if ( item.get_tipo () == DeshacerTipo.EDITAR ) {
				this.eliminar_hecho ( item.get_editado() );
				this.agregar_hecho ( item.get_borrado() );
			} else {
				this.eliminar_hecho ( item.get_borrado() );
			}
		}
	}

	public Array<int> lista_de_anios ()
	{
		return this.db.lista_de_anios ();
	}

	public void open_file ( string nombre_archivo ) {
		string todo;
		string[] lineas;
		Hecho nuevoHecho;
		int i;	

		todo = Archivo.leer ( nombre_archivo );

		lineas = todo.split_set ("\n");

		for (i=0; i < (lineas.length - 1); i++) {
			nuevoHecho = new Hecho.json(lineas[i], (int64) 1);
			if ( nuevoHecho.nombre != "null" ) {
				this.agregar_hecho(nuevoHecho);
			}
		}
	}

	public void save_as_file ( string archivo ) {
		string a_guardar = "";
		var array_hechos = this.db.select_hechos ();
		
		foreach (Hecho h in array_hechos ) {
			a_guardar += h.a_json() + "\n"; 
		}

		Archivo.escribir ( archivo, a_guardar );
	}

	public void borrar_rehacer () {
		this.deshacer.borrar_rehacer ();
	}

	public ListStoreHechos get_liststore_anio ( int anio ) {
		var hechos = this.db.select_hechos ( "WHERE anio=\"" + anio.to_string () +"\"" );
		return this.armar_liststore_hechos(hechos);
	}

	public ListStoreHechos get_liststore_lista ( Lista lista ) {
		var lista_hechos = this.db.select_hechos_lista ( lista );
		return this.armar_liststore_hechos(lista_hechos);
	}

	public ListStoreListas lista_de_listas () {
		var listas = this.db.select_listas (); 
		
		return this.armar_liststore_listas ( listas );
	}

	public ListStoreColecciones lista_de_colecciones () {
		var colecciones = this.db.select_colecciones ();

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
		var colecciones = this.db.select_colecciones ( "WHERE visible=\"true\"" );
		if ( colecciones.size > 0 ) {
			hay = true;
		}
		return hay;
	}

	private ListStoreHechos armar_liststore_hechos ( ArrayList<Hecho> hechos) {
		var liststore = new ListStoreHechos ();

		foreach ( Hecho h in hechos ) {
			liststore.agregar ( h );
		}

		return liststore;
	}

	private ListStoreListas armar_liststore_listas ( ArrayList<Lista> listas) {
		var liststore = new ListStoreListas ();

		foreach ( Lista l in listas ) {
			liststore.agregar_lista ( l );
		}

		return liststore;
	}

	private ListStoreColecciones armar_liststore_colecciones ( ArrayList<Coleccion> colecciones ) {
		var liststore = new ListStoreColecciones ();

		foreach ( Coleccion c in colecciones ) {
			liststore.agregar_coleccion ( c );
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
