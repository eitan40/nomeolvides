/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* Nomeolvides
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
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.BorrarColeccionDialogo : Dialog {
	public BorrarColeccionDialogo ( Coleccion coleccion_a_borrar, int cantidad_hechos ) {
		this.set_modal ( true );
		this.title = _("Delete Collection");
		Label pregunta = new Label.with_mnemonic ( _("Do you want to remove this collection?") );
		Label coleccion_nombre_label = new Label.with_mnemonic ( _("Colection") + ":");
		Label coleccion_nombre = new Label ( "" );
		Label coleccion_hechos_label = new Label.with_mnemonic ( _("Amount of facts") + ":");
		Label coleccion_hechos = new Label ( "" );

		pregunta.set_halign ( Align.CENTER );
		pregunta.set_margin_bottom ( 15 );
		pregunta.set_hexpand ( true );
		coleccion_nombre_label.set_halign ( Align.END );
		coleccion_nombre_label.set_margin_right ( 20 );
		coleccion_nombre.set_halign ( Align.START );
		coleccion_nombre.set_margin_left ( 20 );
		coleccion_hechos_label.set_halign ( Align.END );
		coleccion_hechos_label.set_margin_right ( 20 );
		coleccion_hechos.set_halign ( Align.START );
		coleccion_hechos.set_margin_left ( 20 );

		coleccion_nombre.set_markup ( "<span font_weight=\"heavy\">"+ coleccion_a_borrar.nombre +"</span>");
		coleccion_hechos.set_markup ( "<span font_weight=\"heavy\">"+ cantidad_hechos.to_string () +"</span>");

		Grid grid = new Grid ( );

		grid.set_valign ( Align.CENTER );
		grid.set_halign ( Align.CENTER );
		grid.set_margin_right ( 20 );
		grid.set_margin_left ( 20 );
		grid.set_margin_top ( 20 );
		grid.set_margin_bottom ( 20 );
		grid.set_size_request ( 400, -1 );
		grid.set_hexpand ( true );

		grid.attach ( pregunta, 0, 0, 2, 1 );
		grid.attach ( coleccion_nombre_label, 0, 1, 1, 1 );
		grid.attach ( coleccion_nombre, 1, 1, 1, 1 );
		grid.attach ( coleccion_hechos_label, 0, 2, 1, 1 );
		grid.attach ( coleccion_hechos, 1, 2, 1, 1 );

		var contenido = this.get_content_area() as Box;
		contenido.pack_start ( grid, true, true, 0 );

		this.add_button ( Stock.APPLY, ResponseType.APPLY );
		this.add_button ( Stock.CANCEL, ResponseType.REJECT );

		this.show_all ();
	}
}
