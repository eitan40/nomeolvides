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

public class Nomeolvides.DialogHechoListaAgregar : Dialog {
	private ComboBox listas;
	private ListStoreListas liststore;
	public Array<Hecho> hechos;
	private int64 id_lista;
	private Grid grid;
	
	public DialogHechoListaAgregar ( VentanaPrincipal ventana ) {
#if DISABLE_GNOME3
#else
		Object (use_header_bar: 1);
#endif
		this.set_default_size ( 450, 200 );
		this.set_transient_for ( ventana as Window );
		
		this.response.connect(on_response);

		this.listas = new ComboBox ();
		this.hechos = new Array<Hecho> ();

		this.grid = new Grid ( );
		grid.set_row_spacing ( 15 );
		grid.set_column_spacing ( 20 );
	#if DISABLE_GNOME3
		grid.set_margin_right ( 30 );
		grid.set_margin_left ( 30 );
	#else
		grid.set_margin_end ( 30 );
		grid.set_margin_start ( 30 );
	#endif
		grid.set_margin_top ( 15 );
		grid.set_margin_bottom ( 15 );
		grid.set_valign ( Align.CENTER );
		grid.set_halign ( Align.CENTER );

		var label_pregunta = new Label (_("Add") + ":");
		var label_listas = new Label ( _("to list") );
		this.set_title (_("Add Fact to List"));
		
		grid.attach ( label_pregunta, 0, 0, 1, 1 );
		grid.attach ( label_listas, 0, 1, 1, 1 );
		grid.attach ( this.listas, 1, 1, 1, 1 );

		var contenido = this.get_content_area () as Box;
		contenido.pack_start (grid, true, true, 0 );

		this.add_button ( _("Cancel"), ResponseType.CANCEL );
#if DISABLE_GNOME3
		this.add_button ( _("Add"), ResponseType.APPLY );
#else
		var boton = this.add_button ( _("Add"), ResponseType.APPLY );
		boton.get_style_context ().add_class ( "suggested-action" );
#endif

		this.show_all ();
	}

	public void setear_hechos ( Array<Hecho> hechos_elegidos ) {
		if ( hechos_elegidos.length == 1 ) {
			Label label_hecho = new Label ( "" );
			label_hecho.set_markup ( "<span font_weight=\"heavy\">"+ hechos_elegidos.index (0).nombre +"</span>");
			if ( label_hecho.get_text ().length > 50 ) {
				label_hecho.set_size_request ( 600, -1 );
				label_hecho.set_line_wrap_mode ( Pango.WrapMode.WORD );
				label_hecho.set_line_wrap ( true );
			}
		this.grid.attach ( label_hecho, 1, 0, 1, 1 );
		} else {
			this.title = _("Add Facts to List");
			this.set_size_request ( 600, 200 );
			var treeview_hechos = new TreeViewHechos ();
			var scroll_hechos = new ScrolledWindow ( null, null );
			scroll_hechos.set_policy ( PolicyType.NEVER, PolicyType.AUTOMATIC );
			treeview_hechos.set_margin_bottom ( 10 );
			treeview_hechos.mostrar_hechos ( hechos_elegidos );
			scroll_hechos.set_size_request ( 100, 110 );
			scroll_hechos.add ( treeview_hechos );
			this.grid.attach ( scroll_hechos, 1, 0, 1, 1 );
		}

		for ( int i = 0; i < hechos_elegidos.length; i++ ) {
			this.hechos.append_val ( hechos_elegidos.index ( i ) );
		}
		this.show_all ();
	}

	public void setear_listas ( ListStoreListas liststore) {
		CellRendererText renderer = new CellRendererText ();
		this.listas.pack_start (renderer, true);
		this.listas.add_attribute (renderer, "text", 0);
		this.listas.active = 0;
		this.liststore = liststore;
		this.listas.set_model ( liststore );
	}

	private void on_response (Dialog source, int response_id) {
        switch (response_id) {
    		case ResponseType.APPLY:
        		this.crear_respuesta ();
				break;
    		case ResponseType.CANCEL:
        		this.hide ();
        		break;
        }
    }

	private void crear_respuesta () {
		TreeIter iter;
		Value lista_elegida;
		Lista lista;

		this.listas.get_active_iter( out iter );
		this.liststore.get_value ( iter, 2, out lista_elegida );
		lista = lista_elegida as Lista;

		this.id_lista = lista.id;
	}

	public int64 get_id_lista () {
		return this.id_lista;
	}
}
