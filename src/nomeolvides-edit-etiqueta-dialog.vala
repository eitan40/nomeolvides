/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2014 Andres Fernandez <andres@softwareperonista.com.ar>
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

public class Nomeolvides.EditEtiquetaDialog : DialogEtiqueta
{
	private int64 id;
	
	public EditEtiquetaDialog ( )
	{
		this.title = _("Edit Tag");
		this.add_button (_("Edit") , ResponseType.APPLY);
	}

	protected override void crear_respuesta () {
		if(this.nombre_entry.get_text_length () > 0) {
			this.respuesta  = new Etiqueta (this.nombre_entry.get_text ());
			this.respuesta.id = this.id;
		}
	}

	public void set_datos ( Etiqueta etiqueta ) {
		this.nombre_entry.set_text ( etiqueta.nombre );
		this.id = etiqueta.id;
	}
}