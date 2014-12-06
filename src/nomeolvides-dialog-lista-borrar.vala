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
 * with this program.  If not, see <http://www.gn.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.DialogListaBorrar : DialogBaseBorrar {
	public DialogListaBorrar () {
		this.title = _("Delete Custom List");
		this.pregunta.set_label ( _("Do you want to remove custom list?") );
		this.nombre.set_label ( _("List") + ":");
		this.hechos.set_label ( _("Amount of facts") + ":");
	}
}

