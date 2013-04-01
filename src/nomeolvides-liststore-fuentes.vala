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

public class Nomeolvides.ListStoreFuentes : ListStore {
	private ArrayList<string> archivos;
	private ArrayList<string> archivos_cache;
	private ArrayList<string> nombres_db;
	private TreeIter iterador;
	
	public ListStoreFuentes () {
		Type[] tipos= { typeof(string), typeof(string), typeof(string), typeof(string), typeof(Fuente) };
		this.archivos = new ArrayList<string> ();
		this.archivos_cache = new ArrayList<string> ();
		this.nombres_db = new ArrayList<string> ();
		this.set_column_types(tipos);
	}

	public void agregar_fuente ( Fuente fuente ) {
		if ( fuente.verificar_fuente () && this.db_no_duplicada (fuente) ) {
			this.append ( out this.iterador );
			this.set ( this.iterador,
		                         0,fuente.nombre_fuente,
		                         1,fuente.direccion_fuente,
		                         2,fuente.nombre_archivo,
		                         3,fuente.tipo_fuente.to_string () ,
		                         4,fuente );
			this.archivos.add ( fuente.direccion_fuente + fuente.nombre_archivo );
			this.archivos_cache.add (fuente.get_checksum());
			this.nombres_db.add (fuente.nombre_fuente);
		}	
	}

	public ArrayList<string> get_archivos () {
		return this.archivos;
	}

	public string a_json () {
		string json = "";
		Fuente fuente;
		Value value_fuente;
		TreeIter iter;

		this.get_iter_first(out iter);
		do {
			this.get_value(iter, 4, out value_fuente);
			fuente = value_fuente as Fuente;
			json += fuente.a_json ()  + "\n";
		}while (this.iter_next(ref iter));

		return json;
	}

	private bool db_no_duplicada ( Fuente fuente ) {
		bool retorno = true;

		if (this.archivos_cache.contains ( fuente.get_checksum() ) || this.nombres_db.contains (fuente.nombre_fuente) ) {
			retorno = false;
		}
			
		return retorno;
	}

	public void borrar_fuente ( TreeIter iter, Fuente a_eliminar ) {
		this.nombres_db.remove ( a_eliminar.nombre_fuente );
		this.archivos_cache.remove ( a_eliminar.get_checksum() );
		this.remove ( iter );
	} 
}
