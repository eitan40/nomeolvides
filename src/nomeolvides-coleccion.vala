/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2013 Fernando Fernandez <fernando@softwareperonista.com.ar>
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
using GLib;
using Gee;
using Nomeolvides;

public class Nomeolvides.Coleccion : GLib.Object {

	private TreeMap<string,ArrayList<Hecho>> hechos;
	
	public Coleccion () {
		this.hechos = new TreeMap<string,ArrayList<Hecho>> ();
	}

	public void agregar ( string key, Hecho hecho ) {
		if (!(this.hechos.has_key ( key )) ) {
			this.hechos.set ( key, new ArrayList<Hecho> () );
			this.coleccion_cambio_keys ();
		}
		this.hechos.get ( key ).add ( hecho );
		this.coleccion_cambio_hechos ();
	}

	public void borrar ( Hecho hecho ) {
		if ( !this.hechos.is_empty ) {
			var recorrer_keys = this.hechos.map_iterator ();
			recorrer_keys.next ();

			do {
				var key = recorrer_keys.get_value ();
				if ( key.contains (hecho) ) {
					key.remove ( hecho );
					if ( key.size == 0 ) {
						recorrer_keys.unset ();
						this.coleccion_cambio_keys ();
					}
				}
			} while ( recorrer_keys.next () );
			this.coleccion_cambio_hechos ();
		}
	}

	public ListStoreHechos get_liststore ( string key ) {
		var key_hechos = this.hechos.get ( key );
		var liststore = new ListStoreHechos ();

		if (key_hechos != null ) {
			foreach ( Hecho h in key_hechos ) {
				liststore.agregar ( h );
			}
		}	
		
		return liststore;
	}

	public bool get_hecho_hash ( string hash, out Hecho hecho ) {

		hecho = null;

		var recorrer_keys = this.hechos.map_iterator ();
		recorrer_keys.next ();

		do {
			var key = recorrer_keys.get_value ();
			foreach (Hecho h in key) {
				if ( h.hash == hash ) {
					hecho = h;
					return true;
				}
			}
		} while ( recorrer_keys.next () );
		return false;
	}

	public ArrayList<Hecho> lista_de_hechos () {
		var array = new ArrayList<Hecho> ();
		var recorrer_keys = this.hechos.map_iterator ();
		recorrer_keys.next ();

		do {
			var key = recorrer_keys.get_value ();
			foreach (Hecho h in key) {
				array.add (h);
			}
		} while ( recorrer_keys.next () );

		return array;
	}

	public ArrayList<string> lista_key () {
		var array = new ArrayList<string> ();
		var recorrer_keys = this.hechos.map_iterator ();
		recorrer_keys.next ();

		do {
			var key = recorrer_keys.get_key ();
			array.add (key);
		} while ( recorrer_keys.next () );
		return array;
	}

	public ArrayList<string> lista_key_value () {
		var array = new ArrayList<string> ();
		var recorrer_keys = this.hechos.map_iterator ();

		recorrer_keys.first ();
		do {
			var key = recorrer_keys.get_key ();
			var listado = recorrer_keys.get_value ();
			foreach (Hecho h in listado) {
				array.add ( key + "," + h.hash );
			}
		} while ( recorrer_keys.next () );
		return array;
	}

	public signal void coleccion_cambio_keys ();
	public signal void coleccion_cambio_hechos ();
}
