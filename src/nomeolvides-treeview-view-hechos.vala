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
		this.model = new ListStoreHechos.anio_int (0);
	}

	public void mostrar_anio ( ListStoreHechos anio ) {
			this.anio = anio;
			this.set_model( this.anio );
			this.anio_actual = anio.anio;
			cambia_anio_signal ();
	}

	public TreePath get_hecho_cursor ( out Hecho hecho ) {
		TreePath path;
		TreeViewColumn columna;
		TreeIter iterador;
		Value hecho_value;

		hecho = null;
		
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

	public signal void cambia_anio_signal ();
}			
