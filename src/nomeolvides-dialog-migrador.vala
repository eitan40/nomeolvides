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

public class Nomeolvides.Migrador : Gtk.Dialog {

	private AccionesDB db;
	private VentanaPrincipal ventana;
	private Array<Datos_coleccion> colecciones;
	private Array<Datos_lista> listas;
	private Grid grid;
	private ProgressBar barra_colecciones;
	private ProgressBar barra_colecciones_hechos;
	private Label label_colecciones;
	private Label label_colecciones_hechos;
	private ProgressBar barra_listas;
	private ProgressBar barra_listas_hechos;
	private Label label_listas;
	private Label label_listas_hechos;
	private int cantidad_hechos_coleccion;
	private int cantidad_hechos_lista;
	private bool hay_migrados;
	private Button siguiente_boton;
	private Box contenido;

	public Migrador ( VentanaPrincipal ventana ) {
		this.ventana = ventana;
		this.title = _("Database Migration");
		this.set_transient_for ( this.ventana as Window );
		this.set_modal ( true );
		this.window_position = Gtk.WindowPosition.CENTER;
		this.set_default_size ( 600, -1 );
		this.set_resizable ( false );

		this.hay_migrados = false;
		this.cantidad_hechos_coleccion = 0;
		this.cantidad_hechos_lista = 0;
		this.colecciones = new Array<Datos_coleccion>();
		this.listas = new Array<Datos_lista>();
		this.contenido = this.get_content_area() as Box;
		this.grid = new Grid ();
		this.set_grid ();
		this.siguiente_boton = this.add_button ( _("Start migration"), ResponseType.APPLY ) as Button;
		this.siguiente_boton.clicked.connect (this.migracion);

		var label_mensaje = new Label.with_mnemonic(_("Dear user,\n\nSince this version of Nomeolvides has a lot of internal changes, it is necessary to perform a migration of data loaded into earlier versions.\n\nThe migration process is automatic and the migrated data will not be deleted after the process to avoid losing your work if it fails.\n\nPlease check that all the data has been successfully migrated after completion of the process and, if not, notify us at desarrolladores@softwareperonista.com.ar\n\nSincerely, the development team."));
		label_mensaje.set_line_wrap ( true );
		label_mensaje.set_justify ( Justification.FILL );

		this.grid.attach (label_mensaje,0,0,1,1);
		
		this.destroy.connect ( terminar_migrador );

		this.contenido.pack_start ( this.grid );

		this.show_all ();

		this.db = new AccionesDB ( Configuracion.base_de_datos() );

		if ( Configuracion.hay_colecciones ()  ) {
			this.cargar_colecciones();
			this.cargar_hechos ();
		}
		if ( Configuracion.hay_listas ()  ) {
			this.cargar_listas ();
			this.cargar_hechos_listas ();
		}
	}

	private void  set_grid () {
		this.grid.set_valign ( Align.FILL );
		this.grid.set_halign ( Align.FILL );
		this.grid.set_margin_end ( 50 );
		this.grid.set_margin_start ( 50 );
		this.grid.set_margin_top ( 30 );
		this.grid.set_margin_bottom ( 17 );
		this.grid.set_size_request ( 600, -1 );
	}
	
	private void  set_label ( Label label ) {
		label.set_justify ( Justification.LEFT );
		label.set_valign ( Align.FILL );
		label.set_halign ( Align.START );
		label.set_margin_start ( 20 );
	}
	
	private void  set_progress_bar ( ProgressBar bar ) {
		bar.set_valign ( Align.FILL );
		bar.set_halign ( Align.FILL );
		bar.set_hexpand ( true );
		bar.set_fraction ( (double) 0 );
		bar.set_text ( "0%" );
		bar.set_show_text ( true );
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
				coleccion = new Datos_coleccion ();
				coleccion.set_nombre ( this.sacarDatoJson ( lineas[i], "nombre" ));
				coleccion.set_archivo ( this.sacarDatoJson ( lineas[i], "path") + this.sacarDatoJson ( lineas[i], "archivo" ));
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
				this.colecciones.index((uint)id_coleccion).agregar_hecho ( nuevoHecho );
				this.cantidad_hechos_coleccion++;
			}
		}
	}

	private int64 crear_coleccion_db ( string nombre ) {

		var coleccion = new Coleccion ( nombre, true);
		this.db.insert_coleccion (coleccion);

		coleccion = this.db.select_coleccion ("WHERE nombre = \"" + nombre + "\"");

		return coleccion.id;
	}

	private void cargar_listas () {
		string todo;
		string[] lineas;
		int i;

		todo = Configuracion.cargar_listas ();

		lineas = todo.split_set ("\n");
		for (i=0; i < lineas.length; i++) {
			if (lineas[i].contains ("{\"Lista\":{")) {
				var lista = new Lista.json ( lineas [i] );
				var datos_lista = new Datos_lista ();
				datos_lista.set_lista ( lista );
				this.listas.append_val ( datos_lista );
			}
		}
	}

	private void cargar_hechos_listas () {
		for (int i = 0; i < this.listas.length; i++) {
			var lista = this.listas.index(i).get_lista();
			for (int j = 0; j < this.colecciones.length; j++ ) {
				for (int k = 0; k < this.colecciones.index(j).cantidad_hechos(); k++ ) {
					var hecho = this.colecciones.index(j).get_hecho ( k );
					if ( this.pertenece_a_lista ( lista, hecho ) ) {
						this.listas.index(i).agregar_hecho ( hecho );
					}
				}
			}
		}
	}

	private bool pertenece_a_lista ( Lista lista, Hecho hecho) {
		bool pertenece = false;

		var lineas = Configuracion.cargar_listas_hechos().split_set ("\n");

		for (var i=0; i < (lineas.length - 1); i++) {
			var hecho_json = hecho.a_json();
			var sacar_inicio = hecho_json.index_of ( "\"coleccion\":\"");
			var sacar_fin = hecho_json.index_of ( "\"}}", sacar_inicio);
			hecho_json = hecho_json.replace ( hecho_json[sacar_inicio-1:sacar_fin+1], "" );
			if ( lineas[i] == lista.get_checksum() + "," + Checksum.compute_for_string(ChecksumType.MD5, hecho_json) ) {
				pertenece = true ;
				this.cantidad_hechos_lista++;
			}
		}

		return pertenece;
	}

	private void migracion ( ) {
		this.contenido.remove ( this.grid );
		this.grid = new Grid ();
		this.set_grid ();

		this.siguiente_boton.clicked.disconnect (this.migracion);
		this.siguiente_boton.set_label ( _("Finish Migration") );
		this.siguiente_boton.set_sensitive ( false );
		this.siguiente_boton.clicked.connect (  () => { this.destroy (); }  );
		
		this.label_colecciones = new Label.with_mnemonic ( _("Migrating Collections") );
		this.set_label ( this.label_colecciones );
		this.barra_colecciones = new ProgressBar ();
		this.set_progress_bar ( this.barra_colecciones );
		
		this.label_colecciones_hechos = new Label.with_mnemonic ( _("Facts from Collection") );
		this.set_label ( this.label_colecciones_hechos );
		this.barra_colecciones_hechos = new ProgressBar ();
		this.set_progress_bar ( this.barra_colecciones_hechos );

		this.label_listas = new Label.with_mnemonic ( _("Migrating Lists") );
		this.set_label ( this.label_listas );
		this.barra_listas = new ProgressBar ();
		this.set_progress_bar ( this.barra_listas );
		
		this.label_listas_hechos = new Label.with_mnemonic ( _("Facts from List") );
		this.set_label ( this.label_listas_hechos );
		this.barra_listas_hechos = new ProgressBar ();
		this.set_progress_bar ( this.barra_listas_hechos );

		var separador = new Separator ( Orientation.HORIZONTAL );
		separador.set_margin_top ( 14 );
		separador.set_margin_bottom ( 6 );
		
		this.grid.attach (this.label_colecciones,0,0,1,1);
		this.grid.attach (this.barra_colecciones,0,1,1,1);		
		this.grid.attach (this.label_colecciones_hechos,0,2,1,1);
		this.grid.attach (this.barra_colecciones_hechos,0,3,1,1);
		this.grid.attach (separador,0,4,1,1);
		this.grid.attach (this.label_listas,0,5,1,1);
		this.grid.attach (this.barra_listas,0,6,1,1);		
		this.grid.attach (this.label_listas_hechos,0,7,1,1);
		this.grid.attach (this.barra_listas_hechos,0,8,1,1);

		this.contenido.pack_start ( this.grid );

		this.show_all ();
			while ( Gtk.events_pending () ) {
				Gtk.main_iteration ();
			}

		this.migrar_colecciones ();
		this.migrar_listas ();

		this.siguiente_boton.set_sensitive ( true );
	}

	private void migrar_colecciones () {
		double progreso_coleccion;

		if ( this.colecciones.length == 0 ) {
			this.barra_colecciones.fraction = (double) 1;
			this.barra_colecciones_hechos.fraction = (double) 1;
			this.barra_colecciones.set_text ( "100%" );
			this.barra_colecciones_hechos.set_text ( "100%" );
		}
		for (int i = 0; i < this.colecciones.length; i++ ) {
			if ( this.colecciones.length == 1 ) {
				progreso_coleccion = 1;
			} else {
				progreso_coleccion = ((double) this.colecciones.index(i).cantidad_hechos() / (double) this.cantidad_hechos_coleccion) + this.barra_colecciones.fraction;
			}
			var id_real = this.crear_coleccion_db ( this.colecciones.index(i).get_nombre() );
			double progreso_hecho = (double)1/(double)this.colecciones.index(i).cantidad_hechos();
			this.label_colecciones.set_text_with_mnemonic ( _("Migrating Collection") + " " + this.colecciones.index(i).get_nombre() );

			if ( this.colecciones.index(i).cantidad_hechos() == 0 ) {
				this.barra_colecciones_hechos.fraction = (double) 1;
				this.barra_colecciones_hechos.set_text ( "100%" );
			}
			for (int j = 0; j < this.colecciones.index(i).cantidad_hechos(); j++ ) {
				var hecho = this.colecciones.index(i).get_hecho ( j );
				hecho.set_coleccion (id_real);
				this.db.insert_hecho ( hecho );
				this.barra_colecciones_hechos.set_fraction ( progreso_hecho * (j+1) );
				this.barra_colecciones_hechos.set_text ( ((int)(this.barra_colecciones_hechos.fraction*100)).to_string () + "%" );
				this.hay_migrados = true;
				this.label_colecciones_hechos.set_text_with_mnemonic ( _("Migrating Facts") + ": " + (j+1).to_string() + " de " + this.colecciones.index(i).cantidad_hechos().to_string() );
				while ( Gtk.events_pending () ) {
					Gtk.main_iteration ();
				}
			}
			this.label_colecciones_hechos.set_text_with_mnemonic ( _("Migrating Facts") );
			this.barra_colecciones.set_fraction ( progreso_coleccion );
			this.barra_colecciones.set_text ( ((int)(this.barra_colecciones.fraction*100)).to_string () + "%" );
			while ( Gtk.events_pending () ){
				Gtk.main_iteration ();
			}
		}
		this.label_colecciones.set_text_with_mnemonic ( _("Migrating Collections") );
		Archivo.renombrar ( Configuracion.archivo_colecciones(), Configuracion.archivo_colecciones() + ".migrado" );
	}

	private void migrar_listas () {
		double progreso_lista;

		if ( this.listas.length == 0  || this.cantidad_hechos_lista == 0 ) {
			this.barra_listas.fraction = (double) 1;
			this.barra_listas_hechos.fraction = (double) 1;
			this.barra_listas.set_text ( "100%" );
			this.barra_listas_hechos.set_text ( "100%" );
		} else {
			for (int i = 0; i < this.listas.length; i++ ) {

				if ( this.listas.length == 1 ) {
					progreso_lista = 1;
				} else {
					progreso_lista = ((double) this.listas.index(i).cantidad_hechos() / (double) this.cantidad_hechos_lista) + this.barra_listas.fraction;
				}
				double progreso_hecho = (double)1/(double)this.listas.index(i).cantidad_hechos();
				this.label_listas.set_text_with_mnemonic ( _("Migrating List") + " " + this.colecciones.index(i).get_nombre() );
				this.db.insert_lista ( this.listas.index(i).get_lista () );

				var lista_db = this.db.select_listas ( "WHERE nombre=\"" +  this.listas.index(i).get_lista().nombre +"\""  ).index(0);

				if ( this.listas.index(i).cantidad_hechos() == 0 ) {
					this.barra_listas_hechos.fraction = (double) 1;
					this.barra_listas_hechos.set_text ( "100%" );
				}

				for (int j = 0; j < this.listas.index(i).cantidad_hechos(); j++ ) {
					var hecho = this.listas.index(i).get_hecho ( j );
					var hecho_db = (this.db.select_hechos ( "WHERE nombre=\"" + hecho.nombre + "\"  AND anio=\"" + hecho.get_anio().to_string() + "\"  AND mes=\"" + hecho.get_mes().to_string() + "\"  AND dia=\"" + hecho.get_dia().to_string() + "\"" )).index(0);

					this.db.insert_hecho_lista ( hecho_db, lista_db );

					this.barra_listas_hechos.set_fraction ( progreso_hecho * (j+1) );
					this.barra_listas_hechos.set_text ( ((int)(this.barra_listas_hechos.fraction*100)).to_string () + "%" );
					this.hay_migrados = true;
					this.label_listas_hechos.set_text_with_mnemonic ( _("Migrating Facts") + ": " + (j+1).to_string() + " de " + this.listas.index(i).cantidad_hechos().to_string() );
					while ( Gtk.events_pending () ) {
						Gtk.main_iteration ();
					}
				}
				this.label_listas_hechos.set_text_with_mnemonic ( _("Migrating Facts") );
				this.barra_listas.set_fraction ( progreso_lista );
				this.barra_listas.set_text ( ((int)(this.barra_listas.fraction*100)).to_string () + "%" );
				while ( Gtk.events_pending () ){
					Gtk.main_iteration ();
				}
			}
			this.label_listas.set_text_with_mnemonic ( _("Migrating Lists") );
		}
		Archivo.renombrar ( Configuracion.archivo_listas(), Configuracion.archivo_listas() + ".migrado" );
	}

	private string sacarDatoJson(string json, string campo) {
		int inicio,fin;
		inicio = json.index_of(":",json.index_of("\"" + campo + "\"")) + 2;
		fin = json.index_of ("\"", inicio);
		return json[inicio:fin];
	}

	private void terminar_migrador () {
		if ( this.hay_migrados ) {
			this.hay_migrados_signal ();
		}
	}

	public signal void hay_migrados_signal ();
}

public class Nomeolvides.Datos_migrador : GLib.Object {
	private Array<Hecho> hechos;

	public Datos_migrador () {
		this.hechos = new Array<Hecho> ();
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

public class Nomeolvides.Datos_coleccion : Nomeolvides.Datos_migrador {
	private string nombre;
	private string archivo;

	public Datos_coleccion () {
		base ();
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
}

public class Nomeolvides.Datos_lista : Nomeolvides.Datos_migrador {
	private Lista lista;

	public Datos_lista () {
		base ();
	}

	public void set_lista ( Lista lista ) {
		this.lista = lista;
	}

	public Lista get_lista () {
		return this.lista;
	}
}
