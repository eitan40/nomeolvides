/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2013 Fernando Fernandez <berel@pulqui>
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

using Nomeolvides;
using GLib;
using Gtk;
using Gee;

public class Nomeolvides.DescripcionHecho : Box {

	private ArrayList<Label> parrafos;

	public DescripcionHecho ( ) {

		this.parrafos = new ArrayList<Label> ();
		this.set_orientation ( Orientation.VERTICAL );
		
	}

	public void agregar_texto ( string texto ) {

		Label nuevo;
		string[] separado = {};

		this.eliminar_label ();
		this.parrafos.clear (); 

		separado = texto.split("/n");

		foreach ( string s in separado ) {
			
			nuevo = new Label.with_mnemonic ("");
			nuevo.set_line_wrap ( true );
			nuevo.set_width_chars ( 30 );
			nuevo.set_max_width_chars ( 30 );
			nuevo.set_markup ("<span>"+ s +"</span>");
			
			this.parrafos.add (nuevo);
		}
		
		this.mostrar();
		
	}

	private void mostrar () {

		foreach ( Label parrafo in this.parrafos ) {
			this.pack_start (parrafo);
		}
		this.show_all ();
	}

	private void eliminar_label () {

		foreach ( Label parrafo in this.parrafos ) {
			parrafo.destroy();
		}
	}

}

