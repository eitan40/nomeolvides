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

public class Nomeolvides.VistaHecho : Box {
	private Label label_nombre;
	private Label label_fecha;
	private DescripcionHecho descripcion;
	private Label label_fuente;
	
	public VistaHecho () {
		this.set_orientation ( Orientation.VERTICAL );
		this.set_spacing ( 10 );
		this.set_homogeneous ( false );
		this.set_hexpand ( false );

		var scroll_descripcion = new ScrolledWindow ( null, null );
		scroll_descripcion.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		
		this.label_nombre = new Label.with_mnemonic ("");
		this.label_fecha = new Label.with_mnemonic ("");
		this.descripcion = new DescripcionHecho ();
		this.label_fuente = new Label.with_mnemonic ("");

		this.label_nombre.set_width_chars ( 30 );
		this.label_fecha.set_width_chars ( 30 );
		this.label_fuente.set_width_chars ( 30 );

		this.label_nombre.set_line_wrap ( true );
		this.label_fecha.set_alignment ( 0, 0 );
		this.label_fuente.set_alignment ( 0, 0 );
		
		scroll_descripcion.add_with_viewport ( this.descripcion );

		this.pack_start ( this.label_nombre, false, false, 0 );
		this.pack_start ( this.label_fecha, false, false, 0 );
		this.pack_start ( scroll_descripcion, true, true, 0 );
		this.pack_start ( this.label_fuente, false, false, 0 );
	}

	public bool set_datos_hecho ( Hecho a_mostrar ) {
		bool retorno = false;

		if ( a_mostrar != null ) {
			this.label_nombre.set_markup ("<span font_size=\"x-large\" font_weight=\"heavy\">"+ a_mostrar.nombre +"</span>");
			this.label_fecha.set_markup ("<span font_style=\"italic\">"+ a_mostrar.fecha_to_string () +"</span>");
			this.descripcion.agregar_texto ( a_mostrar.descripcion );
			if (a_mostrar.fuente != "") {
				this.label_fuente.set_markup ("Fuente: <span font_style=\"italic\">"+ a_mostrar.fuente +"</span>");
				this.label_fuente.visible = true;
			} else {
				this.label_fuente.visible = false;
			}

			retorno = true;
		}

		return retorno;
	}
}
