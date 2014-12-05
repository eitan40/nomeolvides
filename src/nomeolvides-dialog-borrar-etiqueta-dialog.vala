/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* Nomeolvides
 * 
 * Copyright (C) 2014 Andres Fernandez <andres@softwareperonista.com.ar>
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

public class Nomeolvides.BorrarEtiquetaDialogo : Dialog {
	public BorrarEtiquetaDialogo ( Etiqueta etiqueta_a_borrar, int cantidad_hechos ) {
		this.set_modal ( true );
		this.title = _("Delete Custom List");
	
		Label pregunta = new Label.with_mnemonic ( _("Do you want to remove custom list?") );
		Label etiqueta_nombre_label = new Label.with_mnemonic ( _("List") + ":");
		Label etiqueta_nombre = new Label ( "" );
		Label etiqueta_hechos_label = new Label.with_mnemonic ( _("Amount of facts") + ":");
		Label etiqueta_hechos = new Label ( "" );

		pregunta.set_halign ( Align.CENTER );
		pregunta.set_margin_bottom ( 15 );
		pregunta.set_hexpand ( true );
		etiqueta_nombre_label.set_halign ( Align.END );
		etiqueta_nombre_label.set_margin_bottom ( 10 );
		etiqueta_nombre.set_halign ( Align.START );
		etiqueta_nombre.set_margin_bottom ( 10 );
		etiqueta_hechos_label.set_halign ( Align.END );
		etiqueta_hechos.set_halign ( Align.START );

		etiqueta_nombre.set_markup ( "<span font_weight=\"heavy\">"+ etiqueta_a_borrar.nombre +"</span>");
		etiqueta_hechos.set_markup ( "<span font_weight=\"heavy\">"+ cantidad_hechos.to_string () +"</span>");

		Grid grid = new Grid ( );
	#if DISABLE_GNOME3
		etiqueta_nombre_label.set_margin_right ( 20 );
		etiqueta_nombre.set_margin_left ( 20 );
		etiqueta_hechos_label.set_margin_right ( 20 );
		etiqueta_hechos.set_margin_left ( 20 );
		grid.set_margin_right ( 20 );
		grid.set_margin_left ( 20 );
	#else
		etiqueta_nombre_label.set_margin_end ( 20 );
		etiqueta_nombre.set_margin_start ( 20 );
		etiqueta_hechos_label.set_margin_end ( 20 );
		etiqueta_hechos.set_margin_start ( 20 );
		grid.set_margin_end ( 20 );
		grid.set_margin_start ( 20 );
	#endif
		grid.set_valign ( Align.CENTER );
		grid.set_halign ( Align.CENTER );
		grid.set_margin_top ( 20 );
		grid.set_margin_bottom ( 20 );
		grid.set_size_request ( 400, -1 );
		grid.set_hexpand ( true );

		grid.attach ( pregunta, 0, 0, 2, 1 );
		grid.attach ( etiqueta_nombre_label, 0, 1, 1, 1 );
		grid.attach ( etiqueta_nombre, 1, 1, 1, 1 );
		grid.attach ( etiqueta_hechos_label, 0, 2, 1, 1 );
		grid.attach ( etiqueta_hechos, 1, 2, 1, 1 );

		var contenido = this.get_content_area() as Box;
		contenido.pack_start ( grid, true, true, 0 );

		this.add_button ( _("Cancel"), ResponseType.REJECT );
		this.add_button ( _("Apply"), ResponseType.APPLY );

		this.show_all ();
	}
}