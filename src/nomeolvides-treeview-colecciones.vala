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

public class Nomeolvides.TreeViewColecciones : TreeViewNmoBase {
	private CellRendererToggle toggle_visible;
	
	public TreeViewColecciones () {
		this.insert_column_with_attributes ( -1, _("Amount of Facts"), new CellRendererText(), "text", 1 );

		this.toggle_visible = new CellRendererToggle();
		this.toggle_visible.toggled.connect ( signal_toggle );
		this.insert_column_with_attributes ( -1, _("Visible"), this.toggle_visible, "active", 3 );
	}

	public bool get_coleccion_cursor_visible () {
		TreePath path;
		TreeViewColumn columna;
		TreeIter iterador;
		Value visible = false;

		this.get_cursor(out path, out columna);
		if (path != null ) {
			this.get_model().get_iter(out iterador, path);
			this.get_model().get_value (iterador, 3, out visible);
		}

		return (bool) visible;
	}

	private void signal_toggle (string path) {

		TreePath tree_path = new Gtk.TreePath.from_string (path);
		TreeIter iter;

		var liststore = this.get_model() as ListStoreColecciones;

		liststore.get_iter (out iter, tree_path);
		liststore.set_value (iter, 3, !this.toggle_visible.active);

		this.coleccion_visible_toggle_change ();
	}
	
	public signal void coleccion_visible_toggle_change ();
}
