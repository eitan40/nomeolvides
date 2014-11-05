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

public class Nomeolvides.DialogColeccionEditar : DialogNmoBase {
	private int64 id_coleccion;
	 
	public DialogColeccionEditar () {
		this.title = _("Edit Collection");
		base.nombre_label.set_label ( _("Colection name") + ": " );
		this.add_button ( _("Edit") , ResponseType.APPLY);
	}

	public void set_datos (Coleccion coleccion) {
		this.nombre_entry.set_text ( coleccion.nombre );
		this.id_coleccion = coleccion.id;
	}

	protected override void crear_respuesta() {
		if(this.nombre_entry.get_text_length () > 0)
		{
			this.respuesta = new Coleccion (this.nombre_entry.get_text (), true);
			this.respuesta.id = this.id_coleccion;
		}
	} 
}
