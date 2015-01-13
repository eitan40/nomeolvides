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
using Nomeolvides;

public class Nomeolvides.DialogHechoEditar : Nomeolvides.DialogHecho {
	private int64 hecho_id;
	
	public DialogHechoEditar ( VentanaPrincipal ventana, ListStoreColecciones colecciones ) {
		base (ventana, colecciones );
		this.set_title (_("Edit Fact"));

		this.add_button ( _("Edit") , ResponseType.APPLY);
#if DISABLE_GNOME3
#else
		this.get_widget_for_response ( ResponseType.CANCEL ).get_style_context ().add_class ( "suggested-action" );
#endif
		this.response.connect(on_response);
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
	
	private void on_response (Dialog source, int response_id) {
        switch (response_id)
		{
			case ResponseType.APPLY:
				modificar();
				break;
			case ResponseType.CANCEL:
				destroy();
				break;
        }
    }
		
	private void modificar () {
		this.crear_respuesta ();
		this.respuesta.id = this.hecho_id;
	}

	protected void set_coleccion_de_hecho ( int64 coleccion_id ) {
		ListStoreColecciones liststore = this.combo_colecciones.get_model () as ListStoreColecciones;

		this.combo_colecciones.set_active ( liststore.indice_de_id ( coleccion_id ) );
	}
}
