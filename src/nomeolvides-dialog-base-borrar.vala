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
#if DISABLE_GNOME3
public class Nomeolvides.DialogBaseBorrar : Dialog {
#else
public class Nomeolvides.DialogBaseBorrar : Popover {
	protected Button aplicar_button;
	protected Button cancelar_button;
	protected Base objeto;
#endif
	protected Label pregunta;
	protected Label nombre;
	protected Label nombre_objeto;
	protected Label hechos;
	protected Label hechos_objeto;
#if DISABLE_GNOME3
	public DialogBaseBorrar () {
		this.set_modal ( true );
#else
	public DialogBaseBorrar ( Widget relative_to ) {
		GLib.Object ( relative_to: relative_to);
#endif
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
		hechos_objeto.set_margin_bottom ( 20 );
		grid.set_margin_end ( 20 );
		grid.set_margin_start ( 20 );
		this.cancelar_button = new Button.with_mnemonic ( _("Cancel") );
		this.aplicar_button = new Button.with_mnemonic ( _("Apply") );	
		this.cancelar_button.set_border_width ( 5 );
		this.aplicar_button.set_border_width ( 5 );
		this.aplicar_button.clicked.connect ( this.aplicar );
		this.cancelar_button.clicked.connect ( this.ocultar );
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
#if DISABLE_GNOME3
		var contenido = this.get_content_area() as Box;
		contenido.pack_start ( grid, true, true, 0 );

		this.add_button ( _("Cancel"), ResponseType.REJECT );
		this.add_button ( _("Apply"), ResponseType.APPLY );
#else
		this.closed.connect ( this.ocultar );
		grid.attach ( cancelar_button, 0, 3, 1, 1 );
		grid.attach ( aplicar_button, 1, 3, 1, 1 );
		this.add ( grid );
#endif
	}

	public void set_datos ( Base objeto_a_borrar, int cantidad_hechos ) {
		nombre_objeto.set_markup ( "<span font_weight=\"heavy\">"+ objeto_a_borrar.nombre +"</span>");
		hechos_objeto.set_markup ( "<span font_weight=\"heavy\">"+ cantidad_hechos.to_string () +"</span>");
	#if DISABLE_GNOME3
	#else
		this.objeto = objeto_a_borrar;
	#endif
	}
#if DISABLE_GNOME3
#else
	protected void ocultar (){
		this.signal_cerrado ( this.get_relative_to () );
		this.hide ();
	}

	protected void aplicar () {
		this.signal_borrar ( this.objeto );
		this.ocultar ();
	}

	public signal void signal_borrar ( Base objeto );
	public signal void signal_cerrado ( Widget relative_to );
#endif
}
