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

public class Nomeolvides.HeaderBar : Toolbar {

	public Button send_button { get; private set; }
	public Button list_button { get; private set; }
	public Label anio_label { get; private set; }
	protected Box derecha_box;
	// Constructor
	public HeaderBar () {
	#if DISABLE_GNOME3
		this.get_style_context().add_class ( Gtk.STYLE_CLASS_PRIMARY_TOOLBAR );
		this.get_style_context().add_class ( Gtk.STYLE_CLASS_TOOLBAR );
	#else
		this.get_style_context().add_class ( "header-bar" );
		this.get_style_context().add_class ( Gtk.STYLE_CLASS_TITLEBAR );
	#endif
		this.set_halign ( Align.FILL );
		this.derecha_box = new Box (Orientation.HORIZONTAL, 0);
		this.anio_label = new Label ("");

		this.centro_box.set_halign ( Align.CENTER );
		this.derecha_box.set_halign ( Align.END );
	#if DISABLE_GNOME3
		this.izquierda_box.set_margin_left ( 8 );
		this.derecha_box.set_margin_right ( 8 );
		this.anio_label.set_margin_right ( 2 );
	#else
		this.izquierda_box.set_border_width ( 6 );
		this.derecha_box.set_border_width ( 6 );
		this.centro_box.set_border_width ( 6 );

		this.anio_label.set_margin_end ( 2 );
	#endif
		this.pack_start ( derecha_box );

		this.send_button = new NmoButton ( _("Send") );
		this.list_button = new NmoButton ( _("List") );
		this.list_button_set_agregar ();

		this.centro_box.pack_start ( this.send_button );
		this.centro_box.pack_start ( this.list_button );
	#if DISABLE_GNOME3
	#else
		var boton_cerrar = new NmoButton.icono ( "window-close-symbolic", IconSize.MENU );
		boton_cerrar.get_style_context().add_class ( "titlebutton" );
		boton_cerrar.get_style_context().remove_class ( "image-button" );
		boton_cerrar.clicked.connect ( cerrar );
		var separador = new Gtk.Separator ( Orientation.VERTICAL );

		this.derecha_box.pack_end ( boton_cerrar );
		this.derecha_box.pack_end ( separador );
	#endif
		this.derecha_box.pack_end ( this.anio_label );
		this.show.connect ( this.set_buttons_invisible );
	}

	public void set_label_anio ( string anio = "0" ) {
		if ( anio != "0") {
			this.anio_label.set_markup ( "<span font_size=\"x-large\" font_weight=\"heavy\"> " + _("Year") + ": " + anio + "</span>" );
		} else {
			this.anio_label.set_text ( "" );
		}
	}

	public void set_label_lista ( string lista = "" ) {
		if ( lista != "") {
			this.anio_label.set_markup ( "<span font_size=\"x-large\" font_weight=\"heavy\">" + lista + "</span>" );
		} else {
			this.anio_label.set_text ( "" );
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

	public void cerrar () {
		this.cerrar_signal ();
	}

	public signal void cerrar_signal ();
}

