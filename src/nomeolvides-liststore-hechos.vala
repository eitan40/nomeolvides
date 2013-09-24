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

public class Nomeolvides.ListStoreHechos : ListStore {
	private TreeIter iterador;
	public int anio { get; private set; }
	
	public ListStoreHechos.anio_string ( string anio) {
		this.anio = int.parse ( anio );
		this.constructor ();
	}

	public ListStoreHechos.anio_int ( int anio) {
		this.anio = anio;
		this.constructor ();
	}

	public ListStoreHechos () {
		this.constructor ();
	}

	private void constructor () {		
		Type[] tipos= { typeof (string), typeof (string), typeof (string), typeof (Hecho) };
		this.set_column_types(tipos);
		this.set_sort_column_id(3, SortType.ASCENDING);
		this.set_sort_func(3, ordenar_hechos);	
	}

	public void agregar (Hecho nuevo) {	
		this.append(out iterador);
		this.set(iterador, 0, nuevo.nombre, 1, nuevo.descripcion, 2, nuevo.fecha_to_string(), 3, nuevo);
	}

	public void eliminar (TreeIter iter, Hecho a_eliminar ) {
		this.remove (iter);
	}

	public Array<Hecho> lista_de_hechos () {
		Array<Hecho> hechos = new Array<Hecho>();
		Value hecho;
		TreeIter iter;

		if ( this.get_iter_first( out iter ) ) {
			do {
				this.get_value(iter, 3, out hecho);
				hechos.append_val ((Hecho) hecho);
			}while (this.iter_next(ref iter));
		}	
		return hechos;
	}

	public string a_json () {
		int i;
		string hechos_json = "";
		Array<Hecho> hechos = this.lista_de_hechos();
		
		for (i=0; i < hechos.length; i++) {
			hechos_json += hechos.index(i).a_json() + "\n"; 
		}

		return hechos_json; 
	}

		private int comparar_hechos (Hecho hecho1, Hecho hecho2) {

		int anio1, mes1, dia1;
		int anio2, mes2, dia2;
		
		anio1 = hecho1.fecha.get_year();
		anio2 = hecho2.fecha.get_year();
		
		mes1 = hecho1.fecha.get_month();
		mes2 = hecho2.fecha.get_month();

		dia1 = hecho1.fecha.get_day_of_month();
		dia2 = hecho2.fecha.get_day_of_month();

		if (anio1 < anio2) {
			return -1;
		} else {
			if (anio1 > anio2) {
				return 1;
			} else {
				if (mes1 < mes2) {
					return -1;
				} else {
					if (mes1 > mes2) {
						return 1;
					} else {
						if (dia1 < dia2) {
							return -1;
						} else {
							if (dia1 > dia2) {
								return 1;
							} else {
								return 0;
							}
						}
					}
				}			
			}
		}
	}
	
	
	private int ordenar_hechos (TreeModel model2, TreeIter iter1, TreeIter iter2) {
		GLib.Value val1;
		GLib.Value val2;

		this.get_value(iter1, 3, out val1);
        this.get_value(iter2, 3, out val2);

		return this.comparar_hechos((Hecho) val1, (Hecho) val2);
	}

	
}
