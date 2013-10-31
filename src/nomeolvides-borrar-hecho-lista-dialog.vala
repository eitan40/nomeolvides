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
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.BorrarHechoListaDialog : Dialog
{	
	private Hecho hecho;
	private Lista lista;
	private Label hecho_nombre;
	private Label lista_nombre;
	
	public BorrarHechoListaDialog ( VentanaPrincipal ventana )
	{
		this.title = _("Remove Fact from List");
		this.set_transient_for ( ventana as Window );

		Label pregunta = new Label.with_mnemonic ( _("Do you want to remove this fact from the list?") );
		Label hecho_label = new Label.with_mnemonic ( _("Fact") + ":");
		this.hecho_nombre = new Label ( "" );
		Label lista_label = new Label.with_mnemonic ( _("From list") + ":");
		this.lista_nombre = new Label ( "" );

		pregunta.set_halign ( Align.CENTER );
		pregunta.set_margin_bottom ( 15 );
		pregunta.set_hexpand ( true );
		hecho_label.set_halign ( Align.END );
		hecho_label.set_margin_right ( 20 );
		hecho_label.set_margin_bottom ( 10 );
		hecho_nombre.set_halign ( Align.START );
		hecho_nombre.set_margin_left ( 20 );
		hecho_nombre.set_margin_bottom ( 10 );
		lista_label.set_halign ( Align.END );
		lista_label.set_margin_right ( 20 );
		lista_nombre.set_halign ( Align.START );
		lista_nombre.set_margin_left ( 20 );

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
		grid.attach ( hecho_label, 0, 1, 1, 1 );
		grid.attach ( hecho_nombre, 1, 1, 1, 1 );
		grid.attach ( lista_label, 0, 2, 1, 1 );
		grid.attach ( lista_nombre, 1, 2, 1, 1 );
		
		this.response.connect ( on_response );

		this.add_button ( Stock.CANCEL , ResponseType.CANCEL );
		this.add_button ( Stock.REMOVE , ResponseType.APPLY );

		var contenido = this.get_content_area () as Box;
		contenido.pack_start ( grid, true, true, 0 );

		this.show_all ();
	}

	public void set_hecho ( Hecho hecho ) {
		this.hecho = hecho;
		this.hecho_nombre.set_markup ( "<span font_weight=\"heavy\">"+ hecho.nombre +"</span>");
	}

	public void set_lista ( Lista lista ) {
		this.lista_nombre.set_markup ( "<span font_weight=\"heavy\">"+ lista.nombre +"</span>");
		this.lista = lista;
	}

	private void on_response (Dialog source, int response_id)
	{
        switch (response_id)
		{
    		case ResponseType.CANCEL:
        		this.hide ();
        		break;
        }
    }

	public Lista get_lista () {
		return this.lista;
	}
}