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
	private Array<string> colecciones_nombres;
	private	Array<string> colecciones_archivos;
	private Array<Hecho> hechos;

	public Migrador ( VentanaPrincipal ventana ) {

		this.colecciones_nombres = new Array<string>();
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
		}

	}

	private void cargar_colecciones () {
		string todo;
		string[] lineas;
		int i;	

		todo = Configuracion.cargar_colecciones ();
		
		lineas = todo.split_set ("\n");
		for (i=0; i < lineas.length; i++) {
			if ( lineas[i].contains ( "\"tipo\":\"Local\"" ) ) {
				this.colecciones_nombres.append_val ( this.sacarDatoJson ( lineas[i], "nombre" ));
				this.colecciones_archivos.append_val ( this.sacarDatoJson ( lineas[i], "path") + this.sacarDatoJson ( lineas[i], "archivo" ));
			}
		}
	}

	private void cargar_hechos () {

		for (int i=0; i< colecciones_nombres.length; i++) {
			this.cargar_hechos_coleccion ( colecciones_archivos.index (i), i );
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
				this.hechos.append_val ( nuevoHecho );
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

