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

public class Nomeolvides.Deshacer : Object {
	private ArrayQueue<DeshacerItem> lista_deshacer;

	public Deshacer () {
		this.lista_deshacer = new ArrayQueue<DeshacerItem> ();
	}

	public void guardar_borrado ( Hecho borrar, DeshacerTipo tipo ) {		
		this.lista_deshacer.offer_head ( new DeshacerItem ( borrar, tipo) );
	}

	public void guardar_editado ( Hecho editado ) {
		this.lista_deshacer.peek_head ().set_editado ( editado );
	}

	public DeshacerItem deshacer () {
		DeshacerItem item = this.lista_deshacer.poll_head ();
		return item;
	}
}

public enum Nomeolvides.DeshacerTipo {
	BORRAR,
	EDITAR;
}
