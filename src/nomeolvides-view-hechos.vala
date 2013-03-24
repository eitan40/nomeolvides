/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2012 Fernando Fernandez <fernando@softwareperonista.com.ar>
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


public class Nomeolvides.ViewHechos : Gtk.TreeView {

	public int anio_actual { get; private set; }
	private ListStoreHechos anio; 

	public ViewHechos () {
		this.insert_column_with_attributes (-1, "Nombre", new CellRendererText (), "text", 0);
		this.insert_column_with_attributes (-1, "Fecha", new CellRendererText (), "text", 2);
	}

	public void mostrar_anio ( ListStoreHechos anio ) {
			this.anio = anio;
			this.set_model( this.anio );
			this.anio.set_sort_column_id(3, SortType.ASCENDING);
			this.anio.set_sort_func(3, ordenar_hechos);
			this.anio_actual = anio.anio;
			cambia_anio_signal ();
	}

	public TreePath get_hecho_cursor ( out Hecho hecho ) {
		TreePath path;
		TreeViewColumn columna;
		TreeIter iterador;
		Value hecho_value;
		
		this.get_cursor(out path, out columna);
		if (path != null ) {
			this.anio.get_iter(out iterador, path);
			this.anio.get_value (iterador, 3, out hecho_value);
			hecho = (Hecho) hecho_value;
			return path;
		} else { 
			return (TreePath) null;
		}		
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

		this.anio.get_value(iter1, 3, out val1);
        this.anio.get_value(iter2, 3, out val2);

		return this.comparar_hechos((Hecho) val1, (Hecho) val2);
	}

	public signal void cambia_anio_signal ();
}			
