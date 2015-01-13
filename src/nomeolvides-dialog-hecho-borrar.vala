/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* Nomeolvides
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

public class Nomeolvides.DialogHechoBorrar : Dialog {
	public Grid grid;
	private Label pregunta;
	private Label hecho;
	public Array<Hecho> hechos;

	public DialogHechoBorrar ( VentanaPrincipal ventana ) {
		this.set_modal ( true );
		this.set_transient_for ( ventana as Gtk.Window );
		this.set_size_request ( 450, 200 );

		this.pregunta = new Label.with_mnemonic ( "" );
		this.hecho = new Label.with_mnemonic ( "" );
		this.hechos = new Array<Hecho> ();

		grid = new Grid ( );
		grid.set_row_spacing ( 20 );
		grid.set_column_spacing ( 10 );
		grid.set_valign ( Align.CENTER );
		grid.set_halign ( Align.CENTER );
		grid.set_margin_top ( 15 );
		grid.set_margin_bottom ( 15 );
	#if DISABLE_GNOME3
		grid.set_margin_left ( 30 );
		grid.set_margin_right ( 30 );
	#else
		grid.set_margin_start ( 30 );
		grid.set_margin_end ( 30 );
		var headerbar = new HeaderBar ();
		this.set_titlebar ( headerbar );
	#endif

		grid.attach ( pregunta, 0, 0, 2, 1 );
		grid.attach ( hecho, 0, 1, 1, 1 );

		this.add_button ( _("Cancel"), ResponseType.CANCEL);
		this.add_button ( _("Apply"), ResponseType.APPLY);
		
		var contenido = this.get_content_area() as Box;
		contenido.pack_start(grid, false, false, 0);

		this.show_all ();
	}

	public void setear_hechos ( Array<Hecho> hechos_elegidos ) {
		if ( hechos_elegidos.length > 1 ) {
			this.set_size_request ( 600, 200 );
			var treeview_hechos = new TreeViewHechos ();
			var scroll_hechos = new ScrolledWindow ( null, null );
			scroll_hechos.set_policy ( PolicyType.NEVER, PolicyType.AUTOMATIC );
			treeview_hechos.set_margin_bottom ( 10 );
			treeview_hechos.mostrar_hechos ( hechos_elegidos );
			scroll_hechos.set_size_request ( 100, 110 );
			scroll_hechos.add ( treeview_hechos );;
			this.grid.attach ( scroll_hechos, 1, 1, 1, 1 );
		}
		this.set_labels ( hechos_elegidos );

		for ( int i = 0; i < hechos_elegidos.length; i++ ) {
			this.hechos.append_val ( hechos_elegidos.index ( i ) );
		}

		this.show_all ();
	}

	private void set_labels ( Array<Hecho> hechos_elegidos ) {
		if ( hechos_elegidos.length == 1 ) {
			this.set_title ( _("Remove Fact") );
			Label hecho_de = new Label.with_mnemonic ( _("dated") + ":" );
			Label hecho_fecha = new Label.with_mnemonic ( "" );
			Label hecho_nombre = new Label.with_mnemonic ( "" );
			hecho_nombre.set_line_wrap_mode ( Pango.WrapMode.WORD );
			hecho_nombre.set_line_wrap ( true );
			hecho.set_label ( _("Fact") + ":" );
			this.pregunta.set_markup ( "<big>" + _("Do you want to remove this fact?") + "</big>" );
			hecho_nombre.set_markup ( "<span font_weight=\"heavy\">"+ hechos_elegidos.index (0).nombre +"</span>");
			hecho_fecha.set_markup ( "<span font_weight=\"heavy\">"+ hechos_elegidos.index (0).fecha_to_string() +"</span>");

			grid.attach ( hecho_nombre, 1, 1, 1, 1 );
			grid.attach ( hecho_de, 0, 2, 1, 1 );
			grid.attach ( hecho_fecha, 1, 2, 1, 1 );
		} else {
			this.set_title ( _("Remove Facts") );
			this.pregunta.set_markup ( "<big>" + _("Do you want to remove this facts?") + "</big>" );
			this.hecho.set_label ( _("Facts") + ":" );
		}
	}
}
