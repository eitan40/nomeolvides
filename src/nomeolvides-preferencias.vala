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
 *   bullit - 39 escalones - silent love (japonesa) 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.Preferencias : Gtk.Dialog {
	private Notebook notebook;
	private ColeccionesConfig config_colecciones;
	private ListasConfig config_listas;
	
	public Preferencias (VentanaPrincipal ventana, ListStoreColecciones colecciones, ListStoreListas listas ) {
		this.set_title (_("Preferences"));
		this.set_modal ( true );
		this.set_default_size (600, 350);
		this.set_transient_for ( ventana as Gtk.Window );

		this.config_colecciones = new ColeccionesConfig ( colecciones );
		this.config_listas = new ListasConfig ( listas );
		this.config_colecciones.cambio_colecciones_signal.connect ( this.config_listas.actualizar_liststore );

		this.notebook = new Notebook ();
		this.notebook.set_size_request ( 400, 270 );
		this.notebook.set_margin_right ( 10 );
		this.notebook.set_margin_left ( 10 );
		this.notebook.append_page ( this.config_colecciones, new Label(_("Colections") ));
		this.notebook.append_page ( this.config_listas, new Label (_("Lists") ));
		Gtk.Box contenido =  this.get_content_area () as Box;
		contenido.pack_start ( this.notebook, true, true, 0 );
		
		this.add_button ( Stock.CLOSE, ResponseType.CLOSE );
		this.response.connect(on_response);
	}

	private void on_response (Dialog source, int response_id)
	{
		this.hide ();
    }

	private void armar_notebook ( ListStoreColecciones colecciones, ListStoreListas listas ) {
		
	}

	public void set_active_listas () {
		this.notebook.set_current_page (1);
		this.notebook.show_all ();
	}

	public void ejecutar ( ListStoreColecciones colecciones, ListStoreListas listas ) {
		this.config_listas.actualizar_model ( listas );
		this.config_colecciones.actualizar_model ( colecciones );
		this.armar_notebook ( colecciones, listas );
	}
}
