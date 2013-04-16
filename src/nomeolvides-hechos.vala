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
	private TreeMap<string,ArrayList<Hecho>> hechos_anios;
	private TreeMap<string,ArrayList<Hecho>> hechos_listas;
	private ArrayList<string> cache_hechos_listas;
	private ArrayList<string> cache_hechos_anios;

	public Hechos () {
		this.cache_hechos_anios = new ArrayList<string> ();
		this.hechos_anios = new TreeMap<string,ArrayList<Hecho>> ();
		this.cache_hechos_listas = new ArrayList<string> ();
		this.hechos_listas = new TreeMap<string,ArrayList<Hecho>> ();
	}

	public void agregar_hecho_anio ( int anio, Hecho hecho ) {
		if (!(this.hechos_anios.has_key (anio.to_string () )) ) {
			this.hechos_anios.set ( anio.to_string (), new ArrayList<Hecho> () );
			this.cache_hechos_anios.add (anio.to_string ());
		}

		this.hechos_anios.get ( anio.to_string () ).add (hecho);
	}

	public void borrar_hecho_anio ( int anio, Hecho hecho ) {
		if (this.hechos_anios.has_key (anio.to_string () ) ) {
			this.hechos_anios.get ( anio.to_string () ).remove (hecho);
		}		
	}

	public ListStoreHechos get_anio ( int anio ) {
		var hechos = this.hechos_anios.get ( anio.to_string () );
		var liststore = new ListStoreHechos ();
			
		foreach ( Hecho h in hechos ) {
			liststore.agregar ( h );
		}

		return liststore;
	}

	public ArrayList<int> get_anios () {
		var anios = new ArrayList<int> ();
			
		foreach ( string s in this.cache_hechos_anios ) {
			anios.add ( int.parse (s) );
		}

		return anios;
	}
}
