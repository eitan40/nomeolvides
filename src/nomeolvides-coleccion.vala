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

public class Nomeolvides.Coleccion : Nomeolvides.NmBase {
	public bool visible {get; set; }

	public Coleccion ( string nombre, bool visible ) {
		base ( nombre );
		this.visible = visible;
	}

	public Coleccion.json ( string json ) {
		if (!json.contains ("{\"Fuente\":{")) {
			json = "null";
			this.visible = false;
		} else { 
			this.visible = bool.parse ( this.sacarDatoJson (json, "visible") );
		}

		base.json ( json );
	}

	public string a_json () {
		string retorno = "{\"Fuente\":{";
		retorno += base.a_json ();
		retorno += "\"visible\":\"" + this.visible.to_string () + "\",";
		retorno +="}}";	
		
		return retorno;
	}

	public string a_sql () {
		var retorno  = base.a_sql ();
		retorno += "visible=\"" + this.visible.to_string() + "\"";
		
		return retorno;
	}

	public string to_string () {
		var retorno  = base.to_string ();
		retorno += this.visible.to_string() + "\"";
		
		return retorno;
	}
}
