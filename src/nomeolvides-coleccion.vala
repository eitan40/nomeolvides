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
	public string nombre_coleccion { get; private set; }
	public string nombre_archivo { get; private set; }
	public string direccion_coleccion { get; private set; }
	public bool visible {get; set; }
	private string hash;
	public ColeccionTipo tipo_coleccion { get; private set; }

	public Coleccion ( string nombre_coleccion, string nombre_archivo, string direccion_coleccion, bool visible, ColeccionTipo tipo_coleccion ) {
		this.nombre_coleccion = nombre_coleccion;
		this.nombre_archivo = nombre_archivo;
		this.direccion_coleccion = direccion_coleccion;
		this.visible = visible;
		this.tipo_coleccion = tipo_coleccion;
		this.calcular_checksum ();
	}

	public Coleccion.json ( string json ) {
		if (json.contains ("{\"Fuente\":{")) {
			this.nombre_coleccion = this.sacarDatoJson (json, "nombre");
			this.nombre_archivo = this.sacarDatoJson (json, "archivo");
			this.direccion_coleccion = this.sacarDatoJson (json, "path");
			this.visible = bool.parse ( this.sacarDatoJson (json, "visible") );
			this.tipo_coleccion = ColeccionTipo.convertir ( this.sacarDatoJson ( json, "tipo" ) );
		} else {
			this.nombre_coleccion = "null";
			this.nombre_archivo = "null";
			this.direccion_coleccion = "null";
			this.visible = false;
			this.tipo_coleccion = ColeccionTipo.LOCAL;
		}

		this.calcular_checksum ();
	}

	public bool verificar_coleccion () {
		bool retorno = true;
		if ( this.tipo_coleccion == ColeccionTipo.LOCAL ) {
			if( !Archivo.existe_path (this.direccion_coleccion + this.nombre_archivo) ) {
				retorno = false;
				print ("No existe el archivo " + this.direccion_coleccion + this.nombre_archivo);
			}
		}

		return retorno;
	}

	public string a_json () {
		string retorno = "{\"Fuente\":{";

		retorno += "\"nombre\":\"" + this.nombre_coleccion + "\",";
		retorno += "\"archivo\":\"" + this.nombre_archivo + "\",";
		retorno += "\"path\":\"" + this.direccion_coleccion + "\",";
		retorno += "\"visible\":\"" + this.visible.to_string () + "\",";
		retorno += "\"tipo\":\"" + this.tipo_coleccion.to_string () + "\"";

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
		this.hash = Checksum.compute_for_string(ChecksumType.MD5, this.direccion_coleccion + this.nombre_archivo);
	}
}


public enum Nomeolvides.ColeccionTipo {
	LOCAL,
	HTTP;

	public string to_string() {
        switch (this) {
            case LOCAL:
                return "Local";

            case HTTP:
                return "HTTP";

			default:
                return "";
	}
}

	public static ColeccionTipo convertir (string cadena)
	{
		switch (cadena) {
            case "Local":
                return ColeccionTipo.LOCAL;

			case "HTTP":
                return ColeccionTipo.HTTP;

			default:
                return ColeccionTipo.LOCAL;
		}
	}
}
