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

public class Nomeolvides.Coleccion : GLib.Object{
	public int64 id;
	public string nombre { get; private set; }
	public bool visible {get; set; }

	public Coleccion ( string nombre, bool visible ) {
		this.nombre = nombre;
		this.visible = visible;
	}

	public Coleccion.json ( string json ) {
		if (json.contains ("{\"Fuente\":{")) {
			this.nombre = this.sacarDatoJson (json, "nombre");
			this.visible = bool.parse ( this.sacarDatoJson (json, "visible") );
		} else {
			this.nombre = "null";
			this.visible = false;
		}
	}

	public string a_json () {
		string retorno = "{\"Fuente\":{";

		retorno += "\"nombre\":\"" + this.nombre + "\",";
		retorno += "\"visible\":\"" + this.visible.to_string () + "\",";
		retorno +="}}";	
		
		return retorno;
	}

	public string a_sql () {
		string retorno;

		retorno  = "nombre=\"" + this.nombre + "\",";
		retorno += "visible=\"" + this.visible.to_string() + "\"";
		
		return retorno;
	}

	public string to_string () {
		string retorno;

		retorno  = "\"" + this.nombre + "\",\"";
		retorno += this.visible.to_string() + "\"";
		
		return retorno;
	}

	private string sacarDatoJson(string json, string campo) {
		int inicio,fin;
		inicio = json.index_of(":",json.index_of("\"" + campo + "\"")) + 2;
		fin = json.index_of ("\"", inicio);
		return json[inicio:fin];
	}

}
