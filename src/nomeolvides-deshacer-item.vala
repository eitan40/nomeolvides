/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
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
using Gee;
using Nomeolvides;

public class Nomeolvides.DeshacerItem : Object {

	private Hecho borrado;
	private Hecho editado;
	private DeshacerTipo tipo;

	public DeshacerItem ( Hecho borrado, DeshacerTipo tipo ) {
		this.tipo = tipo;
		this.borrado = borrado;		
	}

	public void set_editado ( Hecho editado ) {
		this.editado = editado;
	}

	public Hecho get_borrado () {
		return this.borrado;
	}

	public Hecho get_editado () {
		return this.editado;
	}

	public DeshacerTipo get_tipo () {
		return this.tipo;
	}
}
