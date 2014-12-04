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

public class Nomeolvides.DialogBaseBorrar : Dialog {
	protected Label pregunta;
	protected Label nombre;
	protected Label nombre_objeto;
	protected Label hechos;
	protected Label hechos_objeto;

	public DialogBaseBorrar () {
		this.set_modal ( true );

		this.pregunta = new Label.with_mnemonic ( "" );
		this.nombre = new Label.with_mnemonic ( "" );
		this.nombre_objeto = new Label ( "" );
		this.hechos = new Label.with_mnemonic ( "" );
		this.hechos_objeto = new Label ( "" );
		Grid grid = new Grid ( );

		pregunta.set_halign ( Align.CENTER );
		pregunta.set_margin_bottom ( 15 );
		pregunta.set_hexpand ( true );
		nombre.set_halign ( Align.END );
		nombre.set_margin_bottom ( 10 );
		nombre_objeto.set_halign ( Align.START );
		nombre_objeto.set_margin_bottom ( 10 );
		hechos.set_halign ( Align.END );
		hechos_objeto.set_halign ( Align.START );
#if DISABLE_GNOME3
		nombre.set_margin_right ( 20 );
		nombre_objeto.set_margin_left ( 20 );
		hechos.set_margin_right ( 20 );
		hechos_objeto.set_margin_left ( 20 );
		grid.set_margin_right ( 20 );
		grid.set_margin_left ( 20 );
#else
		nombre.set_margin_end ( 20 );
		nombre_objeto.set_margin_start ( 20 );
		hechos.set_margin_end ( 20 );
		hechos_objeto.set_margin_start ( 20 );
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
		grid.attach ( nombre, 0, 1, 1, 1 );
		grid.attach ( nombre_objeto, 1, 1, 1, 1 );
		grid.attach ( hechos, 0, 2, 1, 1 );
		grid.attach ( hechos_objeto, 1, 2, 1, 1 );

		var contenido = this.get_content_area() as Box;
		contenido.pack_start ( grid, true, true, 0 );

		this.add_button ( _("Cancel"), ResponseType.REJECT );
		this.add_button ( _("Apply"), ResponseType.APPLY );
	}

	public void set_datos ( Base objeto_a_borrar, int cantidad_hechos ) {
		nombre_objeto.set_markup ( "<span font_weight=\"heavy\">"+ objeto_a_borrar.nombre +"</span>");
		hechos_objeto.set_markup ( "<span font_weight=\"heavy\">"+ cantidad_hechos.to_string () +"</span>");
	}
}
