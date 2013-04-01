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
		this.set_valign ( Align.START );
		
	}

	public void agregar_texto ( string texto ) {

		Label nuevo;
		string[] separado = {};

		this.eliminar_labels ();
		this.parrafos.clear (); 

		separado = texto.split("\n");

		foreach ( string s in separado ) {

			if ( s != "" ) {
				nuevo = this.crear_label ( s );
				this.parrafos.add (nuevo);
			}
		}
		
		this.mostrar();
		
	}

	private void mostrar () {

		foreach ( Label parrafo in this.parrafos ) {
			this.pack_start (parrafo);
		}
		this.show_all ();
	}

	private void eliminar_labels () {

		foreach ( Label parrafo in this.parrafos ) {
			parrafo.destroy();
		}
	}

	private Label crear_label ( string texto ) {

		Label label = new Label.with_mnemonic ("");
		label.set_line_wrap ( true );
		label.set_justify ( Justification.LEFT );
		label.set_halign ( Align.START );
		label.set_margin_left ( 10 );
		label.set_margin_bottom ( 15 );
		label.set_max_width_chars ( 30 );
		label.set_markup ("<span>"+ texto +"</span>");

		return label;
	}

}

