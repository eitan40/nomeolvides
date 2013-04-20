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

public class Nomeolvides.Lista : GLib.Object{
	public string nombre { get; private set; }
	public int cantidad_hechos { get; private set; }
	public string hash { get; private set; }
	
	public Lista ( string nombre ) {
		this.nombre = nombre;
		this.cantidad_hechos = 0;
		this.calcular_checksum ();
	}

	public Lista.json ( string json ) {
		if (json.contains ("{\"Lista\":{")) {
			this.nombre = this.sacarDatoJson (json, "nombre");
		} else {
			this.nombre = "null";
		}

		this.cantidad_hechos = 0;
		this.calcular_checksum ();
	}

	public string a_json () {
		string retorno = "{\"Lista\":{";
		
		retorno += "\"nombre\":\"" + this.nombre + "\"";
		retorno +="}}";	
		
		return retorno;
	}
 
	private string sacarDatoJson(string json, string campo) {
		int inicio,fin;
		inicio = json.index_of(":",json.index_of(campo)) + 2;
		fin = json.index_of ("\"", inicio);
		return json[inicio:fin];
	}

	public string get_checksum () {
		return this.hash;
	}

	private void calcular_checksum () {
		this.hash = Checksum.compute_for_string(ChecksumType.SHA1, this.a_json() );
		this.hash = this.hash.slice ( 0, 12);
	}

	public void set_cantidad ( int cant_hechos ) {
		this.cantidad_hechos = cant_hechos;
	}
}
