/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * nomeolvides-dialog-error.vala
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
using GLib;
using Gtk;

public class Nomeolvides.DialogError : Gtk.Dialog {

	 private Label descripcion;


	// Constructor
	public DialogError (string error) {
		this.modal = true;
		//this.set_default_size (300,200);

		this.descripcion = new Label.with_mnemonic ( error );
		#if DISABLE_GNOME3
		this.descripcion.set_margin_left ( 15 );
		this.descripcion.set_margin_right ( 15 );
		#else
		this.descripcion.set_margin_start ( 15 );
		this.descripcion.set_margin_end ( 15 );
		#endif
		this.add_button ( _("Close"), Gtk.ResponseType.CLOSE);

		var contenido = this.get_content_area() as Box;
		contenido.set_halign ( Align.CENTER );
		contenido.pack_start ( this.descripcion, false, false, 0 );

		this.show_all ();
	}

}

