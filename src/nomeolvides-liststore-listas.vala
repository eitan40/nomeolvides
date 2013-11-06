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
using Nomeolvides;

public class Nomeolvides.ListStoreListas : ListStore {
	private TreeIter iterador;
	public bool hay_listas { get; private set; }
	
	public ListStoreListas () {
		Type[] tipos= { typeof(string), typeof(int), typeof(int64) };
		this.set_column_types(tipos);
		this.hay_listas = false;
	}

	public void agregar_lista ( Lista lista, int cantidad_hechos ) {
		if (lista != null ) {
			this.append ( out this.iterador );
			this.set ( this.iterador,
						0,lista.nombre,
						1,cantidad_hechos,
		    			2,lista.id );
			this.hay_listas = true;
		}
	}

	public string a_json () {
		string json = "";
		Lista lista;
		Value value_lista;
		TreeIter iter;

		if ( this.get_iter_first( out iter ) ) {
			do {
				this.get_value(iter, 2, out value_lista);
				lista = value_lista as Lista;
				json += lista.a_json ()  + "\n";
			}while (this.iter_next(ref iter));
		}
		return json;
	}

	public void borrar_lista ( TreeIter iter, Lista a_eliminar ) {
		this.remove ( iter );
	}

	public int get_hechos_lista ( TreeIter iter ) {
		Value value_cantidad;
		int cantidad = 0;

		this.get_value(iter, 1, out value_cantidad);

		cantidad = (int) value_cantidad;

		return cantidad;
	}
}
