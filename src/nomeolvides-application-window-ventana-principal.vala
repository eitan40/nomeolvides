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
using Nomeolvides;

public class Nomeolvides.VentanaPrincipal : Gtk.ApplicationWindow
{

	private Box main_box { get; private set; }
	private HeaderBar toolbar { get; private set; }
	public Anios_hechos_vista anios_hechos { get; private set; }
	private int anio_actual;
	private Lista lista_actual;
	
	public VentanaPrincipal ( Gtk.Application app )
	{   
		Object (application: app);
		this.set_application (app);
		this.set_title ("Nomeolvides v" + Config.VERSION );
		this.set_position (WindowPosition.CENTER);
		this.set_default_size (1100,600);
		this.set_size_request (500,350);

		this.anio_actual = 0;
		
		this.main_box = new Box (Orientation.VERTICAL,0);

		this.anios_hechos = new Anios_hechos_vista ();
		
		this.add (main_box);
		
		this.toolbar = new HeaderBar ();
	#if NO_HEADERBAR
		this.main_box.pack_start ( this.toolbar, false, false, 0 );
	#else
		this.set_titlebar ( toolbar );
	#endif
		this.main_box.pack_start ( anios_hechos, true, true, 0 );

		this.conectar_seniales ();
	}


	private void conectar_seniales () {

		this.toolbar.add_button.clicked.connect ( this.toolbar_add_button_clicked_signal );
		this.toolbar.undo_button.clicked.connect ( this.toolbar_undo_button_clicked_signal );
		this.toolbar.redo_button.clicked.connect ( this.toolbar_redo_button_clicked_signal );
		this.toolbar.edit_button.clicked.connect ( this.toolbar_edit_button_clicked_signal );
		this.toolbar.delete_button.clicked.connect ( this.toolbar_delete_button_clicked_signal );
		this.toolbar.send_button.clicked.connect ( this.toolbar_send_button_clicked_signal );

		this.toolbar.cerrar_signal.connect ( this.close );

		this.anios_hechos.anios_cursor_changed.connect ( this.anios_hechos_anios_cursor_changed_signal );
		this.anios_hechos.listas_cursor_changed.connect ( this.anios_hechos_listas_cursor_changed_signal );
		this.anios_hechos.hechos_cursor_changed.connect ( this.elegir_hecho );
	}

	private void toolbar_add_button_clicked_signal () {
		this.toolbar_add_button_clicked ();
	}

	private void toolbar_undo_button_clicked_signal () {
		this.toolbar_undo_button_clicked ();
	}

	private void toolbar_redo_button_clicked_signal () {
		this.toolbar_redo_button_clicked ();
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

	private void toolbar_list_button_agregar_clicked_signal () {
		this.toolbar_list_agregar_button_clicked ();
	}

	private void toolbar_list_button_quitar_clicked_signal () {
		this.toolbar_list_quitar_button_clicked ();
	}

	private void anios_hechos_anios_cursor_changed_signal () {
		this.anio_actual = this.anios_hechos.get_anio_actual ();
		if ( this.anio_actual != 0 ) {
			this.toolbar.list_button_set_agregar ();
			this.toolbar.list_button.clicked.disconnect (this.toolbar_list_button_quitar_clicked_signal);
			this.toolbar.list_button.clicked.disconnect (this.toolbar_list_button_agregar_clicked_signal);
			this.toolbar.list_button.clicked.connect ( this.toolbar_list_button_agregar_clicked_signal );
			this.anios_hechos_anios_cursor_changed ();
		}
		
		this.actualizar_anio_label ();
	}

	private void anios_hechos_listas_cursor_changed_signal () {
		this.lista_actual = this.anios_hechos.get_lista_actual ();
		if (this.lista_actual != null ) {
			this.toolbar.list_button_set_quitar ();
			this.toolbar.list_button.clicked.disconnect (this.toolbar_list_button_quitar_clicked_signal);
			this.toolbar.list_button.clicked.disconnect (this.toolbar_list_button_agregar_clicked_signal);
			this.toolbar.list_button.clicked.connect ( this.toolbar_list_button_quitar_clicked_signal );
			this.anios_hechos_listas_cursor_changed ();
		}

		this.actualizar_lista_label ();
	}

	public void cargar_anios_view ( Array<int> ventana_principal_anios ) {
		this.anios_hechos.cargar_lista_anios ( ventana_principal_anios );
	}

	public void cargar_listas_view ( ListStoreListas listas ) {
		this.anios_hechos.cargar_listas ( listas );
		this.anios_hechos.mostrar_scroll_vista ( false );
	}

	public void cargar_hechos_view ( ListStoreHechos hechos ) {
		this.anios_hechos.cargar_lista_hechos ( hechos );
		this.anios_hechos.mostrar_scroll_vista ( false );
	}

	private void actualizar_anio_label () {
		if ( this.anio_actual != 0) {
			this.toolbar.set_label_anio ( this.anio_actual.to_string() );
		} else {
			this.toolbar.set_label_anio ( );

		}
	}

	private void actualizar_lista_label () {
		if ( this.lista_actual != null ) {
			this.toolbar.set_label_lista ( this.lista_actual.nombre );
		} else {
			this.toolbar.set_label_lista ( );
		}	
	}

	public int get_anio_actual () {
		return this.anio_actual;
	}

	public Lista get_lista_actual () {
		return this.lista_actual;
	}

	public TreePath get_hecho_actual ( out Hecho hecho ) {
		return this.anios_hechos.get_hecho_actual (out hecho );
	}

	private void elegir_hecho () {
		Hecho hecho; 
		this.get_hecho_actual ( out hecho );
		
		if ( hecho != null ) { 
			this.toolbar.set_buttons_visible ();
		} else {
			this.toolbar.set_buttons_invisible ();		
		}
	}
	
	public void show_visible () {
		this.show_all ();
		this.anios_hechos.mostrar_scroll_vista ( false );
	}

	public string get_pestania () {
		return this.anios_hechos.get_nombre_pestania ();
	}

	public void activar_boton_deshacer () {
		this.toolbar.activar_deshacer ();
	}

	public void desactivar_boton_deshacer () {
		this.toolbar.desactivar_deshacer ();
	}

	public void activar_boton_rehacer () {
		this.toolbar.activar_rehacer ();
	}

	public void desactivar_boton_rehacer () {
		this.toolbar.desactivar_rehacer ();
	}

	public void limpiar_hechos_view () {
		this.anios_hechos.limpiar_hechos_view ();
	}
	
	public signal void toolbar_add_button_clicked ();
	public signal void toolbar_undo_button_clicked ();
	public signal void toolbar_redo_button_clicked ();
	public signal void toolbar_edit_button_clicked ();
	public signal void toolbar_delete_button_clicked ();
	public signal void toolbar_send_button_clicked ();
	public signal void toolbar_list_quitar_button_clicked ();
	public signal void toolbar_list_agregar_button_clicked ();
	public signal void anios_hechos_anios_cursor_changed ();
	public signal void anios_hechos_listas_cursor_changed ();	
}
