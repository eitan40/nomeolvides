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
using Gee;

public class Nomeolvides.HechosColecciones : GLib.Object {
	public ListStoreColecciones colecciones_liststore { get; private set; }
		
	public HechosColecciones () {
	/*	this.colecciones_liststore = new ListStoreColecciones ();
		this.cargar_colecciones ();
		this.verificar_colecciones_online ();
	*/	
	}

	public void actualizar_colecciones_liststore ( ListStoreColecciones nueva_colecciones_liststore) {		
	/*	this.colecciones_liststore = nueva_colecciones_liststore;
		this.verificar_colecciones_online ();
		this.guardar_colecciones ();
	*/	
	}

	private void guardar_colecciones () {
	/*	string guardar = this.colecciones_liststore.a_json ();
		
		Configuracion.guardar_colecciones ( guardar );
	*/	
	}

	private void cargar_colecciones () {
	/*	string todo;
		string[] lineas;
		Coleccion nueva_coleccion;
		int i;	

		todo = Configuracion.cargar_colecciones ();
		
		lineas = todo.split_set ("\n");
		for (i=0; i < lineas.length; i++) {
        	nueva_coleccion = new Coleccion.json(lineas[i]);
			if ( nueva_coleccion.nombre_coleccion != "null" ) {
				this.colecciones_liststore.agregar_coleccion ( nueva_coleccion );
			}
		}*/
	}

	public ListStoreColecciones temp () {
	//	GLib.Value coleccion_value;
	//	Coleccion coleccion;
		ListStoreColecciones temp = new ListStoreColecciones ();
	/*	TreeIter iterador;
		
		if ( this.colecciones_liststore.get_iter_first ( out iterador ) ) {
			do {
				this.colecciones_liststore.get_value (iterador, 5, out coleccion_value);
				coleccion = coleccion_value as Coleccion;
				temp.agregar_coleccion( coleccion );
			}while ( this.colecciones_liststore.iter_next ( ref iterador) );
		}*/
		return temp;
	}

	public ListStoreColecciones get_colecciones_locales () {
	//	GLib.Value coleccion_value;
	//	Coleccion coleccion;
		ListStoreColecciones temp = new ListStoreColecciones ();
	/*	TreeIter iterador;
		
		if (this.colecciones_liststore.get_iter_first ( out iterador ) ) {
			do {
				this.colecciones_liststore.get_value (iterador, 5, out coleccion_value);
				coleccion = coleccion_value as Coleccion;
				if( coleccion.tipo_coleccion == ColeccionTipo.LOCAL ) {
					temp.agregar_coleccion ( coleccion );
				}	
			}while ( this.colecciones_liststore.iter_next ( ref iterador) );
		}*/
		return temp;
	}

	public ArrayList<Coleccion> get_colecciones_online () {
	//	GLib.Value coleccion_value;
	//	Coleccion coleccion;
		ArrayList<Coleccion> temp = new ArrayList<Coleccion> ();
	/*	TreeIter iterador;
		
		if (this.colecciones_liststore.get_iter_first ( out iterador ) ) {
			do {
				this.colecciones_liststore.get_value (iterador, 5, out coleccion_value);
				coleccion = coleccion_value as Coleccion;
				if( coleccion.tipo_coleccion == ColeccionTipo.HTTP ) {
					temp.add ( coleccion );
				}	
			}while ( this.colecciones_liststore.iter_next ( ref iterador) );
		}*/
		return temp;
	}

	public ListStoreColecciones get_colecciones_activas () {
	//	GLib.Value coleccion_value;
	//	Coleccion coleccion;
	//	ListStoreColecciones temp = this.get_colecciones_locales ();
		ListStoreColecciones activas = new ListStoreColecciones ();
	/*	TreeIter iterador;
		
		if (temp.get_iter_first ( out iterador ) ) {
			do {
				temp.get_value (iterador, 5, out coleccion_value);
				coleccion = coleccion_value as Coleccion;
				if( coleccion.visible == true ) {
					activas.agregar_coleccion ( coleccion );
				}	
			}while ( temp.iter_next ( ref iterador) );
		}*/
		return activas;
	}
	
	public ArrayList<string> lista_de_archivos ( ) { 
	/*	TreeIter iter;
		Value value_coleccion;
		Coleccion coleccion;*/
		ArrayList<string> retorno = new ArrayList<string> ();
/*
		if ( this.colecciones_liststore.get_iter_first(out iter) ) {
			do {
				this.colecciones_liststore.get_value(iter, 5, out value_coleccion);
				coleccion = value_coleccion as Coleccion;
				if (coleccion.tipo_coleccion == tipo) {
					if ( coleccion.visible == true ) {
						retorno.add ( coleccion.direccion_coleccion + coleccion.nombre_archivo );
					}
				}
			}while (this.colecciones_liststore.iter_next(ref iter));
		}
*/
		return retorno;
	}

	private void verificar_colecciones_online () {
		/*ArrayList<Coleccion> colecciones_online = this.get_colecciones_online ();

		foreach ( Coleccion c in colecciones_online ) {
			if (!(Archivo.existe_uri (c.direccion_coleccion + c.nombre_archivo) )) {
				c.visible = false;
				print ("Se desactivó la coleccion on line " + c.nombre_coleccion + " porque no actualmente no está disponible.\n" );
			}
		}*/
	}
}
