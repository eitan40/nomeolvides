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
using Gee;
using Nomeolvides;

public class Nomeolvides.AddHechoListaDialog : Dialog
{	
	private ComboBox listas;
	private ListStoreListas liststore;
	private Hecho hecho;
	private Lista lista;
	private Label label_hecho;
	
	public AddHechoListaDialog ( VentanaPrincipal ventana )
	{
		this.title = "Agregar un hecho a una lista";
		this.set_default_size (270,150);
		this.set_size_request (250,125);
		this.set_transient_for ( ventana as Window );
		
		this.response.connect(on_response);

		this.add_button ( Stock.CANCEL , ResponseType.CANCEL );
		this.add_button ( Stock.ADD , ResponseType.APPLY );

		this.listas = new ComboBox ();
		
		this.label_hecho = new Label ( null );

		var label_pregunta = new Label ("Quiere agregar el hecho:");
		var label_listas = new Label ( "a la lista " );

		var box_principal = new Box (Orientation.VERTICAL, 0 );
		box_principal.pack_start (label_pregunta, true, true, 0 );
		box_principal.pack_start (this.label_hecho, true, true, 0 );
		var box_listas = new Box ( Orientation.HORIZONTAL, 0);
		box_listas.pack_start (label_listas, false, false, 0 );
		box_listas.pack_start (this.listas, true, false, 0 );
		box_principal.pack_start (box_listas, false, false, 0 );

		var contenido = this.get_content_area () as Box;
		contenido.pack_start (box_principal, true, true, 0 );

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
		this.lista = (Lista) lista_elegida;
	}

	public Lista get_lista () {
		return this.lista;
	}
}
