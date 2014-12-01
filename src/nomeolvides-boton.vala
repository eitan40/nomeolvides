/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * nomeolvides-button-nmobutton.vala
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

public class Nomeolvides.Boton : Gtk.Button {

	// Constructor
	public Boton ( string label ) {
		this.set_label ( label );
		this.setear_propiedades ();
	}

	public Boton.icono ( string icono, Gtk.IconSize tamanio ) {
		var imagen = new Image.from_icon_name ( icono, tamanio );
		this.set_image ( imagen );
		this.setear_propiedades ();
	}

	public Boton.con_margen ( string label ) {
		this.set_label ( label );
		this.setear_propiedades ();
		this.set_margin_top ( 5 );
		this.set_margin_bottom ( 5 );
	}

	private void setear_propiedades () {
		this.set_halign ( Align.START );
	}
}
