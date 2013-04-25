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
	private string lista;
	private Label label_hecho;
	
	public AddHechoListaDialog ( )
	{
		this.title = "Agregar un hecho a una lista";
		this.response.connect(on_response);
		
		this.add_button ( Stock.ADD , ResponseType.APPLY );
		this.add_button ( Stock.CANCEL , ResponseType.CANCEL );

		this.listas = new ComboBox ();
		
		this.label_hecho = new Label ( null );
		
		var label_listas = new Label ( "" );

		var contenido = this.get_content_area () as Box;
		contenido.pack_start (this.label_hecho, true, true, 0 );
		contenido.pack_start (this.listas, true, false, 0 );

		this.show_all ();
	}

	public void set_hecho ( Hecho hecho ) {
		this.hecho = hecho;
		this.label_hecho.set_text ( "Agregar " + hecho.nombre );
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
    		case ResponseType.CLOSE:
        		this.destroy();
        		break;
        }
    }

	private void crear_respuesta () {
		TreeIter iter;
		Value lista_elegida;
		this.listas.get_active_iter( out iter );
		this.liststore.get_value ( iter, 0, out lista_elegida );
		this.lista = (string) lista_elegida;
	}

	public string get_lista () {
		return this.lista;
	}
}