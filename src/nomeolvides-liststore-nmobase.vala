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

public class Nomeolvides.ListStoreNmoBase : ListStore {
	protected TreeIter iterador;
	public bool vacio { get; private set; }
	
	public ListStoreNmoBase ( Type[] tipos = { typeof(string), typeof(int), typeof(NmoBase) } ) {
		this.set_column_types(tipos);
		this.vacio = true;
	}

	public void agregar ( NmoBase elemento, int cantidad_hechos ) {
		if (elemento != null ) {
			this.append ( out this.iterador );
			this.set ( this.iterador,
						0,elemento.nombre,
						1,cantidad_hechos,
						2,elemento );
			this.vacio = false;
		}
	}

	public string a_json () {
		string json = "";
		NmoBase elemento;
		Value value_elemento;
		TreeIter iter;

		if ( this.get_iter_first( out iter ) ) {
			do {
				this.get_value(iter, 2, out value_elemento);
				elemento = value_elemento as NmoBase;
				json += elemento.a_json ()  + "\n";
			}while (this.iter_next(ref iter));
		}
		return json;
	}

	public void borrar ( NmoBase a_eliminar ) {
		Value elemento_value;
		NmoBase elemento;
		TreeIter iter;
		
		if ( this.get_iter_first( out iter ) ) {
			do {
				this.get_value(iter, 2, out elemento_value);
				elemento = elemento_value as NmoBase;
				if ( a_eliminar.hash == elemento.hash ) {
					this.remove ( iter );
					break;
				}
			}while (this.iter_next(ref iter));
		}

		if ( !( this.get_iter_first( out iter ) ) ) {
			this.vacio = true;
		}
	}

	public int get_hechos ( TreeIter iter ) {
		Value value_cantidad;
		int cantidad = 0;

		this.get_value( iter, 1, out value_cantidad );

		cantidad = (int) value_cantidad;

		print (cantidad.to_string () + "\n");

		return cantidad;
	}

	public int indice_de_id ( int64 id ) {
		Value elemento_value;
		NmoBase elemento;
		TreeIter iter;
		int i=0;

		if ( this.get_iter_first( out iter ) ) {
			do {
				this.get_value(iter, 2, out elemento_value );
				elemento = elemento_value as NmoBase;
				if ( id ==  elemento.id ) {
					break;
				}
				i++;
			}while ( this.iter_next(ref iter) );
		}

		return i;
	}
}
