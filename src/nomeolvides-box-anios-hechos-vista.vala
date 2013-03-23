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
	private VistaHecho vista_hecho;
	private ScrolledWindow scroll_vista_hecho;
	private ArrayList<string> lista_anios;

	public Anios_hechos_vista () {

		this.anios_view = new ViewAnios ();
		this.hechos_view = new ViewHechos ();
		this.vista_hecho = new VistaHecho ();

		this.scroll_vista_hecho = new ScrolledWindow (null,null);
		this.scroll_vista_hecho.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		this.scroll_vista_hecho.set_size_request (300,-1);
		
		this.hechos_view.cursor_changed.connect ( this.elegir_hecho );
		this.anios_view.cursor_changed.connect ( this.elegir_anio );
		this.hechos_view.row_activated.connect ( mostrar_vista );

		Separator separador = new Separator(Orientation.VERTICAL);

		this.scroll_vista_hecho.add_with_viewport (this.vista_hecho);
		
		this.pack_start (anios_view, false, false, 0);
		this.pack_start (new Separator(Orientation.VERTICAL), false, false, 2);
		this.pack_start (this.hechos_view, true, true, 0);
		this.pack_start (separador, false, false, 2);
		this.pack_start (scroll_vista_hecho, false, false, 0);

	}

	private void elegir_hecho () {
		this.hechos_cursor_changed();
		if (this.scroll_vista_hecho.visible == true ) {
			this.mostrar_hecho ();
		}
	}
	private void elegir_anio () {
		this.anios_cursor_changed();
	}

	private void mostrar_vista () {
		if (this.scroll_vista_hecho.visible == true ) {
			this.scroll_vista_hecho.set_visible (false);
		} else {
			this.mostrar_hecho ();
		}
	}

	private void mostrar_hecho () {
		Hecho hecho_a_mostrar;
		this.hechos_view.get_hecho_cursor( out hecho_a_mostrar );

		if ( hecho_a_mostrar != null ) {
			this.vista_hecho.set_datos_hecho ( hecho_a_mostrar );
			this.scroll_vista_hecho.set_visible ( true );
		}
	}	

	public void mostrar_scroll_vista ( bool mostrar ) {	
		if ( mostrar == true ) {
			this.scroll_vista_hecho.show_all ();
		} else {	
			this.scroll_vista_hecho.hide ();
		}	
	}

	public void cargar_lista_anios ( ArrayList<string> anios )
	{
		this.lista_anios = anios;
		this.anios_view.agregar_varios ( anios );
	}

	public void cargar_lista_hechos ( ListStoreHechos hechos ) {
		this.hechos_view.mostrar_anio ( hechos );
	}

	public string get_anio_actual () {
		string anio = this.anios_view.get_anio ();
		return anio;
	}

	public TreePath get_hecho_actual ( out Hecho hecho ) {
		return this.hechos_view.get_hecho_cursor (out hecho );
	}

	public signal void hechos_cursor_changed ();
	public signal void anios_cursor_changed ();
}
