/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2012 Fernando <fernando@softwareperonista.com.ar>
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
using Gee;

public class Nomeolvides.ViewAnios : TreeView {

	private ListStore lista;
	private TreeIter iter;
	
	public ViewAnios () {
		this.lista = new ListStore(1,typeof(int));
		this.set_model (this.lista);
		var celda = new CellRendererText();
		this.insert_column_with_attributes (-1,"Años", celda, "text",0);
		this.lista.set_sort_column_id(0, SortType.ASCENDING);
		this.lista.set_sort_func(2, ordenar_anios);
		this.set_size_request (100, -1);

	}

	public void agregar (int nuevo)
	{
		this.lista.append (out this.iter);
		this.lista.set(this.iter,0,nuevo);
	}

	public void agregar_varios (Array<int> nuevo)
	{
		int i, temp;
		
		this.lista.clear ();
			
		for (i=0; i < nuevo.length; i++)
		{
			temp = nuevo.index(i);
			this.agregar ( temp );
		}
	}

	public int get_anio () {
		TreePath path;
		TreeViewColumn columna;
		TreeIter iterador;
		Value valor;
		
		this.get_cursor(out path, out columna);
		if (path != null ) {
			this.lista.get_iter(out iterador, path);
			this.lista.get_value (iterador, 0, out valor);
			return (int)valor;
		} else { 
			return 0; //retorna el número mágico 0. No existe el año 0, por lo tanto, no hay año elegido.
		}
	}

	public void borrar_datos () {
		this.lista.clear ();
	}

	private int ordenar_anios (Gtk.TreeModel model2, Gtk.TreeIter iter1, Gtk.TreeIter iter2) {
		GLib.Value val1;
		GLib.Value val2;

		int anio1;
		int anio2;

		this.lista.get_value(iter1, 0, out val1);
        this.lista.get_value(iter2, 0, out val2);

		anio1 = (int) val1;
		anio2 = (int) val2;

		if (anio1 < anio2) {
			return -1;
		} else {
			if (anio1 > anio2) {
				return 1;
			} else {
				return 0;
			}
		}
			
	}
}
