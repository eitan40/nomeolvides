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
public class Nomeolvides.Toolbar : Box {
#else
public class Nomeolvides.Toolbar : Gtk.HeaderBar {
#endif

	public Boton add_button { get; private set; }
	public Boton undo_button { get; private set; }
	public Boton redo_button { get; private set; }
	public Boton edit_button { get; private set; }
	public Boton delete_button { get; private set; }
	public Boton send_button { get; private set; }
	public Boton list_button { get; private set; }

	public Box box_izquierda { get; private set; }
	public Box box_derecha { get; private set; }
	public Box box_centro { get; private set; }
#if DISABLE_GNOME3
	public Label titulo_label {get; private set;}
#endif

	public Toolbar () {

#if DISABLE_GNOME3
		this.spacing = 0;
		this.orientation = Gtk.Orientation.HORIZONTAL;
		this.set_homogeneous ( true );
		this.hexpand = true;

#else
		this.has_subtitle = false;
		this.set_show_close_button ( true );
#endif

		this.add_button = new  Boton ( _("Add") );
		this.undo_button = new  Boton ( _("Undo") );
		this.redo_button = new  Boton ( _("Redo") );
		this.edit_button = new  Boton ( _("Edit") );
		this.delete_button = new  Boton ( _("Delete") );

		this.send_button = null;

		this.undo_button.set_sensitive ( false );
		this.redo_button.set_sensitive ( false );
		this.set_buttons_invisible ();

		this.box_izquierda = new Box ( Gtk.Orientation.HORIZONTAL, 0);
		this.box_izquierda.get_style_context().add_class ( Gtk.STYLE_CLASS_LINKED );

#if DISABLE_GNOME3
		this.box_izquierda.margin = 2;
#endif
		this.box_izquierda.pack_start ( this.add_button );
		this.box_izquierda.pack_start ( this.undo_button );
		this.box_izquierda.pack_start ( this.redo_button );

		this.box_derecha = new Box ( Gtk.Orientation.HORIZONTAL, 0);
		this.box_derecha.get_style_context().add_class ( Gtk.STYLE_CLASS_LINKED );

#if DISABLE_GNOME3
		this.box_centro = new Box ( Gtk.Orientation.HORIZONTAL, 0);

		this.box_izquierda.hexpand = true;
		this.box_centro.hexpand = true;
		this.box_derecha.hexpand = true;

		this.box_izquierda.halign = Gtk.Align.START;
		this.box_centro.halign = Gtk.Align.CENTER;
		this.box_derecha.halign = Gtk.Align.END;

		this.titulo_label = null;

		this.box_derecha.margin = 2;
#endif

		this.box_derecha.pack_end ( this.edit_button );
		this.box_derecha.pack_end ( this.delete_button );

		this.pack_start ( this.box_izquierda );
#if DISABLE_GNOME3
		this.pack_start ( this.box_centro );
#endif
		this.pack_end ( this.box_derecha );

		this.show.connect ( this.set_buttons_invisible );
	}

	public void agregar_send_button () {
		this.send_button = new  Boton ( _("Send") );
		this.box_derecha.pack_end ( this.send_button );
	}

	public void agregar_list_button () {
		this.list_button = new  Boton ( _("List") );
		this.list_button_set_agregar ();
		this.box_derecha.pack_end ( this.list_button );
	}

#if DISABLE_GNOME3
	public void agregar_titulo () {
		this.titulo_label = new Label ( "" );
		this.box_centro.pack_start ( this.titulo_label );
	}

	public void set_title ( string titulo ) {
		if ( this.titulo_label != null ) {
			this.titulo_label.set_markup ("<span weight='bold'>" + titulo + "</span>");
		}
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
		if ( this.send_button != null ) {
			this.send_button.set_visible ( true );
		}
		if ( this.list_button != null ) {
			this.list_button.set_visible ( true );
		}

	}

	public new void set_buttons_invisible () {
		this.edit_button.set_visible ( false );
		this.delete_button.set_visible ( false );
		if ( this.send_button != null ) {
			this.send_button.set_visible ( false );
		}
		if ( this.list_button != null ) {
			this.list_button.set_visible ( false );
		}
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
