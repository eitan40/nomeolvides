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

using GLib;
using Gtk;
using Nomeolvides;

public class Nomeolvides.App : Gtk.Application 
{
	public static App app;
	public VentanaPrincipal window;
	public Datos datos;
	public GLib.Menu application_menu;
	private Migrador migrador;

	private const GLib.ActionEntry[] actions_app_menu = {
		{ "create-about-dialog", about_dialog },
		{ "exportar", exportar },
		{ "importar", importar },
		{ "window-destroy", salir_app },
		{ "config-colecciones-dialog", config_colecciones_dialog },
		{ "config-listas-dialog", config_listas_dialog }
	};

	private void create_window () {
		this.window = new VentanaPrincipal (this);

		this.create_app_menu ( );
		this.connect_signals ();

		this.window.show_visible ();
		this.inicializar_ventana ();
	}

	public void inicializar_ventana () {
		this.cargar_lista_anios ();
		this.cargar_listas ();
	}

	public override void activate () {
		create_window();
		if (Configuracion.hay_colecciones ()  || Configuracion.hay_listas () ) {
			this.migrador = new Migrador( this.window );
			this.migrador.hay_migrados_signal.connect (	this.inicializar_ventana );
		}
	}

	public void create_app_menu () {
		this.application_menu = new GLib.Menu ();
		
		this.application_menu.append ( "Configurar Colecciones", "app.config-colecciones-dialog" );
		this.application_menu.append ( "Configurar Listas Personalizadas", "app.config-listas-dialog" );
		this.application_menu.append ( "Exportar hechos", "app.exportar" );
		this.application_menu.append ( "Importar hechos", "app.importar" );
		this.application_menu.append ( "Acerca de Nomeolvides", "app.create-about-dialog" );
		this.application_menu.append ( "Salir", "app.window-destroy" );
		
		this.set_app_menu ( application_menu );		
		this.add_action_entries (actions_app_menu, this);
	}

	private void connect_signals () {
		this.window.toolbar_add_button_clicked.connect ( this.add_hecho_dialog );
		this.window.toolbar_undo_button_clicked.connect ( this.undo_hecho );
		this.window.toolbar_redo_button_clicked.connect ( this.redo_hecho );		
		this.window.toolbar_edit_button_clicked.connect ( this.edit_hecho_dialog );
		this.window.toolbar_delete_button_clicked.connect ( this.delete_hecho_dialog );
		this.window.toolbar_send_button_clicked.connect ( this.send_hecho );
		this.window.toolbar_list_agregar_button_clicked.connect ( this.add_hecho_lista );
		this.window.toolbar_list_quitar_button_clicked.connect ( this.remove_hecho_lista );

		this.window.anios_hechos_anios_cursor_changed.connect ( this.elegir_anio );
		this.window.anios_hechos_listas_cursor_changed.connect ( this.elegir_lista );
		
		this.datos.datos_cambio_anios.connect ( this.cargar_lista_anios );
		this.datos.datos_cambio_listas.connect ( this.cargar_listas );
		this.datos.datos_cambio_hechos.connect ( this.cargar_lista_hechos );
		this.datos.datos_hechos_deshacer.connect ( this.window.activar_boton_deshacer );
		this.datos.datos_no_hechos_deshacer.connect ( this.window.desactivar_boton_deshacer  );
		this.datos.datos_hechos_rehacer.connect ( this.window.activar_boton_rehacer );
		this.datos.datos_no_hechos_rehacer.connect ( this.window.desactivar_boton_rehacer  );
	}

	public void add_hecho_dialog () {

		if ( !(this.datos.hay_colecciones_activas ()) ) {
				this.config_colecciones_dialog ();
		}

		if ( this.datos.hay_colecciones_activas () ) {

			var add_dialog = new AddHechoDialog( this.window as VentanaPrincipal, this.datos.lista_de_colecciones () ); 
		
			add_dialog.show();

			if ( add_dialog.run() == ResponseType.APPLY )
			{
				this.datos.agregar_hecho( add_dialog.respuesta );			
			}		
			add_dialog.destroy();
		}
	}
	
	private void elegir_anio () {
		int anio = this.window.get_anio_actual ();
		this.window.cargar_hechos_view ( this.datos.get_liststore_anio ( anio ) );
	}

	private void elegir_lista () {
		Lista lista = this.window.get_lista_actual ();
		
		var lista_hechos = this.datos.get_liststore_lista ( lista );
		
		this.window.cargar_hechos_view ( lista_hechos );
	}

	public void edit_hecho_dialog () {
		Hecho hecho; 

		this.window.get_hecho_actual ( out hecho );

		var edit_dialog = new EditHechoDialog( this.window, this.datos.lista_de_colecciones () );
		edit_dialog.set_datos ( hecho );
		edit_dialog.show_all ();

		if ( edit_dialog.run() == ResponseType.APPLY ) {
			this.datos.edit_hecho ( edit_dialog.respuesta );
		}
		edit_dialog.destroy();
	}

	public void delete_hecho_dialog () {
		Hecho hecho_a_borrar;
		this.window.get_hecho_actual ( out hecho_a_borrar );
	
		BorrarHechoDialogo delete_dialog = new BorrarHechoDialogo ( hecho_a_borrar, this.window as VentanaPrincipal);

		if (delete_dialog.run() == ResponseType.APPLY) {
			this.datos.eliminar_hecho ( hecho_a_borrar );			
		}	
		delete_dialog.destroy ();
	}

	public void about_dialog () {
		Configuracion.create_about_dialog ( this.window );
	}

	private void salir_app () {
		this.window.destroy ();
	}

	private void config_colecciones_dialog () {
		ListStoreColecciones colecciones = this.datos.lista_de_colecciones (); 
		var colecciones_dialogo = new ColeccionesDialog ( this.window, colecciones );
		colecciones_dialogo.show_all ();
		colecciones_dialogo.run ();
		this.inicializar_ventana ();
	}

	private void config_listas_dialog () {		
		var listas_dialogo = new ListasDialog ( this.window, this.datos.lista_de_listas () );
		listas_dialogo.show_all ();
		listas_dialogo.run ();
		this.inicializar_ventana ();
	}

	public void send_hecho () {		
		Hecho hecho; 
		string asunto;
		string cuerpo;
		string direccion;
		string archivo;

		this.window.get_hecho_actual ( out hecho );

		if( hecho != null) {
			asunto = "Envío un hecho para contribuir con la base de datos oficial";
			cuerpo = "Estimados, quisiera contribuir con este hecho a mejorar la base de datos oficial de Nomeolvides.";
			direccion = "fernando@softwareperonista.com.ar, andres@softwareperonista.com.ar";
			archivo = GLib.Environment.get_tmp_dir () + "/"+ hecho.nombre_para_archivo() +".json";

			Archivo.crear (archivo, hecho.a_json () );
		
			string commando = @"xdg-email --subject '$asunto' --body '$cuerpo' --attach '$archivo' $direccion";
  
			try {
				Process.spawn_command_line_async( commando );
			} catch(SpawnError err) {
				stdout.printf(err.message+"\n");
			}
		}
	}

	public void undo_hecho () {
		this.datos.deshacer_cambios ();
	}

	public void redo_hecho () {
		this.datos.rehacer_cambios ();
	}

	public void add_hecho_lista () {		
		Hecho hecho;

		if ( !( this.datos.hay_listas ()) ) {
			this.config_listas_dialog ();
		}

		if ( this.datos.hay_listas () ) { //si hay listas
			AddHechoListaDialog dialogo = new AddHechoListaDialog ( this.window );
			this.window.get_hecho_actual ( out hecho );

				dialogo.set_hecho ( hecho );
                dialogo.set_listas ( this.datos.lista_de_listas() );

			if (dialogo.run () == ResponseType.APPLY) {
       			this.datos.agregar_hecho_lista ( hecho, dialogo.get_id_lista () );
			}
		dialogo.close ();
		}
	}

	public void remove_hecho_lista () {
		Hecho hecho;
		var dialogo = new BorrarHechoListaDialog ( this.window );
		var lista = this.window.get_lista_actual ();
		
		this.window.get_hecho_actual ( out hecho );
		
		dialogo.set_hecho ( hecho );
		dialogo.set_lista ( lista );
		
		if (dialogo.run () == ResponseType.APPLY) {
            this.datos.quitar_hecho_lista ( hecho, lista );
		}
		dialogo.close ();			
	}

	public void save_as_file_dialog () {
		SaveFileDialog guardar_archivo = new SaveFileDialog(GLib.Environment.get_current_dir ());
		guardar_archivo.set_transient_for ( this as Window );

		if (guardar_archivo.run () == ResponseType.ACCEPT) {		
            this.datos.save_as_file ( guardar_archivo.get_filename () );
		}
		guardar_archivo.close ();
	}

	public void importar_dialog () {
		OpenFileDialog abrir_archivo = new OpenFileDialog(GLib.Environment.get_current_dir ());
		abrir_archivo.set_transient_for ( this as Window );

		if (abrir_archivo.run () == ResponseType.ACCEPT) {		
            this.datos.open_file ( abrir_archivo.get_filename () );
		}
		abrir_archivo.close ();
	}


	private void exportar () {
		this.save_as_file_dialog ();
	}

	private void importar () {
		this.importar_dialog ();
	}

	public void cargar_listas () {
		this.window.cargar_listas_view ( this.datos.lista_de_listas () );
	}

	public void cargar_lista_anios () {
		this.window.cargar_anios_view ( this.datos.lista_de_anios () );
	}

	public void cargar_lista_hechos () {
		var pestania = this.window.get_pestania ();

		if ( pestania == "Años") {
			this.elegir_anio ();
		} else {
			this.elegir_lista ();
		}
	}

	public App () {
		app = this;
		Configuracion.set_config ();
		this.datos = new Datos ();
	}
}
