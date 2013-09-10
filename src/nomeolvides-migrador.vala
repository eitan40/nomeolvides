/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * nomeolvides-migrador.vala
 * Copyright (C) 2013 Fernando Fernandez <berel@vivaperon>
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

public class Nomeolvides.Migrador : Gtk.Window {

	private AccionesDB db;
	private VentanaPrincipal ventana;
	private Array<Datos_coleccion> colecciones;
//	private Array<string> colecciones_nombres;
	private	Array<string> colecciones_archivos;
	private Array<Hecho> hechos;

	public Migrador ( VentanaPrincipal ventana ) {

		this.colecciones = new Array<Datos_coleccion>();
//		this.colecciones_nombres = new Array<string>();
		this.colecciones_archivos = new Array<string>();
		this.hechos = new Array<Hecho>();

		this.ventana = ventana;
		this.title = "Migrador de la base de hechos";
		this.set_transient_for ( this.ventana as Window );
		this.set_modal ( true );
		this.window_position = Gtk.WindowPosition.CENTER;
		this.set_default_size (500, 350);

		this.destroy.connect ( terminar_migrador );

		this.add (new Gtk.Label ("Hello, world!"));

		this.show_all ();

		this.db = new AccionesDB ( Configuracion.base_de_datos() );

		if ( Configuracion.hay_colecciones ()  ) {
			this.cargar_colecciones();
			this.cargar_hechos ();

			string texto = "";

			for (int i = 0; i < this.colecciones.length; i++ ) {
				texto += "Coleccion: " + this.colecciones.index (i).get_nombre () + "  (" + this.colecciones.index (i).get_archivo () +")\n";
				for (int j = 0; j < this.colecciones.index(i).cantidad_hechos(); j++ ) {
					var hecho = this.colecciones.index(i).get_hecho ( j );
					texto +=  "     "  +  (j+1).to_string() + ") " + hecho.nombre + "         " +  hecho.fecha_to_string () + "\n";
				}
			}
			print ( texto );
		}

	}

	private void cargar_colecciones () {
		string todo;
		string[] lineas;
		int i;
		Datos_coleccion coleccion;

		todo = Configuracion.cargar_colecciones ();
		
		lineas = todo.split_set ("\n");
		for (i=0; i < lineas.length; i++) {
			if ( lineas[i].contains ( "\"tipo\":\"Local\"" ) ) {
				print (lineas[i] + "\n");
				coleccion = new Datos_coleccion ();
				coleccion. set_nombre ( this.sacarDatoJson ( lineas[i], "nombre" )); 
				coleccion. set_archivo ( this.sacarDatoJson ( lineas[i], "path") + this.sacarDatoJson ( lineas[i], "archivo" )); 
				this.colecciones.append_val ( coleccion );
				coleccion = null;
			}
		}
	}

	private void cargar_hechos () {

		for (int i=0; i< this.colecciones.length; i++) {
			this.cargar_hechos_coleccion ( this.colecciones.index (i).get_archivo (), i );
		}
	}

	private void cargar_hechos_coleccion ( string archivo, int64 id_coleccion ) {

		string todo;
		string[] lineas;
		Hecho nuevoHecho;
		int i;

		todo = Archivo.leer ( archivo );

		lineas = todo.split_set ("\n");

		for (i=0; i < (lineas.length - 1); i++) {
			nuevoHecho = new Hecho.json(lineas[i], id_coleccion);
			if ( nuevoHecho.nombre != "null" ) {
				this.colecciones.index ( (uint) id_coleccion).agregar_hecho ( nuevoHecho );
			}
		}
	}

	private int64 crear_coleccion_db ( string nombre ) {

		var coleccion = new Coleccion ( nombre, true);
		this.db.insert_coleccion (coleccion);

		coleccion = this.db.select_coleccion ("WHERE nombre = \"" + nombre + "\"");

		return coleccion.id;
	}

	private string sacarDatoJson(string json, string campo) {
		int inicio,fin;
		inicio = json.index_of(":",json.index_of("\"" + campo + "\"")) + 2;
		fin = json.index_of ("\"", inicio);
		return json[inicio:fin];
	}

	private void terminar_migrador () {
		this.ventana.show();
	}
}

public class Nomeolvides.Datos_coleccion : GLib.Object {
	private string nombre;
	private string archivo;
	private Array<Hecho> hechos;

	public Datos_coleccion () {
		this.hechos = new Array<Hecho> ();
	}

	public void set_nombre ( string nombre ) {
		this.nombre = nombre;
	}

	public void set_archivo ( string archivo ) {
		this.archivo = archivo;
	}

	public string get_nombre () {
		return this.nombre;
	}

	public string get_archivo () {
		return this.archivo;
	}

	public void agregar_hecho ( Hecho hecho) {
		this.hechos.append_val ( hecho );
	}

	public uint cantidad_hechos () {
		return this.hechos.length;
	}

	public Hecho get_hecho ( uint indice ) {
		return this.hechos.index ( indice );
	}
}
