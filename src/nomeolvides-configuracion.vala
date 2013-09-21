/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* Nomeolvides
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
using Nomeolvides;

public class Nomeolvides.Configuracion : GLib.Object {
	public static void create_about_dialog ( VentanaPrincipal window ) {
		string[] authors = {
  			"Andres Fernandez <andres@softwareperonista.com.ar>",
  			"Fernando Fernandez <fernando@softwareperonista.com.ar>"
		};
		Gtk.show_about_dialog (window,
			   "authors", authors,
			   "program-name", "Nomeolvides",
			   "title", "Acerca de Nomeolvides",
			   "comments", "Gestor de efemérides históricas",
			   "copyright", "Copyright 2012 Fernando Fernandez y Andres Fernandez",
			   "license-type", Gtk.License.GPL_3_0,
			   "logo-icon-name", "nomeolvides",
			   "version", Config.VERSION,
			   "website", "https://github.com/softwareperonista/nomeolvides",
			   "wrap-license", true);	
	}
	
	public static void set_config () {		
		if ( !Archivo.existe_path ( Configuracion.directorio_configuracion () ) ) {
			Archivo.crear_directorio ( Configuracion.directorio_configuracion () );
		}

		if (!Archivo.existe_path ( Configuracion.base_de_datos () ) ) {
			string dir_sql = ".";
			string stdout;
			string stderr;
			int exitstatus;

			try {
				Process.spawn_command_line_sync ( "sqlite3 " +   Configuracion.base_de_datos () + " -init " +  dir_sql + "/nomeolvides.sql.tablas", out stdout, out stderr, out exitstatus);
			} catch (SpawnError e) {
				print ("Error: %s\n", e.message);
				print ("Comando:\n" + "sqlite3 " +   Configuracion.base_de_datos () + " -init " +  dir_sql + "/nomeolvides.sql.tablas\n\n");
				print ("Salida:\n\tstdout : " + stdout + "\n\tstderr : " + stderr + "\n\texitstatus : " + exitstatus.to_string () + "\n");
			}
		}
/*
		if (!Archivo.existe_path ( Configuracion.archivo_colecciones () ) ) {
			Archivo.crear ( Configuracion.archivo_colecciones () );

			var coleccion_default = new Coleccion ( "Coleccion",
			                             				   true
			                                      );
		}

		if (!Archivo.existe_path ( Configuracion.archivo_listas () ) ) {
				Archivo.crear ( Configuracion.archivo_listas () );
		}
		
		if (!Archivo.existe_path ( Configuracion.directorio_colecciones_locales () )) {
			Archivo.crear_directorio ( Configuracion.directorio_colecciones_locales () );			
		}
		
		if (!Archivo.existe_path ( Configuracion.archivo_colecciones_locales () ) ) {
				Archivo.crear ( Configuracion.archivo_colecciones_locales () );
		}

		if (!Archivo.existe_path ( Configuracion.archivo_listas_hechos () ) ) {
				Archivo.crear ( Configuracion.archivo_listas_hechos () );
		}
*/
	/*	Resource resources;

		try {
			resources = Resource.load ("src/nomeolvides.gresource");
		} catch ( Error e ){
			error (e.message);
		}
		resources._register ();
*/	}

	public static void guardar_colecciones ( string colecciones ) {
		Archivo.escribir ( Configuracion.archivo_colecciones (), colecciones );
	}

	public static string cargar_colecciones () {
		return Archivo.leer ( Configuracion.archivo_colecciones () );
	}

	public static void guardar_listas ( string listas ) {
		Archivo.escribir ( Configuracion.archivo_listas (), listas );
	}

	public static string cargar_listas () {
		return Archivo.leer ( Configuracion.archivo_listas () );
	}

	public static string cargar_listas_hechos () {
		return Archivo.leer ( Configuracion.archivo_listas_hechos () );
	}

	public static void guardar_listas_hechos ( string listas_hechos ) {
		Archivo.escribir ( Configuracion.archivo_listas_hechos (), listas_hechos );
	}

	public static bool hay_colecciones () {
		return Archivo.existe_path ( Configuracion.archivo_colecciones () );
	}

	public static bool hay_listas () {
		return Archivo.existe_path ( Configuracion.archivo_listas () );
	}

	private static string directorio_datos () {
		return GLib.Environment.get_home_dir () + "/.local/share/nomeolvides";
	}

	public static string base_de_datos () {
		return Configuracion.directorio_datos () + "/nomeolvides.db";
	}

	public static string archivo_colecciones () {
		return Configuracion.directorio_configuracion () + "/db-predeterminadas.json";
	}

	public static string archivo_listas () {
		return Configuracion.directorio_configuracion () + "/listas-personalizadas.json";
	}

	private static string directorio_configuracion () {
		return GLib.Environment.get_user_config_dir () + "/nomeolvides";
	}

	private static string directorio_colecciones_locales () {
		return GLib.Environment.get_home_dir () + "/.local/share/nomeolvides";
	}

	private static string archivo_colecciones_locales () {
		return Configuracion.directorio_colecciones_locales () + "/db_default.json";
	}

	private static string archivo_listas_hechos () {
		return Configuracion.directorio_colecciones_locales () + "/listas";
	}
}
