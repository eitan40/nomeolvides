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

public class Nomeolvides.ListStoreColecciones : ListStore {
	private TreeIter iterador;
	
	public ListStoreColecciones () {
		Type[] tipos= { typeof(string), typeof(bool), typeof(int),typeof(int64) };
		this.set_column_types( tipos );
	}

	public void agregar_coleccion ( Coleccion coleccion, int cantidad_hechos, AgregarModo append = AgregarModo.APPEND ) {
		if ( append == AgregarModo.APPEND ) {
			this.append ( out this.iterador );
		} else {
			this.prepend ( out this.iterador );
		}
		this.set ( this.iterador,
		           0,coleccion.nombre,
		           1,coleccion.visible,		           
			       2,cantidad_hechos,
		           3,coleccion.id);
	}

	public void borrar_coleccion ( Coleccion a_eliminar ) {
		Value coleccion;
		TreeIter iter;

		if ( this.get_iter_first( out iter ) ) {
			do {
				this.get_value(iter, 3, out coleccion);
				if ( a_eliminar.id == coleccion ) {
					this.remove ( iter );
					break;
				}
			}while (this.iter_next(ref iter));
		}	
	}

	public int indice_de_id ( int64 id ) {
		Value coleccion;
		TreeIter iter;
		int i=0;

		if ( this.get_iter_first( out iter ) ) {
			do {
				this.get_value(iter, 3, out coleccion);
				if ( id == (int64) coleccion) {
					break;
				}
				i++;
			}while (this.iter_next(ref iter));
		}

		return i;
	}

	public int get_hechos_coleccion ( TreeIter iter ) {
		Value value_cantidad;
		int cantidad = 0;

		this.get_value( iter, 3, out value_cantidad );

		cantidad = (int) value_cantidad;

		return cantidad;
	}
}

public enum Nomeolvides.AgregarModo {
    PREPEND,
    APPEND;
}
