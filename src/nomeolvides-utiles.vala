/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2012 Fernando Fernandez <fernando@softwareperonista.com.ar>
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

public class Nomeolvides.Utiles : GLib.Object{ 

	public static string sacarCaracterEspecial ( string inicial ) {

		string saltoDeLinea = "\n";
		string reemplazoSaltoDeLinea = "|";
		string retorno = inicial.replace ( saltoDeLinea, reemplazoSaltoDeLinea );
		
		string comillas = "\"";
		string reemplazoComillas = "_";
		retorno = retorno.replace ( comillas, reemplazoComillas );

		return retorno;
	}

	public static string ponerCaracterEspecial ( string inicial ) {

		string saltoDeLinea = "\n";
		string reemplazoSaltoDeLinea = "|";
		string retorno = inicial.replace ( reemplazoSaltoDeLinea, saltoDeLinea );
		
		string comillas = "\"";
		string reemplazoComillas = "_";
		retorno = retorno.replace ( reemplazoComillas, comillas );

	return retorno;
	}

	public static string nombre_para_archivo ( string nombre ) {
		string retorno = nombre;

		retorno = retorno.replace (" ","-");
		retorno = retorno.down();
		retorno = retorno.replace ("á", "a");
		retorno = retorno.replace ("é", "e");
		retorno = retorno.replace ("í", "i");
		retorno = retorno.replace ("ó", "o");
		retorno = retorno.replace ("ú", "u");
		retorno = retorno.replace ("ñ", "ni");

		return retorno;

	}

	public static string sacarDatoJson(string json, string campo) {
		int inicio,fin;
		inicio = json.index_of(":",json.index_of("\"" + campo + "\"")) + 2;
		fin = json.index_of ("\"", inicio);
		return json[inicio:fin];
	}

	public static string calcular_checksum ( string json ) {
		return Checksum.compute_for_string( ChecksumType.MD5, json );
	}
}
