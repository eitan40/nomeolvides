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
using Nomeolvides;

public class Nomeolvides.ListStoreColecciones : ListStore {
	private ArrayList<string> archivos;
	private ArrayList<string> archivos_cache;
	private ArrayList<string> nombres_colecciones;
	private TreeIter iterador;
	
	public ListStoreColecciones () {
		Type[] tipos= { typeof(string), typeof(string), typeof(string), typeof(string), typeof(bool), typeof(Coleccion) };
		this.archivos = new ArrayList<string> ();
		this.archivos_cache = new ArrayList<string> ();
		this.nombres_colecciones = new ArrayList<string> ();
		this.set_column_types(tipos);
	}

	public void agregar_coleccion ( Coleccion coleccion ) {
		if ( coleccion.verificar_coleccion () && this.coleccion_no_duplicada ( coleccion ) ) {
			this.append ( out this.iterador );
			this.set ( this.iterador,
		                0,coleccion.nombre_coleccion,
		                1,coleccion.direccion_coleccion,
		                2,coleccion.nombre_archivo,
						3,coleccion.tipo_coleccion.to_string (),
		                4,coleccion.visible,
			      		5,coleccion );
			this.archivos.add ( coleccion.direccion_coleccion + coleccion.nombre_archivo );
			this.archivos_cache.add (coleccion.get_checksum());
			this.nombres_colecciones.add (coleccion.nombre_coleccion);
		}	
	}

	public ArrayList<string> get_archivos () {
		return this.archivos;
	}

	public string a_json () {
		string json = "";
		Coleccion coleccion;
		Value value_coleccion;
		TreeIter iter;

		this.get_iter_first(out iter);
		do {
			this.get_value(iter, 5, out value_coleccion);
			coleccion = value_coleccion as Coleccion;
			json += coleccion.a_json ()  + "\n";
		}while (this.iter_next(ref iter));

		return json;
	}

	private bool coleccion_no_duplicada ( Coleccion coleccion ) {
		bool retorno = true;

		if (this.archivos_cache.contains ( coleccion.get_checksum() ) || this.nombres_colecciones.contains (coleccion.nombre_coleccion) ) {
			retorno = false;
		}
			
		return retorno;
	}

	public void borrar_coleccion ( TreeIter iter, Coleccion a_eliminar ) {
		this.nombres_colecciones.remove ( a_eliminar.nombre_coleccion );
		this.archivos_cache.remove ( a_eliminar.get_checksum() );
		this.remove ( iter );
	} 
}
