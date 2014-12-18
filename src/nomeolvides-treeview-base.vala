/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2013 Andres Fernandez <andres@softwareperonista.com.ar>
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
 *   bullit - 39 escalones - silent love (japonesa) 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.TreeViewBase : TreeView {
	public TreeViewBase () {
		this.ventana_principal ();
		const float CENTRADO = (float)0.5;

		var cantidad_cell = new CellRendererText ();
		cantidad_cell.xalign = CENTRADO;

		this.insert_column_with_attributes ( -1, _("Amount of Facts"), cantidad_cell, "text", 1 );

	}

	public TreeViewBase.ventana_principal () {

		var nombre_cell = new CellRendererText ();
		nombre_cell.ellipsize = Pango.EllipsizeMode.END;
		nombre_cell.width_chars = 30;

		var nombre_columna = new TreeViewColumn.with_attributes ( _("Name"), nombre_cell, "text", 0 );

		nombre_columna.set_expand ( true );

		this.insert_column ( nombre_columna, -1 );

	}

	public int64 get_elemento_id () {
		var elemento = this.get_elemento ();
		return elemento.id;
	}

	public Base get_elemento () {
		TreePath path;
		TreeViewColumn columna;
		TreeIter iterador;
		Value value_elemento;
		Base elemento = new Base.vacio ();

		this.get_cursor(out path, out columna);
		if (path != null ) {
			this.get_model().get_iter( out iterador, path );
			this.get_model().get_value ( iterador, 2, out value_elemento );
			elemento = value_elemento as Base;
		}
		return elemento;
	}

	public void eliminar ( Base a_eliminar ) {
		var liststore = this.get_model() as ListStoreBase;
		liststore.borrar ( a_eliminar );
	}

	public int get_cantidad_hechos ( ) {
		TreePath path;
		TreeViewColumn columna;
		TreeIter iterador;
		int hechos = 0;

		this.get_cursor (out path, out columna);
		if (path != null ) {
			this.get_model().get_iter(out iterador, path);
			var liststore = this.get_model() as ListStoreBase;
			hechos = liststore.get_hechos ( iterador );
		}

		return hechos;
	}
}
