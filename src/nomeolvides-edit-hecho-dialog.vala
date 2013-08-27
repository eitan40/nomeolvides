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

public class Nomeolvides.EditHechoDialog : Nomeolvides.DialogoHecho {
	private ArrayList<string> archivos_colecciones;
	private int64 hecho_id;
	
	public EditHechoDialog ( VentanaPrincipal ventana, ListStoreColecciones colecciones ) {
		base (ventana, colecciones );
		this.set_title ("Editar Hecho Histórico");				

		this.add_button (Stock.EDIT , ResponseType.APPLY);
		this.response.connect(on_response);

		this.archivos_colecciones = new ArrayList<string> (); // acá hay que pedir a la db las colecciones activas	
	}

	public void set_datos ( Hecho hecho_a_editar ) {
		this.nombre_entry.set_text(hecho_a_editar.nombre);
		this.descripcion_textview.buffer.text= hecho_a_editar.descripcion;
		this.fecha.set_anio(hecho_a_editar.fecha.get_year());
		this.fecha.set_mes(hecho_a_editar.fecha.get_month());
		this.fecha.set_dia(hecho_a_editar.fecha.get_day_of_month());
		this.fuente_entry.set_text ( hecho_a_editar.fuente );
		this.set_coleccion_de_hecho ( hecho_a_editar.coleccion );
		this.hecho_id = hecho_a_editar.id;
	}
	
	private void on_response (Dialog source, int response_id)
	{
        switch (response_id)
		{
    		case ResponseType.APPLY:
        		modificar();
       			break;
    		case ResponseType.CLOSE:
        		destroy();
        		break;
        }
    }
		
	private void modificar ()
	{
		this.crear_respuesta ();
		this.respuesta.id = this.hecho_id;
	}

	protected void set_coleccion_de_hecho (string archivo_coleccion ) {
		int indice;
		
		for (indice = 0; indice < this.archivos_colecciones.size; indice++ ) {
			if ( this.archivos_colecciones[indice] == archivo_coleccion ) {
				this.combo_colecciones.set_active (indice);
			} 
		}
	}
}
