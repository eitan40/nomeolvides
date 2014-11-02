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

public class Nomeolvides.Toolbar : Gtk.Box {

	public Button add_button { get; private set; }
	public Button undo_button { get; private set; }
	public Button redo_button { get; private set; }
	public Button edit_button { get; private set; }
	public Button delete_button { get; private set; }
	protected Box izquierda_box;
	protected Box centro_box;

	public Toolbar () {
		this.orientation = Orientation.HORIZONTAL;

		this.izquierda_box = new Box (Orientation.HORIZONTAL, 0);
		this.centro_box = new Box (Orientation.HORIZONTAL, 0);

		this.izquierda_box.set_halign ( Align.START );
		this.centro_box.set_halign ( Align.END );

		this.izquierda_box.get_style_context().add_class ( Gtk.STYLE_CLASS_LINKED );
		this.centro_box.get_style_context().add_class ( Gtk.STYLE_CLASS_LINKED );

		this.pack_start ( this.izquierda_box );
		this.pack_start ( this.centro_box );

		this.add_button = new NmoButton ( _("Add") );
		this.undo_button = new NmoButton ( _("Undo") );
		this.redo_button = new NmoButton ( _("Redo") );
		this.edit_button = new NmoButton ( _("Edit") );
		this.delete_button = new NmoButton ( _("Delete") );
	#if DISABLE_GNOME3
		this.add_button.set_margin_left ( 2 );
		this.delete_button.set_margin_right ( 2 );
	#else
		this.get_style_context().add_class ("toolbar");
		this.add_button.set_margin_start ( 2 );
		this.delete_button.set_margin_end ( 2 );
	#endif
		this.undo_button.set_sensitive ( false );
		this.redo_button.set_sensitive ( false );
		this.set_buttons_invisible ();

		this.izquierda_box.pack_start ( this.add_button );
		this.izquierda_box.pack_start ( this.undo_button );
		this.izquierda_box.pack_start ( this.redo_button );

		this.centro_box.pack_start ( this.edit_button );
		this.centro_box.pack_start ( this.delete_button );
		this.show.connect ( this.set_buttons_invisible );
	}

	public void set_buttons_visible () {
		this.edit_button.set_visible ( true );
		this.delete_button.set_visible ( true );
	}

	public void set_buttons_invisible () {
		this.edit_button.set_visible ( false );
		this.delete_button.set_visible ( false );
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
