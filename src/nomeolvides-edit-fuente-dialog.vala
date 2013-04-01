/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2012 Andres Fernandez <andres@softwareperonista.com.ar>
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

public class Nomeolvides.EditFuenteDialog : Dialog
{
	private Entry nombre_fuente_entry;
	private Entry nombre_archivo_entry;
	private Entry direccion_entry;
	private Button elegir_archivo;
	public Fuente respuesta { get; protected set; }
	
	public EditFuenteDialog ( )
	{
		this.resizable = false;
		this.modal = true;
		this.title = "Editar parámetro de la Base de Datos";
		this.add_button (Stock.CANCEL , ResponseType.CLOSE);
		this.add_button (Stock.ADD , ResponseType.APPLY);
		this.response.connect(on_response);
		
		var nombre_fuente_label = new Label.with_mnemonic ("Nombre de la Base de Datos: ");
		var nombre_archivo_label = new Label.with_mnemonic ("Nombre del Archivo: ");
		var direccion_label = new Label.with_mnemonic ("Dirección del Archivo: ");
		
		this.nombre_fuente_entry = new Entry ();
		this.nombre_archivo_entry = new Entry ();
		this.direccion_entry = new Entry ();
		this.elegir_archivo = new Button.from_stock (Stock.FILE);
		this.elegir_archivo.clicked.connect ( elegir_fuente );

		var grid = new Grid ();
		
		grid.attach (nombre_fuente_label, 0, 0, 1, 1);
	    grid.attach (this.nombre_fuente_entry, 1, 0, 1, 1);
		grid.attach (nombre_archivo_label, 0, 1, 1, 1);
		grid.attach (this.nombre_archivo_entry, 1, 1, 1, 1);
		grid.attach (direccion_label, 0 , 2 , 1 ,1);
		grid.attach (this.direccion_entry, 1 , 2 , 1 ,1);
		grid.attach (this.elegir_archivo, 2, 2, 1, 1);	
		
		var contenido = this.get_content_area() as Box;

		contenido.pack_start(grid, true, true, 0);
		
		this.show_all ();
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

	private void crear_respuesta() {
		if(this.nombre_fuente_entry.get_text_length () > 0)
		{
			this.respuesta  = new Fuente (this.nombre_fuente_entry.get_text (), 
			            				  this.nombre_archivo_entry.get_text(),
										  this.direccion_entry.get_text (),
			                              FuentesTipo.LOCAL);
		}
	}

	private void elegir_fuente () {
		OpenFileDialog elegir_archivo = new OpenFileDialog(GLib.Environment.get_current_dir ());
		elegir_archivo.set_transient_for ( this as Window );

		string path_provisorio;

		if (elegir_archivo.run () == ResponseType.ACCEPT) {
    		path_provisorio = elegir_archivo.get_filename ();
			this.direccion_entry.set_text (path_provisorio.slice(0,path_provisorio.last_index_of_char ('/') +1));
			this.nombre_archivo_entry.set_text (path_provisorio.slice(path_provisorio.last_index_of_char ('/') +1, path_provisorio.char_count ()));
		}

		elegir_archivo.destroy ();
	}

	public void set_datos (Fuente fuente) {
		this.nombre_fuente_entry.set_text ( fuente.nombre_fuente );
		this.nombre_archivo_entry.set_text ( fuente.nombre_archivo );
		this.direccion_entry.set_text ( fuente.direccion_fuente );
	}
}
