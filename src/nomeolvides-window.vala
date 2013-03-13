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

public class Nomeolvides.Window : Gtk.ApplicationWindow
{
	private Box main_box;
	private Box list_view_box;	
	public MainToolbar toolbar { get; private set; }
	public ViewHechos hechos_view { get; private set; }
	public ViewAnios anios_view { get; private set; }
	public VistaHecho vista_hecho { get; private set; }
	public ScrolledWindow scroll_vista_hecho;
	
	public Window ( Gtk.Application app )
	{   
		Object (application: app);
		this.set_application (app);
		this.set_title ("Nomeolvides v" + Config.VERSION );
		this.set_position (WindowPosition.CENTER);
		this.set_default_size (800,500);
		this.set_size_request (500,350);
		this.hide_titlebar_when_maximized = true;

		main_box = new Box (Orientation.VERTICAL,0);
		list_view_box = new Box (Orientation.HORIZONTAL,0);
		this.scroll_vista_hecho = new ScrolledWindow (null,null);
		this.scroll_vista_hecho.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		this.scroll_vista_hecho.set_size_request (300,-1);
		
		this.add (main_box);
		
		this.toolbar = new MainToolbar ();

		this.anios_view = new ViewAnios ();
		this.hechos_view = new ViewHechos ();
		this.vista_hecho = new VistaHecho ();
		
		this.hechos_view.cursor_changed.connect ( this.elegir_hecho );
		this.hechos_view.row_activated.connect ( mostrar_hecho );
		this.hechos_view.row_activated.connect ( mostrar_hecho );

		Separator separador = new Separator(Orientation.VERTICAL);

		this.scroll_vista_hecho.add_with_viewport (this.vista_hecho);
		
		list_view_box.pack_start (anios_view, false, false, 0);
		list_view_box.pack_start (new Separator(Orientation.VERTICAL), false, false, 2);
		list_view_box.pack_start (this.hechos_view, true, true, 0);
		list_view_box.pack_start (separador, false, false, 2);
		list_view_box.pack_start (scroll_vista_hecho, false, false, 0);

		this.main_box.pack_start (toolbar, false, false, 0);
		this.main_box.pack_start (list_view_box, true, true, 0);
	}



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
	}
}
