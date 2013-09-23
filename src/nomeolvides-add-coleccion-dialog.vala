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

public class Nomeolvides.AddColeccionDialog : DialogColeccion
{	
	public AddColeccionDialog ( )
	{
		this.title = "Agregar parámetos de una coleccion";
		this.add_button (Stock.ADD , ResponseType.APPLY);
	}

	protected override void crear_respuesta() {
		if(this.nombre_coleccion_entry.get_text_length () > 0)
		{
			this.respuesta  = new Coleccion (this.nombre_coleccion_entry.get_text (), true);
		}
	}
}
