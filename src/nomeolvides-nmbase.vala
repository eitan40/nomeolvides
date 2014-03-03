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

using Gtk;
using Nomeolvides;

public class Nomeolvides.NmBase : GLib.Object{
	public int64 id;
	public string nombre { get; protected set; }
	public string hash { get; protected set; }
	
	public NmBase ( string nombre ) {
		this.nombre = nombre;
		this.calcular_checksum ();
	}

	public NmBase.json ( string json ) {
		if ( json != "null") {
			this.nombre = this.sacarDatoJson (json, "nombre");
		} else {
			this.nombre = "null";
		}	
		this.calcular_checksum ();
	}

	public NmBase.vacio () {

	}

	public string a_json () {	
		var retorno = "\"nombre\":\"" + this.nombre + "\"";
		
		return retorno;
	}

	public string a_sql () {
		var retorno  = "nombre=\"" + this.nombre + "\"";
		
		return retorno;
	}

	public string to_string () {
		var retorno  = "\"" + this.nombre + "\"";
		
		return retorno;
	}
 
	protected string sacarDatoJson(string json, string campo) {
		int inicio,fin;
		inicio = json.index_of(":",json.index_of(campo)) + 2;
		fin = json.index_of ("\"", inicio);
		return json[inicio:fin];
	}

	public string get_checksum () {
		return this.hash;
	}

	protected void calcular_checksum () {
		this.hash = Checksum.compute_for_string(ChecksumType.SHA1, this.a_json() );
		this.hash = this.hash.slice ( 0, 12);
	}
}
