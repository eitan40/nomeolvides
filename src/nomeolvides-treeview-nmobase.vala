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

public class Nomeolvides.TreeViewNmoBase : TreeView {
	public TreeViewNmoBase () {
		var nombre_cell = new CellRendererText ();

		nombre_cell.ellipsize = Pango.EllipsizeMode.END;

		nombre_cell.width_chars = 30;

		this.insert_column_with_attributes ( -1, _("Name"), nombre_cell, "text", 0 );
	}

	public int64 get_elemento_id () {
		TreePath path;
		TreeViewColumn columna;
		TreeIter iterador;
		Value value_elemento;
		Base elemento;
		int64 id = -1;

		this.get_cursor(out path, out columna);
		if (path != null ) {
			this.get_model().get_iter(out iterador, path);
			this.get_model().get_value (iterador, 2, out value_elemento);
			elemento = value_elemento as Base;
			id = elemento.id;
		}
		
		return id;
	}

	public void eliminar ( Base a_eliminar ) {
		var liststore = this.get_model() as ListStoreNmoBase;
		liststore.borrar ( a_eliminar );
	}

	public int get_hechos ( ) {
		TreePath path;
		TreeViewColumn columna;
		TreeIter iterador;
		int hechos = 0;

		this.get_cursor (out path, out columna);
		if (path != null ) {
			this.get_model().get_iter(out iterador, path);
			var liststore = this.get_model() as ListStoreNmoBase;
			hechos = liststore.get_hechos ( iterador );
		}

		return hechos;
	}
}
