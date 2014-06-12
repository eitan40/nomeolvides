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
using Nomeolvides;


public class Nomeolvides.ViewHechos : Gtk.TreeView {

	public int anio_actual { get; private set; }

	public ViewHechos () {
		var nombre_cell = new CellRendererText ();

		nombre_cell.ellipsize = Pango.EllipsizeMode.END;

		var fecha_cell = new CellRendererText ();

		nombre_cell.width_chars = 30;

		this.insert_column_with_attributes (-1, _("Name"), nombre_cell, "text", 0);
		this.insert_column_with_attributes (-1, _("Date"), fecha_cell, "text", 2);
		this.model = new ListStoreHechos.anio_int (0);
		this.set_model ( new ListStoreHechos () );
		this.get_selection ().set_mode ( SelectionMode.MULTIPLE );
	}

	public void mostrar_hechos ( Array<Hecho> hechos ) {
		ListStoreHechos model = this.get_model () as ListStoreHechos;
		model.agregar_hechos ( hechos );
		cambia_anio_signal ();
	}

	public void limpiar () {
		var vacio = new ListStoreHechos();
		this.set_model ( vacio );
	}

	public TreePath get_hecho_cursor ( out Hecho hecho ) {
		TreePath path;
		TreeViewColumn columna;
		TreeIter iterador;
		Value hecho_value;

		hecho = null;
		
		this.get_cursor(out path, out columna);
		if (path != null ) {
			this.get_model().get_iter(out iterador, path);
			this.get_model().get_value (iterador, 3, out hecho_value);
			hecho = (Hecho) hecho_value;
			return path;
		} else { 
			return (TreePath) null;
		}		
	}

	 public Array<Hecho> get_hechos_seleccionados () {
		TreeIter iter;
		Value hecho_value;
		var hechos = new Array<Hecho> ();
		var liststore = this.get_model ();

		var list_path = this.get_selection ().get_selected_rows ( out liststore );

		for ( uint i = 0; i < list_path.length (); i++ ) {
			this.get_model ().get_iter ( out iter, list_path.nth_data ( i ));
			this.get_model().get_value (iter, 3, out hecho_value);
			hechos.append_val ( (Hecho) hecho_value );
		}

		return hechos;
	}

	public signal void cambia_anio_signal ();
}			
