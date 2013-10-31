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

public class Nomeolvides.AddHechoListaDialog : Dialog
{	
	private ComboBox listas;
	private ListStoreListas liststore;
	private Hecho hecho;
	private int64 id_lista;
	private Label label_hecho;
	
	public AddHechoListaDialog ( VentanaPrincipal ventana )
	{
		this.title = _("Add Fact to List");
		this.set_default_size ( 350,-1 );
		this.set_transient_for ( ventana as Window );
		
		this.response.connect(on_response);

		this.add_button ( Stock.CANCEL , ResponseType.CANCEL );
		this.add_button ( Stock.ADD , ResponseType.APPLY );

		this.listas = new ComboBox ();

		var grid = new Grid ( );
		grid.set_row_spacing ( 15 );
		grid.set_column_spacing ( 20 );
		grid.set_margin_right ( 30 );
		grid.set_margin_left ( 30 );
		grid.set_margin_top ( 15 );
		grid.set_margin_bottom ( 15 );
		grid.set_valign ( Align.CENTER );
		grid.set_halign ( Align.CENTER );
		
		this.label_hecho = new Label ( null );
		if( this.label_hecho.get_lines () > 50 ) {
			this.label_hecho.set_size_request ( 150, -1 );
			this.label_hecho.set_line_wrap_mode ( Pango.WrapMode.WORD );
			this.label_hecho.set_line_wrap ( true );
		}

		var label_pregunta = new Label (_("Add") + ":");
		var label_listas = new Label ( _("to list") );
		
		grid.attach ( label_pregunta, 0, 0, 1, 1 );
		grid.attach ( this.label_hecho, 1, 0, 1, 1 );
		grid.attach ( label_listas, 0, 1, 1, 1 );
		grid.attach ( this.listas, 1, 1, 1, 1 );

		var contenido = this.get_content_area () as Box;
		contenido.pack_start (grid, true, true, 0 );

		this.show_all ();
	}

	public void set_hecho ( Hecho hecho ) {
		this.hecho = hecho;
		this.label_hecho.set_markup ( "<span font_weight=\"heavy\">"+ hecho.nombre +"</span>");
	}

	public void set_listas ( ListStoreListas liststore) {
		CellRendererText renderer = new CellRendererText ();
		this.listas.pack_start (renderer, true);
		this.listas.add_attribute (renderer, "text", 0);
		this.listas.active = 0;
		this.liststore = liststore;
		this.listas.set_model ( liststore );
	}

	private void on_response (Dialog source, int response_id)
	{
        switch (response_id)
		{
    		case ResponseType.APPLY:
        		this.crear_respuesta ();
				break;
    		case ResponseType.CANCEL:
        		this.hide ();
        		break;
        }
    }

	private void crear_respuesta () {
		TreeIter iter;
		Value lista_elegida;
		this.listas.get_active_iter( out iter );
		this.liststore.get_value ( iter, 2, out lista_elegida );
		this.id_lista = (int64) lista_elegida;
	}

	public int64 get_id_lista () {
		return this.id_lista;
	}
}
