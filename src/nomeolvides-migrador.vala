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
	private Array<Hecho> hechos;
	private Grid grid;
	private ProgressBar barra_sub_total;
	private ProgressBar barra_hechos;
	private Label label_sub_total;
	private Label label_hechos;
	private int cantidad_hechos;

	public Migrador ( VentanaPrincipal ventana ) {

		this.cantidad_hechos = 0;
		this.colecciones = new Array<Datos_coleccion>();
		this.hechos = new Array<Hecho>();
		this.grid = new Grid ();
		var fer_boton = new Button.from_stock (Stock.APPLY);
		fer_boton.clicked.connect (this.migracion);

		this.grid.attach (new Label.with_mnemonic("Anda"),0,0,1,1);
		this.grid.attach ( fer_boton,0,1,1,1);

		this.ventana = ventana;
		this.title = "Migrador de la base de hechos";
		this.set_transient_for ( this.ventana as Window );
		this.set_modal ( true );
		this.window_position = Gtk.WindowPosition.CENTER;
		this.set_default_size (500, 350);

		this.destroy.connect ( terminar_migrador );

		this.add (this.grid);

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
		double progreso = 0;
		Datos_coleccion coleccion;

		todo = Configuracion.cargar_colecciones ();
		
		lineas = todo.split_set ("\n");
		for (i=0; i < lineas.length; i++) {
			if ( lineas[i].contains ( "\"tipo\":\"Local\"" ) ) {
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
				this.cantidad_hechos++;
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

	private void migracion ( ) {
		this.remove (this.grid);

		this.grid = new Grid ();
//		this.grid.set_row_homogeneous ( true );
		this.grid.set_row_spacing ( 20 );
		this.grid.set_column_homogeneous ( true );
		this.grid.set_column_spacing ( 4 );
		
		this.label_sub_total = new Label.with_mnemonic ( "Migrando Colecciones" );
		this.barra_sub_total = new ProgressBar ();
		this.label_hechos = new Label.with_mnemonic ( "Migrando Hechos" );
		this.barra_hechos = new ProgressBar ();

		this.barra_sub_total.set_show_text ( true );
		this.barra_hechos.set_show_text ( true );
		this.grid.attach (this.barra_sub_total,0,2,1,1);
		this.grid.attach (this.label_sub_total,0,1,1,1);
		this.grid.attach (this.label_hechos,0,3,1,1);
		this.grid.attach (this.barra_hechos,0,4,1,1);

		this.add (this.grid);

		this.barra_hechos.set_fraction ( (double) 0 );
		this.barra_hechos.set_text ( "0%" );

		this.barra_sub_total.set_fraction ( (double) 0 );
		this.barra_sub_total.set_text ( "0%" );

		this.show_all ();

		this.migrar_colecciones ();
	}

	private void migrar_colecciones () {

		for (int i = 0; i < this.colecciones.length; i++ ) {
			double progreso_coleccion = (double) this.colecciones.index(i).cantidad_hechos() / (double) this.cantidad_hechos;
			var id_real = this.crear_coleccion_db ( this.colecciones.index(i).get_nombre() );
			double progreso_hecho = (double)1/(double)this.colecciones.index(i).cantidad_hechos();

			for (int j = 0; j < this.colecciones.index(i).cantidad_hechos(); j++ ) {
				var hecho = this.colecciones.index(i).get_hecho ( j );
				hecho.set_id (id_real);
				this.db.insert_hecho ( hecho );
				this.barra_hechos.set_fraction ( progreso_hecho * (j+1) );
				this.barra_hechos.set_text ( ((int)(this.barra_hechos.fraction*100)).to_string () + "%" );
				while ( Gtk.events_pending () ) {
					Gtk.main_iteration ();
				}
			}
			this.barra_sub_total.set_fraction ( progreso_coleccion * (i+1) );
			this.barra_sub_total.set_text ( ((int)(this.barra_sub_total.fraction*100)).to_string () + "%" );
			while ( Gtk.events_pending () ){
				Gtk.main_iteration ();
			}
		}
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
