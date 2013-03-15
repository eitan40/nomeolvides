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
 *   bullit - 39 escalones - silent love (japonesa) 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Gee;
using Nomeolvides;

public class Nomeolvides.VentanaPrincipal : Gtk.ApplicationWindow
{

	private Box main_box { get; private set; }
	private MainToolbar toolbar { get; private set; }
	public Anios_hechos_vista anios_hechos { get; private set; }
	public HechosFuentes fuentes;
	
	public VentanaPrincipal ( Gtk.Application app )
	{   
		Object (application: app);
		this.set_application (app);
		this.set_title ("Nomeolvides v" + Config.VERSION );
		this.set_position (WindowPosition.CENTER);
		this.set_default_size (800,500);
		this.set_size_request (500,350);
		this.hide_titlebar_when_maximized = true;

		this.main_box = new Box (Orientation.VERTICAL,0);

		this.anios_hechos = new Anios_hechos_vista ();
		
		this.add (main_box);
		
		this.toolbar = new MainToolbar ();
	
		this.main_box.pack_start (toolbar, false, false, 0);
		this.main_box.pack_start (anios_hechos, true, true, 0);

		this.conectar_seniales ();
	}


	private void conectar_seniales () {
		this.toolbar.open_button.clicked.connect ( this.toolbar_open_button_clicked_signal );
		this.toolbar.save_button.clicked.connect ( this.toolbar_save_button_clicked_signal );
		this.toolbar.add_button.clicked.connect ( this.toolbar_add_button_clicked_signal );
		this.toolbar.edit_button.clicked.connect ( this.toolbar_edit_button_clicked_signal );
		this.toolbar.delete_button.clicked.connect ( this.toolbar_delete_button_clicked_signal );
		this.toolbar.send_button.clicked.connect ( this.toolbar_send_button_clicked_signal );

		this.anios_hechos.anios_cursor_changed.connect ( this.anios_hechos_anios_cursor_changed_signal );
	}

	private void toolbar_open_button_clicked_signal () {
		this.toolbar_open_button_clicked ();
	}

	private void toolbar_save_button_clicked_signal () {
		this.toolbar_save_button_clicked ();
	}

	private void toolbar_add_button_clicked_signal () {
		this.toolbar_add_button_clicked ();
	}

	private void toolbar_edit_button_clicked_signal () {
		this.toolbar_edit_button_clicked ();
	}

	private void toolbar_delete_button_clicked_signal () {
		this.toolbar_delete_button_clicked ();
	}

	private void toolbar_send_button_clicked_signal () {
		this.toolbar_send_button_clicked ();
	}

	private void anios_hechos_anios_cursor_changed_signal () {
		this.anios_hechos_anios_cursor_changed ();
	}

	public void cargar_anios_view ( ArrayList<string> ventana_principal_anios ) {
		this.anios_hechos.cargar_lista_anios ( ventana_principal_anios );
	}

/*
	public void elegir_hecho () {
		Hecho hecho = new Hecho.vacio();
		
		if(this.hechos_view.get_hecho_cursor ( out hecho ) != null) {
			this.toolbar.set_buttons_visible ( true );
		} else {
			this.toolbar.set_buttons_visible ( false );		
		}

		this.scroll_vista_hecho.set_visible ( false );
	}

	public void mostrar_hecho () {
		Hecho hecho_a_mostrar; 

		this.hechos_view.get_hecho_cursor( out hecho_a_mostrar );

		if (this.scroll_vista_hecho.visible == true ) {
			this.scroll_vista_hecho.set_visible (false);
		} else {
			if ( hecho_a_mostrar != null ) {
				this.vista_hecho.set_datos_hecho ( hecho_a_mostrar );
				this.scroll_vista_hecho.set_visible ( true );
			}
		}
	}	
	
	public void show_visible () {
		this.show_all ();
		this.scroll_vista_hecho.hide ();
	}

	public void label_anio () {
		this.toolbar.set_anio( this.hechos_view.anio_actual );
	}*/
	public signal void toolbar_open_button_clicked ();
	public signal void toolbar_save_button_clicked ();
	public signal void toolbar_add_button_clicked ();
	public signal void toolbar_edit_button_clicked ();
	public signal void toolbar_delete_button_clicked ();
	public signal void toolbar_send_button_clicked ();
	public signal void anios_hechos_anios_cursor_changed ();
}
