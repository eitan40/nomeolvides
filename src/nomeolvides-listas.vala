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
	public ArrayList<Lista> listas { get; private set; }
		
	public Listas () {
		this.listas = new ArrayList<Lista> ();		
		this.cargar_listas ();
	}

	public void actualizar_listas_liststore ( ListStoreListas nueva_listas_liststore) {
		this.liststore_a_arraylist ( nueva_listas_liststore );
		this.listas_cambio_listas ();
		this.guardar_listas ();
	}

	private void guardar_listas () {
		string guardar = this.list_store_de_listas ().a_json ();
		
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
				this.listas.add ( nueva_lista );
				this.listas_cambio_listas ();
			}
		}
	}

	public ListStoreListas list_store_de_listas () {
		ListStoreListas liststore = new ListStoreListas ();
		
		foreach (Lista l in this.listas ) {		
			liststore.agregar_lista ( l );			
		}
		
		return liststore;
	}		

	private void liststore_a_arraylist ( ListStoreListas liststore ) {
		GLib.Value lista_value;
		Lista lista;
		TreeIter iterador;
		
		if ( liststore.get_iter_first ( out iterador ) ) {
			this.listas.clear ();
			do {
				liststore.get_value (iterador, 2, out lista_value);
				lista = lista_value as Lista;
				this.listas.add ( lista );
			}while ( liststore.iter_next ( ref iterador) );
		}        
	}

	public ArrayList<string> get_listas_hash () {
		ArrayList<string> listas_hash = new ArrayList<string> ();

		foreach (Lista l in this.listas) {
			listas_hash.add ( l.get_checksum () );
		}
		
		return listas_hash;	
	}

	public string get_nombre_hash ( string nombre_lista ) {
		string lista_hash = "";

		foreach ( Lista l in this.listas ) {
			if ( l.nombre == nombre_lista ) {
				lista_hash =  l.get_checksum ();
			}
		}
		
		return lista_hash;
	}

	public void guardar_listas_hechos ( string listas_hechos ) {	
		Configuracion.guardar_listas_hechos ( listas_hechos );
	}

	public void set_cantidad_hechos_listas ( TreeMap<string,int> listas_tamanios ) {
		var recorrer_listas = listas_tamanios.map_iterator ();
		recorrer_listas.next ();

		Lista lista = null;
		
		do {
			if ( recorrer_listas.valid ) {
				lista = this.get_lista_hash ( recorrer_listas.get_key () );
				if ( lista != null ) {
					lista.set_cantidad ( recorrer_listas.get_value () );
				}
			}
		} while ( recorrer_listas.next () );
	}

	private Lista get_lista_hash ( string hash ) {
		Lista lista = null;

		foreach ( Lista l in this.listas ) {
			if ( l.get_checksum () == hash ) {
				lista =  l;
			}
		}

		return lista;
	}

	public signal void listas_cambio_listas ();
}
