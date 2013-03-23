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
	private File directorio_configuracion;
	private File directorio_db_local;
	private File archivo_db_local;
	
	public Configuracion () {
		this.directorio_configuracion = File.new_for_path(GLib.Environment.get_user_config_dir () + "/nomeolvides/");
		this.directorio_db_local = File.new_for_path(GLib.Environment.get_home_dir () + "/.local/share/nomeolvides/");
		this.archivo_db_local = File.new_for_path(directorio_db_local.get_path () + "/db_default.json");
	}

	public void create_about_dialog ( VentanaPrincipal window ) {
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
	
	public void set_config () {		
		if (!directorio_configuracion.query_exists ()) {
			try {
				directorio_configuracion.make_directory (); 
			}  catch (Error e) {
				error (e.message);
			}			
		}
		
		if (!directorio_db_local.query_exists ()) {
			try {
				directorio_db_local.make_directory ();
			}  catch (Error e) {
				error (e.message);
			}

			if (!archivo_db_local.query_exists ()) {
				try {				
					archivo_db_local.create (FileCreateFlags.NONE);
					try {
						var fuente_default = new Fuente ( "Base de datos local",
						                                  "db_default.json",
						                                  this.directorio_db_local.get_path (),
						                                  FuentesTipo.LOCAL );
						FileUtils.set_contents (archivo_db_local.get_parse_name (), fuente_default.a_json());
					} catch (Error e) {
						error (e.message);
					}
				}  catch (Error e) {
					error (e.message);
				}			
			}
		}
	}
}
