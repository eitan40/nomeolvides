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

public class Nomeolvides.EditFuenteDialog : DialogFuente
{
	
	public EditFuenteDialog ( )
	{
		this.title = "Editar parámetro de la Base de Datos";
		this.add_button (Stock.EDIT , ResponseType.APPLY);
	}

	public void set_datos (Fuente fuente) {
		this.nombre_fuente_entry.set_text ( fuente.nombre_fuente );
		this.archivo_chooser.set_filename ( fuente.direccion_fuente + fuente.nombre_archivo );
	}
}
