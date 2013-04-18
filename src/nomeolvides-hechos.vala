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
	private Coleccion hechos_anios;
	private Coleccion hechos_listas;
	
	public Hechos () {
		this.hechos_anios = new Coleccion ();
		this.hechos_listas = new Coleccion ();

		this.hechos_anios.coleccion_cambio_keys.connect ( this.signal_cambio_anios );
		this.hechos_listas.coleccion_cambio_keys.connect ( this.signal_cambio_listas );
		this.hechos_anios.coleccion_cambio_hechos.connect ( this.signal_cambio_hechos );
		this.hechos_listas.coleccion_cambio_hechos.connect ( this.signal_cambio_hechos );
	}

	public void agregar_hecho_anio ( int anio, Hecho hecho ) {
		this.hechos_anios.agregar ( anio.to_string(), hecho);
	}

	public void agregar_hecho_lista ( string lista, string hash_hecho ) {
		Hecho hecho;
		if ( this.hechos_anios.get_hecho_hash ( hash_hecho, out hecho ) ) {
			this.hechos_listas.agregar ( lista, hecho );
		}
	}

	public void borrar_hecho ( int anio, Hecho hecho ) {
		this.hechos_anios.borrar ( hecho );
		this.borrar_hecho_listas ( hecho );
	}

	public void borrar_hecho_listas ( Hecho hecho ) {
		this.hechos_listas.borrar ( hecho );
	}

	public ListStoreHechos get_anio ( int anio ) {
		return this.hechos_anios.get_liststore ( anio.to_string () );
	}

	public ListStoreHechos get_lista ( string lista ) {
		return this.hechos_listas.get_liststore ( lista );
	}

	public ArrayList<Hecho> lista_de_hechos () { 
		return this.hechos_anios.lista_de_hechos();
	}

	public ArrayList<int> get_anios () {
		var anios = new ArrayList<int> ();
		var anios_string = this.hechos_anios.lista_key ();
			
		foreach ( string s in anios_string ) {
			anios.add ( int.parse ( s ) );
		}

		return anios;
	}

	public ArrayList<string> get_listas () {
		return this.hechos_listas.lista_key ();
	}

	public void signal_cambio_anios () {
		this.hechos_cambio_anios ();
	}

	public void signal_cambio_listas () {
		this.hechos_cambio_listas ();
	}

	public void signal_cambio_hechos () {
		this.hechos_cambio_hechos ();
	}

	public signal void hechos_cambio_anios ();
	public signal void hechos_cambio_listas ();
	public signal void hechos_cambio_hechos ();
}
