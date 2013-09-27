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

public class Nomeolvides.Archivo : GLib.Object{ 
	public static void crear ( string path, string datos = "" ) {
		var archivo = File.new_for_path ( path );
		try {
			archivo.create (FileCreateFlags.NONE);
		} catch (Error e) {
			error (e.message);
		}

		if ( datos != "" ) {
			Archivo.escribir ( path, datos ); 
		}
	}

	public static void crear_directorio ( string path ) {
		var directorio = File.new_for_path ( path );
		try {
			directorio.make_directory ();
		}  catch (Error e) {
			error (e.message);
		}
	}

	public static void escribir ( string path, string datos ) {
		try {
			FileUtils.set_contents ( path, datos );
		} catch ( Error e ) {
			error ( e.message );
		}
	}

	public static string leer ( string direccion ) {
		string contenido_archivo = "";

		if ( Archivo.es_path ( direccion ) ) {
			Archivo.leer_archivo_path ( direccion, out contenido_archivo );
		} else {
			Archivo.leer_archivo_uri ( direccion, out contenido_archivo );
		}

		return contenido_archivo;
	}

	public static bool existe_path ( string path ) {
		var archivo = File.new_for_path ( path );
		var retorno = archivo.query_exists ();

		return retorno;
	}

	public static bool existe_uri ( string uri ) {
		var archivo = File.new_for_uri ( uri );
		bool retorno; 

		try {
			archivo.query_info ("standard::icon", 0);
			retorno = true;
		}  catch (Error e) {
			retorno = false;
		}
			
		return retorno;
	}

	public static bool es_path ( string direccion ) {
		bool retorno = true;
		
		if ( direccion.has_prefix ("http") ) {
			retorno = false;
		}

		return retorno;
	}

	public static void renombrar ( string viejo, string nuevo ) {
		FileUtils.rename ( viejo, nuevo );
	}

	private static void leer_archivo_path ( string path, out string contenido_archivo ) {
		try {
			FileUtils.get_contents ( path, out contenido_archivo );
		} catch ( Error e ) {
			print (_("Error while open") + ": " + path + "\n");
			contenido_archivo = "";
		}
	}

	private static void leer_archivo_uri ( string uri, out string contenido_archivo ) {
		uint8[] contenido;
		File archivo = null;

		archivo = File.new_for_uri ( uri );

		if ( Archivo.existe_uri (uri) ) {
			try {
				archivo.load_contents(null ,out contenido, null);
			}  catch (Error e) {
				print (_("Error while open") + ": " + uri + "\n");
			}
			contenido_archivo = (string) contenido;
		} else {
			contenido_archivo = "";
		}	
	}
}
