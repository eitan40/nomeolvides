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

public class Nomeolvides.ListStoreListas : ListStore {
	private ArrayList<string> listas_cache;
	private TreeIter iterador;
	
	public ListStoreListas () {
		Type[] tipos= { typeof(string), typeof(int), typeof(Lista) };
		this.set_column_types(tipos);
		this.listas_cache = new ArrayList<string> ();
	}

	public void agregar_lista ( Lista lista ) {
		if ( this.lista_no_duplicada (lista) ) {
			this.append ( out this.iterador );
			this.set ( this.iterador,
		               0,lista.nombre,
		               1,lista.cantidad_hechos,
		               2,lista );
			this.listas_cache.add ( lista.get_checksum() );
		}	
	}

	public string a_json () {
		string json = "";
		Lista lista;
		Value value_lista;
		TreeIter iter;

		this.get_iter_first(out iter);
		do {
			this.get_value(iter, 2, out value_lista);
			lista = value_lista as Lista;
			json += lista.a_json ()  + "\n";
		}while (this.iter_next(ref iter));

		return json;
	}

	private bool lista_no_duplicada ( Lista lista ) {
		bool retorno = true;

		if (this.listas_cache.contains ( lista.get_checksum() ) ) {
			retorno = false;
		}
			
		return retorno;
	}

	public void borrar_lista ( TreeIter iter, Lista a_eliminar ) {
		this.remove ( iter );
		this.listas_cache.remove ( a_eliminar.get_checksum() );
	} 
}
