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

public class Nomeolvides.ListStoreAnios : ListStore {
	private TreeIter iterador;
	private Array<int> anios;
	
	public ListStoreAnios () {		
		Type[] tipos= { typeof (int) };
		this.set_column_types(tipos);
		this.anios = new Array<int>();
	}

	public void agregar ( int nuevo ) {
		if ( !(this.ya_agregado ( nuevo ) )) {
			this.append(out iterador);
			this.set(iterador, 0, nuevo );
		}
	}

	public void agregar_varios ( Array<int> nuevos ) {
		if ( nuevos.length > 0 ) {
			for ( int i = 0; i < nuevos.length; i++ ) {
				this.agregar ( nuevos.index (i));
				anios.append_val ( nuevos.index (i) );
			}

			for ( int i = 0; i < nuevos.length; i++ ) {
				this.anios.append_val ( nuevos.index (i) );
			}

			this.eliminar_sobrantes ();
		} else {
			this.clear ();
			this.anios = new Array<int> ();
		}
	}

	public bool ya_agregado ( int nuevo ) {
		bool resultado = false;

		for (int i = 0; i < this.anios.length; i++ ) {
			if ( this.anios.index (i) == nuevo ) {;
				resultado = true;
				break;
			}
		}

		return resultado;
	}

	public bool sobra ( int sobrante ) {
		bool de_mas = true;
		int i = 0;

		for ( i = 0; i < anios.length; i++ ) {
			if ( this.anios.index (i) == sobrante ) {
				de_mas = false;
				break;
			}
		}

		return de_mas;
	}

	private void eliminar_sobrantes ( ) {
		TreeIter iter;
		Value value_anio;
		int anio;
		bool flag = true;

		this.get_iter_first ( out iter );

		do {
			this.get_value ( iter, 0, out value_anio );
			anio = (int) value_anio;

			if ( this.sobra ( anio )) {
				this.remove (iter);
				flag = this.get_iter_first ( out iter );
			} else {
				flag = this.iter_next ( ref iter );
			}
		} while ( flag );
	}	
}
