/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2012 Andres Fernandez <andres@softwareperonista.com.ar>
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

public class Nomeolvides.MainToolbar : Gtk.Toolbar
{
	public NmToolButton add_button { get; private set; }
	public NmToolButton undo_button { get; private set; }
	public NmToolButton redo_button { get; private set; }
	public NmToolButton edit_button { get; private set; }
	public NmToolButton delete_button { get; private set; }
	public NmToolButton send_button { get; private set; }
	public NmToolButton list_button { get; private set; }
	public ToolItem anio_item { get; private set; }
	public Label label { get; private set; }
	
	public MainToolbar ()
	{
		this.get_style_context().add_class (STYLE_CLASS_TOOLBAR);
		
		this.add_button = new NmToolButton ( _("Add") );
		this.undo_button = new NmToolButton ( _("Undo") );
		this.redo_button = new NmToolButton ( _("Redo") );
		this.edit_button = new NmToolButton ( _("Edit") );
		this.delete_button = new NmToolButton ( _("Delete") );
		this.send_button = new NmToolButton ( _("Send") );
		this.list_button = new NmToolButton ( _("List") );
		this.anio_item = new ToolItem ();

		this.label = new Label ("");
		
		this.undo_button.set_sensitive ( false );
		this.redo_button.set_sensitive ( false );
		this.edit_button.set_visible_horizontal ( false );
		this.delete_button.set_visible_horizontal ( false );
		this.send_button.set_visible_horizontal ( false );
		this.list_button.set_visible_horizontal ( false );
		this.list_button_set_agregar ();


		var separador = new SeparatorToolItem ();
		var expansor = new SeparatorToolItem ();
		separador.set_expand ( true );
		separador.draw = false;
		expansor.set_expand ( true );
		expansor.draw = false;
		
		this.anio_item.add ( this.label );

		this.add ( this.add_button );
		this.add ( this.undo_button );
		this.add ( this.redo_button );
		this.add ( separador );
		this.add ( this.edit_button );
		this.add ( this.delete_button );
		this.add ( this.send_button );
		this.add ( this.list_button );
		this.add ( expansor );
		this.add ( this.anio_item );
	}

	public void set_buttons_visible ( Hecho hecho ) {

		this.list_button.set_visible_horizontal ( true );
			this.edit_button.set_visible_horizontal ( true );
			this.delete_button.set_visible_horizontal ( true );
			this.send_button.set_visible_horizontal ( true );
	}

	public void set_buttons_invisible () {

		this.send_button.set_visible_horizontal ( false );
		this.edit_button.set_visible_horizontal ( false );
		this.delete_button.set_visible_horizontal ( false );
		this.list_button.set_visible_horizontal ( false );
	}

	public void set_label_anio ( string anio = "0" )
	{
		if ( anio != "0") {
			this.label.set_markup ( "<span font_size=\"x-large\" font_weight=\"heavy\"> " + _("Year") + ": " + anio + "</span>" );
		} else {
			this.label.set_text ( "" );
		}
	}

	public void set_label_lista ( string lista = "" )
	{
		if ( lista != "") {
			this.label.set_markup ( "<span font_size=\"x-large\" font_weight=\"heavy\">" + lista + "</span>" );
		} else {
			this.label.set_text ( "" );
		}
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

	public void list_button_set_agregar ( ) {
		this.list_button.set_label (_("Add to list"));
	}

	public void list_button_set_quitar ( ) {
		this.list_button.set_label (_("Remove from list"));
	}
}
