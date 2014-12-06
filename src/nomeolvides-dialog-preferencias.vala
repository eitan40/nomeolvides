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
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.DialogPreferencias : Gtk.Dialog {
	private Notebook notebook;
	private PreferenciasColecciones config_colecciones;
	private PreferenciasListas config_listas;
	private PreferenciasEtiquetas config_etiquetas;
	
	public DialogPreferencias (VentanaPrincipal ventana, ListStoreColecciones colecciones, ListStoreListas listas, ListStoreEtiquetas etiquetas) {
		this.set_title (_("Preferences"));
		this.set_modal ( true );
		this.set_default_size (600, 350);
		this.set_transient_for ( ventana as Gtk.Window );

		this.config_colecciones = new PreferenciasColecciones ( colecciones );
		this.config_listas = new PreferenciasListas ( listas );
		this.config_etiquetas = new PreferenciasEtiquetas ( etiquetas );
		this.config_colecciones.cambio_colecciones_signal.connect ( this.config_listas.actualizar_liststore );

		this.notebook = new Notebook ();
		this.notebook.set_size_request ( 400, 270 );
		this.notebook.append_page ( this.config_colecciones, new Label(_("Colections") ));
		this.notebook.append_page ( this.config_listas, new Label (_("Lists") ));
		this.notebook.append_page ( this.config_etiquetas, new Label (_("Tags") ));
		Gtk.Box contenido =  this.get_content_area () as Box;
		contenido.pack_start ( this.notebook, true, true, 0 );
		
		this.add_button ( _("Close"), ResponseType.CLOSE );
		this.response.connect(on_response);
	}

	private void on_response (Dialog source, int response_id)
	{
		this.hide ();
    }

	public void set_active_listas () {
		this.notebook.set_current_page ( 1 );
		this.notebook.show_all ();
	}

	public void set_active_etiquetas () {
		this.notebook.set_current_page ( 2 );
		this.notebook.show_all ();
	}

	public void ejecutar ( ListStoreColecciones colecciones, ListStoreListas listas, ListStoreEtiquetas etiquetas ) {
		this.config_listas.actualizar_model ( listas );
		this.config_colecciones.actualizar_model ( colecciones );
		this.config_etiquetas.actualizar_model ( etiquetas );
	}

	public void set_toolbar_buttons_invisible () {
		this.config_colecciones.set_buttons_invisible ();
		this.config_listas.set_buttons_invisible ();
	}
}
