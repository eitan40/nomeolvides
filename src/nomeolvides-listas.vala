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
 *   bullit - 39 escalones - silent love (japonesa) 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;
using Gee;

public class Nomeolvides.Listas : GLib.Object {
	public ListStoreListas listas_liststore { get; private set; }
		
	public Listas () {
		this.listas_liststore = new ListStoreListas ();		
		this.cargar_listas ();
	}

	public void actualizar_listas_liststore ( ListStoreListas nueva_listas_liststore) {
		this.listas_liststore = nueva_listas_liststore;
		this.guardar_listas ();
	}

	private void guardar_listas () {
		string guardar = this.listas_liststore.a_json ();
		
		Configuracion.guardar_listas ( guardar );
	}

	private void cargar_listas () {
		string todo;
		string[] lineas;
		Lista nueva_lista;
		int i;	

		todo = Configuracion.cargar_listas ();
		
		lineas = todo.split_set ("\n");
		for (i=0; i < lineas.length; i++) {
        	nueva_lista = new Lista.json(lineas[i]);
			if ( nueva_lista.nombre != "null" ) {
				this.listas_liststore.agregar_lista ( nueva_lista );
			}
		}
	}

	public ListStoreListas temp () {
		GLib.Value lista_value;
		Lista lista;
		ListStoreListas temp = new ListStoreListas ();
		TreeIter iterador;
		
		this.listas_liststore.get_iter_first ( out iterador );
		
		do {
			this.listas_liststore.get_value (iterador, 2, out lista_value);
			lista = lista_value as Lista;
			temp.agregar_lista ( lista );
		}while ( this.listas_liststore.iter_next ( ref iterador) );
		        
		return temp;
	}
}
