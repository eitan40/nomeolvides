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

public class Nomeolvides.DialogFuente : Gtk.Dialog {
	protected Entry nombre_fuente_entry;
	protected Entry nombre_archivo_entry;
	protected FileChooserButton archivo_chooser;
	public Fuente respuesta { get; protected set; }
	
	public DialogFuente ( )
	{
		this.resizable = false;
		this.modal = true;
		
		this.add_button (Stock.CANCEL , ResponseType.CLOSE);

		this.response.connect(on_response);
		
		var nombre_fuente_label = new Label.with_mnemonic ("Nombre de la base de datos: ");
		var nombre_archivo_label = new Label.with_mnemonic ("Archivo: ");
		
		this.nombre_fuente_entry = new Entry ();
		this.nombre_archivo_entry = new Entry ();
		this.archivo_chooser = new FileChooserButton ("Elija una base de datos", FileChooserAction.OPEN);

		var grid = new Grid ();
		
		grid.attach (nombre_fuente_label, 0, 0, 1, 1);
	    grid.attach (this.nombre_fuente_entry, 1, 0, 1, 1);
		grid.attach (nombre_archivo_label, 0, 1, 1, 1);
		grid.attach (this.archivo_chooser, 1, 1, 1, 1);
	
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

	protected void crear_respuesta() {
		string archivo = this.archivo_chooser.get_file ().get_path ();
		if(this.nombre_fuente_entry.get_text_length () > 0)
		{
			this.respuesta  = new Fuente (this.nombre_fuente_entry.get_text (),
			                              archivo.slice(archivo.last_index_of_char ('/') +1, archivo.char_count ()),
										  archivo.slice(0,archivo.last_index_of_char ('/') +1),
			                              true,
			                              FuentesTipo.LOCAL);
		}
	}
}
