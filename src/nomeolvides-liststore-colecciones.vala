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

public class Nomeolvides.ListStoreColecciones : ListStoreBase {
	public ListStoreColecciones () {
		Type[] tipos= { typeof(string), typeof(int),typeof(Base), typeof(bool) };
		this.set_column_types( tipos );
	}

	public new void agregar ( Coleccion coleccion, int cantidad_hechos ) {
		base.agregar ( coleccion, cantidad_hechos );
		this.set_value ( this.iterador, 3, coleccion.visible ); 
	}

	public void agregar_al_inicio ( Coleccion coleccion, int cantidad_hechos) {
		this.prepend ( out this.iterador );

			this.set ( this.iterador,
					0,coleccion.nombre,
					1,cantidad_hechos,
					2,coleccion,
			        3,coleccion.visible);
			} 
}
