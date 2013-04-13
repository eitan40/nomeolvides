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
using Gee;

public class Nomeolvides.App : Gtk.Application 
{
	public static App app;
	public VentanaPrincipal window;
	public Datos datos;
	public GLib.Menu application_menu;

	private const GLib.ActionEntry[] actions_app_menu = {
		{ "create-about-dialog", about_dialog },
		{ "exportar", exportar },
		{ "window-destroy", salir_app },
		{ "config-db-dialog", config_db_dialog },
		{ "config-listas-dialog", config_listas_dialog }
	};

	private void create_window () {
		this.window = new VentanaPrincipal (this);

		this.create_app_menu ( );
		this.connect_signals ();

		this.window.show_visible ();
		this.cargar_lista_anios ();
		this.cargar_listas ();
	}

	public override void activate () {
		create_window();
		app.window.show();
	}

	public void create_app_menu () {
		this.application_menu = new GLib.Menu ();
		
		this.application_menu.append ( "Configurar Bases de Datos", "app.config-db-dialog" );
		this.application_menu.append ( "Configurar Listas Personalizadas", "app.config-listas-dialog" );
		this.application_menu.append ( "Exportar", "app.exportar" );
		this.application_menu.append ( "Acerca de Nomeolvides", "app.create-about-dialog" );
		this.application_menu.append ( "Salir", "app.window-destroy" );
		
		this.set_app_menu ( application_menu );		
		this.add_action_entries (actions_app_menu, this);
	}

	private void connect_signals () {
		this.window.toolbar_add_button_clicked.connect ( this.add_hecho_dialog );
		this.window.toolbar_edit_button_clicked.connect ( this.edit_hecho_dialog );
		this.window.toolbar_delete_button_clicked.connect ( this.delete_hecho_dialog );
		this.window.toolbar_send_button_clicked.connect ( this.send_hecho );
		this.window.toolbar_undo_button_clicked.connect ( this.undo_hecho );

		this.window.anios_hechos_anios_cursor_changed.connect ( this.elegir_anio );
		this.window.anios_hechos_listas_cursor_changed.connect ( this.elegir_lista );
		
		this.datos.cambio_anios.connect ( this.cargar_lista_anios );
	}



	public void add_hecho_dialog () {
		var add_dialog = new AddHechoDialog( this.window as VentanaPrincipal, this.datos.fuentes);
		
		add_dialog.show();
		
		if ( add_dialog.run() == ResponseType.APPLY )
		{
			this.datos.agregar_hecho(add_dialog.respuesta);
			this.datos.guardar_un_archivo ( add_dialog.respuesta.archivo_fuente);
		}		
		add_dialog.destroy();
	}
	
	private void elegir_anio () {
		int anio = this.window.get_anio_actual ();
		this.window.cargar_hechos_view ( this.datos.get_liststore_anio ( anio ) );
	}

	private void elegir_lista () {
		string lista = this.window.get_lista_actual ();
		this.window.cargar_hechos_view ( this.datos.get_liststore_lista ( lista ) );
	}

	public void edit_hecho_dialog () {
		TreePath path;
		Hecho hecho; 

		path = this.window.get_hecho_actual ( out hecho );
		
		var edit_dialog = new EditHechoDialog( this.window, this.datos.fuentes );
		edit_dialog.set_datos ( hecho );
		edit_dialog.show_all ();

		if ( edit_dialog.run() == ResponseType.APPLY ) {
			this.datos.eliminar_hecho ( hecho, path );
			this.datos.agregar_hecho ( edit_dialog.respuesta );
			this.datos.guardar_un_archivo ( edit_dialog.respuesta.archivo_fuente);
		}
		edit_dialog.destroy();
	}

	public void delete_hecho_dialog () {
		TreePath path;
		Hecho hecho_a_borrar;
		path = this.window.get_hecho_actual ( out hecho_a_borrar );
	
		BorrarHechoDialogo delete_dialog = new BorrarHechoDialogo ( hecho_a_borrar, this.window as VentanaPrincipal);

		if (delete_dialog.run() == ResponseType.APPLY) {
			this.datos.eliminar_hecho ( hecho_a_borrar, path );
			this.datos.guardar_un_archivo ( hecho_a_borrar.archivo_fuente);
			this.datos.eliminar_hecho_lista ( hecho_a_borrar, path);
			this.datos.guardar_listas_hechos ();
			
		}	
		delete_dialog.destroy ();
	}

	public void about_dialog () {
		Configuracion.create_about_dialog ( this.window );
	}

	private void salir_app () {
		this.window.destroy ();
	}

	private void config_db_dialog () {		
		var fuentes_dialogo = new FuentesDialog ( this.window, this.datos.fuentes.temp() );
		fuentes_dialogo.show_all ();
		if ( fuentes_dialogo.run () == ResponseType.OK ) {
			if (fuentes_dialogo.cambios == true) {				
				this.datos.actualizar_fuentes_predefinidas ( fuentes_dialogo.fuentes_view.get_model () as ListStoreFuentes );
			}
		}
		fuentes_dialogo.destroy ();
	}

	private void config_listas_dialog () {		
		var listas_dialogo = new ListasDialog ( this.window, this.datos.listas.temp() );
		listas_dialogo.show_all ();
		if ( listas_dialogo.run () == ResponseType.OK ) {
			if (listas_dialogo.cambios == true) {				
				this.datos.actualizar_listas_personalizadas ( listas_dialogo.listas_view.get_model () as ListStoreListas );
			}
		}
		listas_dialogo.destroy ();
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

	public void save_as_file_dialog () {
		SaveFileDialog guardar_archivo = new SaveFileDialog(GLib.Environment.get_current_dir ());
		guardar_archivo.set_transient_for ( this as Window );

		if (guardar_archivo.run () == ResponseType.ACCEPT) {		
            this.datos.save_as_file ( guardar_archivo.get_filename () );
		}
		guardar_archivo.close ();
	}

	private void exportar () {
		this.save_as_file_dialog ();
	}

	public void cargar_listas () {
		this.window.cargar_listas_view ( this.datos.lista_de_listas () );
	}

	public void cargar_lista_anios () {
		this.window.cargar_anios_view ( this.datos.lista_de_anios () );
	}

	public App () {
		app = this;
		Configuracion.set_config ();
		this.datos = new Datos ();
	}
}
