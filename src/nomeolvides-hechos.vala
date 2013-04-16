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

public class Nomeolvides.Hechos : Object {
	private TreeMap<int,ArrayList<Hecho>> hechos_anios;
	private TreeMap<string,ArrayList<Hecho>> hechos_listas;
	private ArrayList<int> cache_hechos_anios;
	private ArrayList<string> cache_hechos_listas;

	public Hechos () {
		this.cache_hechos_anios = new ArrayList<int> ();
		this.hechos_anios = new TreeMap<int,ArrayList<Hecho>> ();
		this.cache_hechos_listas = new ArrayList<string> ();
		this.hechos_listas = new TreeMap<string,ArrayList<Hecho>> ();
	}

	public void agregar_hecho_anio ( int anio, Hecho hecho ) {
		if (!(this.hechos_anios.has_key ( anio )) ) {
			this.hechos_anios.set ( anio, new ArrayList<Hecho> () );
			this.cache_hechos_anios.add ( anio );
		}
		this.hechos_anios.get ( anio ).add ( hecho );
	}

	public void agregar_hecho_lista ( string lista, string hash_hecho ) {
		var recorrer_anios = this.hechos_anios.map_iterator ();
		recorrer_anios.next();

		do {
			var anio = recorrer_anios.get_value ();
			foreach ( Hecho h in anio ) {
				if (!(this.hechos_listas.has_key (lista) )) {
					this.hechos_listas.set ( lista, new ArrayList<Hecho> () );
					this.cache_hechos_listas.add (lista);
				}
				this.hechos_listas.get ( lista ).add ( h );
			}
			recorrer_anios.next ();
		} while ( recorrer_anios.has_next () );
	}

	public void borrar_hecho ( int anio, Hecho hecho ) {
		if (this.hechos_anios.has_key (anio ) ) {
			this.hechos_anios.get ( anio ).remove (hecho);
		}
		this.borrar_hecho_listas ( hecho );
	}

	public void borrar_hecho_listas ( Hecho hecho ) {
		var recorrer_listas = this.hechos_listas.map_iterator ();
		recorrer_listas.next ();

		do {
			var lista = recorrer_listas.get_value ();
			if ( lista.contains (hecho) ) {
				lista.remove ( hecho );
			}
			recorrer_listas.next ();
		} while ( recorrer_listas.has_next () );
	}

	public ListStoreHechos get_anio ( int anio ) {
		var hechos = this.hechos_anios.get ( anio );
		var liststore = new ListStoreHechos ();
		
		if (hechos != null ) {	
			foreach ( Hecho h in hechos ) {
				liststore.agregar ( h );
			}
		}
			
		return liststore;
	}

	public ListStoreHechos get_lista ( string lista ) {
		var hechos = this.hechos_listas.get ( lista );
		var liststore = new ListStoreHechos ();

		if (hechos != null ) {
			foreach ( Hecho h in hechos ) {
				liststore.agregar ( h );
			}
		}	

		return liststore;
	}

	public ArrayList<int> get_anios () {
		var anios = new ArrayList<int> ();
			
		foreach ( int anio in this.cache_hechos_anios ) {
			anios.add ( anio );
		}

		return anios;
	}

	public ArrayList<string> get_listas () {
		var listas = new ArrayList<string> ();
			
		foreach ( string s in this.cache_hechos_listas ) {
			listas.add ( s );
		}

		return listas;
	}
}
