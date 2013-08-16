/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2013 Fernando Fernandez <fernando@softwareperonista.com.ar>
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
using Gee;

public class Nomeolvides.Anios_hechos_vista : Gtk.Box {

	private ViewHechos hechos_view;
	private ViewAnios anios_view;
	private TreeViewListas listas_view;
	private VistaHecho vista_hecho;
	private ScrolledWindow scroll_hechos_view;
	private ScrolledWindow scroll_anios_view;
	private ScrolledWindow scroll_listas_view;
	private Notebook anios_listas;
	private int anio_actual;
	private Lista lista_actual;

	public Anios_hechos_vista () {
		this.anios_view = new ViewAnios ();
		this.hechos_view = new ViewHechos ();
		this.listas_view = new TreeViewListas.ventana_principal ();
		this.vista_hecho = new VistaHecho ();
		this.vista_hecho.set_size_request (300,-1);

		this.scroll_hechos_view = new ScrolledWindow (null,null);
		this.scroll_anios_view = new ScrolledWindow (null,null);
		this.scroll_listas_view = new ScrolledWindow (null,null);
		this.scroll_hechos_view.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		this.scroll_anios_view.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		this.scroll_listas_view.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);

		this.anios_listas = new Notebook ();
		
		this.hechos_view.cursor_changed.connect ( this.elegir_hecho );
		this.anios_view.cursor_changed.connect ( this.elegir_anio );
		this.listas_view.cursor_changed.connect ( this.elegir_lista );
		this.hechos_view.row_activated.connect ( mostrar_vista );
		this.anios_listas.switch_page.connect ( cambiar_pestania );

		Separator separador = new Separator(Orientation.VERTICAL);

		this.anio_actual = 0;

		this.scroll_hechos_view.add ( this.hechos_view );
		this.scroll_anios_view.add ( this.anios_view );
		this.scroll_listas_view.add ( this.listas_view );

		this.anios_listas.append_page ( this.scroll_anios_view, new Label("Años") );
		this.anios_listas.append_page ( this.scroll_listas_view, new Label ("Listas") );
		
		this.pack_start (this.anios_listas, false, false, 0);
		this.pack_start (new Separator(Orientation.VERTICAL), false, false, 2);
		this.pack_start (this.scroll_hechos_view, true, true, 0);
		this.pack_start (separador, false, false, 2);
		this.pack_start (this.vista_hecho, false, false, 0);
	}

	private void elegir_hecho () {
		this.hechos_cursor_changed();
		if (this.vista_hecho.visible == true ) {
			this.mostrar_hecho ();
		}
	}
	private void elegir_anio () {
		if ( this.anio_actual != this.anios_view.get_anio () ) {
			this.anio_actual = this.anios_view.get_anio ();
			this.lista_actual = null; //ningina lista
			this.anios_cursor_changed();
			this.mostrar_scroll_vista ( false );
		}
	}

	private void elegir_lista () {
		if ( this.lista_actual != this.listas_view.get_lista () ) {
			this.lista_actual = this.listas_view.get_lista ();
			this.anio_actual = 0; //ningún anio
			this.listas_cursor_changed ();
			this.mostrar_scroll_vista ( false );
		}
	}

	private void cambiar_pestania () {
		if ( this.anio_actual != 0 ) {
			this.elegir_lista ();
		} else {
			this.elegir_anio ();
		}
	}

	private void mostrar_vista () {
		if (this.vista_hecho.visible == true ) {
			this.vista_hecho.set_visible (false);
		} else {
			this.mostrar_hecho ();
		}
	}

	private void mostrar_hecho () {
		Hecho hecho_a_mostrar;
		this.hechos_view.get_hecho_cursor( out hecho_a_mostrar );

		if ( hecho_a_mostrar != null ) {
			this.vista_hecho.set_datos_hecho ( hecho_a_mostrar );
			this.vista_hecho.set_visible ( true );
		}
	}	

	public void mostrar_scroll_vista ( bool mostrar ) {	
		if ( mostrar == true ) {
			this.vista_hecho.show_all ();
		} else {	
			this.vista_hecho.hide ();
		}	
	}

	public void cargar_lista_anios ( ArrayList<int> anios ) {
		this.anios_view.agregar_varios ( anios );
	}

	public void cargar_listas ( ListStoreListas listas ) {
		this.listas_view.set_model ( listas );
	}

	public void cargar_lista_hechos ( ListStoreHechos hechos ) {
		this.hechos_view.mostrar_anio ( hechos );
	}

	public int get_anio_actual () {
		return this.anio_actual;
	}

	public Lista get_lista_actual () {
		return this.lista_actual;
	}

	public TreePath get_hecho_actual ( out Hecho hecho ) {
		return this.hechos_view.get_hecho_cursor (out hecho );
	}

	public string get_nombre_pestania () {
		return this.anios_listas.get_tab_label_text ( this.anios_listas.get_nth_page
		                                               ( this.anios_listas.get_current_page () ) );
	}

	public signal void hechos_cursor_changed ();
	public signal void anios_cursor_changed ();
	public signal void listas_cursor_changed ();
}
