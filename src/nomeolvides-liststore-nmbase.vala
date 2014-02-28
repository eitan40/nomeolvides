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

public class Nomeolvides.ListStoreNmBase : ListStore {
	private TreeIter iterador;
	public bool vacio { get; private set; }
	
	public ListStoreNmBase ( Type[] tipos= { typeof(string), typeof(int), typeof(int64) } ) {
		this.set_column_types(tipos);
		this.vacio = true;
	}

	public void agregar ( NmBase elemento, int cantidad_hechos ) {
		if (elemento != null ) {
			this.append ( out this.iterador );
			this.set ( this.iterador,
						0,elemento.nombre,
						1,cantidad_hechos,
		    			2,elemento.id );
			this.vacio = false;
		}
	}

	public string a_json () {
		string json = "";
		NmBase elemento;
		Value value_elemento;
		TreeIter iter;

		if ( this.get_iter_first( out iter ) ) {
			do {
				this.get_value(iter, 2, out value_elemento);
				elemento = value_elemento as NmBase;
				json += elemento.a_json ()  + "\n";
			}while (this.iter_next(ref iter));
		}
		return json;
	}

	public void borrar_elemnto ( NmBase a_eliminar ) {
		Value elemento_id;
		TreeIter iter;
		
		if ( this.get_iter_first( out iter ) ) {
			do {
				this.get_value(iter, 2, out elemento_id);
				if ( a_eliminar.id == elemento_id ) {
					this.remove ( iter );
					break;
				}
			}while (this.iter_next(ref iter));
		}

		if ( !( this.get_iter_first( out iter ) ) ) {
			this.vacio = true;
		}
	}	
}
