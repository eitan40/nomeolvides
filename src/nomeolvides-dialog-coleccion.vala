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

public class Nomeolvides.DialogColeccion : Gtk.Dialog {
	protected Entry nombre_coleccion_entry;
	public Coleccion respuesta { get; protected set; }
	
	public DialogColeccion ( )
	{
		this.resizable = false;
		this.modal = true;

		this.add_button ( _("Cancel") , ResponseType.CLOSE);

		this.response.connect(on_response);
		
		var nombre_coleccion_label = new Label.with_mnemonic ( _("Colection name") + ": " );
		
		this.nombre_coleccion_entry = new Entry ();
		this.nombre_coleccion_entry.set_max_length ( 30 );

		var grid = new Grid ();
	#if DISABLE_GNOME3
		grid.set_margin_right ( 20 );
		grid.set_margin_left ( 20 );
	#else
		grid.set_margin_end ( 20 );
		grid.set_margin_start ( 20 );
	#endif
		grid.set_margin_top ( 30 );
		grid.set_margin_bottom ( 20 );
		grid.set_valign ( Align.CENTER );
		grid.set_halign ( Align.CENTER );
		
		grid.attach (nombre_coleccion_label, 0, 0, 1, 1);
	    grid.attach (this.nombre_coleccion_entry, 1, 0, 1, 1);
	
		var contenido = this.get_content_area() as Box;

		contenido.pack_start(grid, true, true, 0);
		
		this.show_all ();
	}

	protected void on_response (Dialog source, int response_id)
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

	protected virtual void crear_respuesta() {}
}
