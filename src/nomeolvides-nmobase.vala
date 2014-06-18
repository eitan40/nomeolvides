/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2014 Andres Fernandez <andres@softwareperonista.com.ar>
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

using Nomeolvides;

public class Nomeolvides.NmoBase : GLib.Object{
	public int64 id;
	public string nombre { get; protected set; }
	public string hash { get; protected set; }
	
	public NmoBase ( string nombre ) {
		this.nombre = Utiles.ponerCaracterEspecial ( nombre );
		this.hash = Utiles.calcular_checksum ( this.a_json () );
	}

	public NmoBase.json ( string json ) {
		if ( json != "null") {
			this.nombre = Utiles.sacarDatoJson ( json, "nombre" );
		} else {
			this.nombre = "null";
		}	
		this.hash = Utiles.calcular_checksum ( this.a_json () );
	}

	public NmoBase.vacio () {

	}

	public string a_json () {	
		var retorno = "\"nombre\":\"" + Utiles.sacarCaracterEspecial ( this.nombre ) + "\"";
		
		return retorno;
	}

	public string a_sql () {
		var retorno  = "nombre=\"" + Utiles.sacarCaracterEspecial ( this.nombre ) + "\"";
		
		return retorno;
	}

	public string to_string () {
		var retorno  = "\"" + Utiles.sacarCaracterEspecial ( this.nombre ) + "\"";
		
		return retorno;
	}

	public string get_checksum () {
		return this.hash;
	}
}
