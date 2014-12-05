/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * nomeolvides-box-toolbar.vala
 * Copyright (C) 2014 Fernando Fernandez <fernando@softwareperonista.com.ar>
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

#if DISABLE_GNOME3
public class Nomeolvides.NmoHeaderBar : Box {
#else
public class Nomeolvides.NmoHeaderBar : Gtk.HeaderBar {
#endif
	
	public Button add_button { get; private set; }
	public Button undo_button { get; private set; }
	public Button redo_button { get; private set; }
	public Button edit_button { get; private set; }
	public Button delete_button { get; private set; }
	public Button send_button { get; private set; }
	public Button list_button { get; private set; }
#if DISABLE_GNOME3
	public Label titulo_label {get; private set;}
#endif
	
	public NmoHeaderBar () {

#if DISABLE_GNOME3
		this.spacing = 0;
		this.orientation = Gtk.Orientation.HORIZONTAL;
		this.set_homogeneous ( true );
		this.hexpand = true;

		this.titulo_label = new Label ( "" );
#else
		this.has_subtitle = false;
		this.set_show_close_button ( true );
#endif
		
		this.add_button = new NmoButton ( _("Add") );
		this.undo_button = new NmoButton ( _("Undo") );
		this.redo_button = new NmoButton ( _("Redo") );
		this.edit_button = new NmoButton ( _("Edit") );
		this.delete_button = new NmoButton ( _("Delete") );

		this.send_button = new NmoButton ( _("Send") );
		this.list_button = new NmoButton ( _("List") );
		this.list_button_set_agregar ();

		this.undo_button.set_sensitive ( false );
		this.redo_button.set_sensitive ( false );
		this.set_buttons_invisible ();

		var box_izquierda = new Box ( Gtk.Orientation.HORIZONTAL, 0);
		box_izquierda.get_style_context().add_class ( Gtk.STYLE_CLASS_LINKED );
		
#if DISABLE_GNOME3
		box_izquierda.margin = 2;
#endif
		box_izquierda.pack_start ( this.add_button );
		box_izquierda.pack_start ( this.undo_button );
		box_izquierda.pack_start ( this.redo_button );

		var box_derecha = new Box ( Gtk.Orientation.HORIZONTAL, 0);
		box_derecha.get_style_context().add_class ( Gtk.STYLE_CLASS_LINKED );

#if DISABLE_GNOME3
		var box_centro = new Box ( Gtk.Orientation.HORIZONTAL, 0);

		box_izquierda.hexpand = true;
		box_centro.hexpand = true;
		box_derecha.hexpand = true;

		box_izquierda.halign = Gtk.Align.START;
		box_centro.halign = Gtk.Align.CENTER;
		box_derecha.halign = Gtk.Align.END;

		box_centro.pack_start ( this.titulo_label );

		box_derecha.margin = 2;
#endif

		box_derecha.pack_end ( this.edit_button );
		box_derecha.pack_end ( this.delete_button );
		box_derecha.pack_end ( this.send_button );
		box_derecha.pack_end ( this.list_button );

#if DISABLE_GNOME3
		this.pack_start ( box_izquierda );
		this.pack_start ( box_centro );
		this.pack_end ( box_derecha );
#else
		this.pack_start ( box_izquierda );
		this.pack_end ( box_derecha );
#endif		

		this.show.connect ( this.set_buttons_invisible );
	}

#if DISABLE_GNOME3
	public void set_title ( string titulo ) {
		this.titulo_label.set_markup ("<span weight='bold'>" + titulo + "</span>");
	}
#endif

	public void set_label_anio ( string anio = "0" ) {
		if ( anio != "0") {
			this.set_title ( _("Year") + ": " + anio );
		} else {
			this.set_title ( "" );
		}
	}

	public void set_label_lista ( string lista = "" ) {
		if ( lista != "") {
			this.set_title ( lista );
		} else {
			this.set_title ( "" );
		}
	}

	public new void set_buttons_visible () {
		this.set_buttons_multiseleccion_visible ();
		this.edit_button.set_visible ( true );
	}

	public void set_buttons_multiseleccion_visible () {
		this.edit_button.set_visible ( false );
		this.delete_button.set_visible ( true );
		this.send_button.set_visible ( true );
		this.list_button.set_visible ( true );

	}

	public new void set_buttons_invisible () {
		this.edit_button.set_visible ( false );
		this.delete_button.set_visible ( false );
		this.send_button.set_visible ( false );
		this.list_button.set_visible ( false );
	}

	public void list_button_set_agregar ( ) {
		this.list_button.set_label (_("Add to list"));
	}

	public void list_button_set_quitar ( ) {
		this.list_button.set_label (_("Remove from list"));
	}

	public void activar_deshacer () {
		this.undo_button.set_sensitive ( true );
	}

	public void desactivar_deshacer () {
		this.undo_button.set_sensitive ( false );
	}

	public void activar_rehacer () {
		this.redo_button.set_sensitive ( true );
	}

	public void desactivar_rehacer () {
		this.redo_button.set_sensitive ( false );
	}

}