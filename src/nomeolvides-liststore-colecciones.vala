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

public class Nomeolvides.ListStoreColecciones : ListStore {
	private TreeIter iterador;
	
	public ListStoreColecciones () {
		Type[] tipos= { typeof(string), typeof(bool), typeof(Coleccion) };
		this.set_column_types(tipos);
	}

	public void agregar_coleccion ( Coleccion coleccion ) {		
		this.append ( out this.iterador );
		this.set ( this.iterador,
		           0,coleccion.nombre,
		           1,coleccion.visible,
			       2,coleccion );
	}

	public void borrar_coleccion ( TreeIter iter, Coleccion a_eliminar ) {
		this.remove ( iter );
	} 
}
