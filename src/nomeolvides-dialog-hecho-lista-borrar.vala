/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2013 Andres Fernandez <andres@softwareperonista.com.ar>
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

public class Nomeolvides.DialogHechoListaBorrar : Dialog {
	public Array<Hecho> hechos;
	private Lista lista;
	private Label hecho_nombre;
	private Label lista_nombre;
	private Label hecho_label;
	private Label lista_label;
	private Label pregunta;
	private Grid grid;
	
	public DialogHechoListaBorrar ( VentanaPrincipal ventana ) {
#if DISABLE_GNOME3
#else
		Object (use_header_bar: 1);
#endif
		this.set_transient_for ( ventana as Window );
		this.set_default_size ( 450, 200 );

		this.pregunta = new Label.with_mnemonic ( "" );
		this.hecho_label = new Label.with_mnemonic ( "");
		this.hecho_nombre = new Label ( "" );
		this.lista_label = new Label.with_mnemonic ( _("From list") + ":" );
		this.lista_nombre = new Label ( "" );
		this.hechos = new Array<Hecho> ();
		this.grid = new Grid ();

		pregunta.set_halign ( Align.CENTER );
		pregunta.set_margin_bottom ( 10 );
		pregunta.set_hexpand ( true );
		hecho_label.set_halign ( Align.END );
		hecho_label.set_margin_bottom ( 10 );
		hecho_nombre.set_halign ( Align.START );
		hecho_nombre.set_margin_bottom ( 10 );
		lista_label.set_halign ( Align.END );
		lista_nombre.set_halign ( Align.START );
#if DISABLE_GNOME3
		hecho_label.set_margin_right ( 20 );
		hecho_nombre.set_margin_left ( 20 );
		lista_label.set_margin_right ( 20 );
		lista_nombre.set_margin_left ( 20 );
		grid.set_margin_right ( 20 );
		grid.set_margin_left ( 20 );
#else
		hecho_label.set_margin_end ( 20 );
		hecho_nombre.set_margin_start ( 20 );
		lista_label.set_margin_end ( 20 );
		lista_nombre.set_margin_start ( 20 );
		grid.set_margin_end ( 20 );
		grid.set_margin_start ( 20 );
#endif

		grid.set_valign ( Align.CENTER );
		grid.set_halign ( Align.CENTER );
		grid.set_margin_top ( 15 );
		grid.set_margin_bottom ( 15 );
		grid.set_size_request ( 400, -1 );
		grid.set_hexpand ( true );

		grid.attach ( pregunta, 0, 0, 2, 1 );
		grid.attach ( lista_label, 0, 2, 1, 1 );
		grid.attach ( lista_nombre, 1, 2, 1, 1 );

		this.set_title ( _("Remove Fact from List") );
		
		this.response.connect ( on_response );
#if DISABLE_GNOME3
		this.add_button ( _("Remove") , ResponseType.APPLY );
#else
		var boton = this.add_button ( _("Remove") , ResponseType.APPLY );
		boton.get_style_context ().add_class ( "suggested-action" );
#endif

		var contenido = this.get_content_area () as Box;
		contenido.pack_start ( grid, true, true, 0 );

		this.show_all ();
	}

	public void set_hechos ( Array<Hecho> hechos_elegidos ) {
		if ( hechos_elegidos.length == 1 ) {
			this.pregunta.set_label ( _("Do you want to remove this fact from the list?") );
			this.hecho_label.set_label (  _("Fact") + ":" );
			if( hecho_label.get_text ().length > 50 ) {
				this.hecho_label.set_size_request ( 600, -1 );
				this.hecho_label.set_line_wrap_mode ( Pango.WrapMode.WORD );
				this.hecho_label.set_line_wrap ( true );
			}
			this.hecho_nombre.set_markup (  "<span font_weight=\"heavy\">"+ hechos_elegidos.index (0).nombre +"</span>" );
			this.grid.attach ( hecho_nombre, 1, 1, 1, 1 );
		} else {
			this.title = _("Remove Facts from List");
			this.set_size_request ( 600, 200 );
			this.pregunta.set_label ( _("Do you want to remove this facts from the list?") );
			this.hecho_label.set_label (  _("Facts") + ":" );
			var treeview_hechos = new TreeViewHechos ();
			var scroll_hechos = new ScrolledWindow ( null, null );
			scroll_hechos.set_policy ( PolicyType.NEVER, PolicyType.AUTOMATIC );
			treeview_hechos.set_margin_bottom ( 10 );
			treeview_hechos.mostrar_hechos ( hechos_elegidos );
			scroll_hechos.set_size_request ( 100, 110 );
			scroll_hechos.add ( treeview_hechos );
			this.grid.attach ( scroll_hechos, 1, 1, 1, 1 );
		}

		for ( int i = 0; i < hechos_elegidos.length; i++ ) {
			this.hechos.append_val ( hechos_elegidos.index ( i ) );
		}

		grid.attach ( hecho_label, 0, 1, 1, 1 );
		this.show_all ();
	}

	public void set_lista ( Lista lista ) {
		this.lista_nombre.set_markup ( "<span font_weight=\"heavy\">"+ lista.nombre +"</span>");
		this.lista = lista;
	}

	private void on_response (Dialog source, int response_id) {
        switch (response_id) {
    		case ResponseType.CANCEL:
        		this.hide ();
        		break;
        }
    }

	public Lista get_lista () {
		return this.lista;
	}
}