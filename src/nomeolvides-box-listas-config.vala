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
 *   bullit - 39 escalones - silent love (japonesa) 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.ListasConfig: Gtk.Box {
	public TreeViewListas listas_view { get; private set; }
	private ToolButton aniadir_lista_button;
	private ToolButton editar_lista_button;
	private ToolButton borrar_lista_button;
	public bool cambios { get; private set; }
	public Button boton_aniadir;
	private AccionesDB db;
		
	public ListasConfig ( ListStoreListas liststore_lista ) {
		this.db = new AccionesDB ( Configuracion.base_de_datos() );
		this.set_orientation ( Orientation.VERTICAL );

		Toolbar toolbar = new Toolbar ();
		this.aniadir_lista_button = new ToolButton ( null, _("Add") );
		this.editar_lista_button = new ToolButton ( null, _("Edit") );
		this.borrar_lista_button = new ToolButton ( null, _("Delete") );
		aniadir_lista_button.is_important = true;
		editar_lista_button.is_important = true;
		borrar_lista_button.is_important = true;
		editar_lista_button.set_visible_horizontal ( false );
		borrar_lista_button.set_visible_horizontal ( false );
		SeparatorToolItem separador = new SeparatorToolItem ();
		separador.set_expand ( true );
		separador.draw = false;

		editar_lista_button.clicked.connect ( edit_lista_dialog );
		borrar_lista_button.clicked.connect ( borrar_lista_dialog );
		aniadir_lista_button.clicked.connect ( add_lista_dialog );

		toolbar.add ( aniadir_lista_button );
		toolbar.add ( separador );
		toolbar.add ( editar_lista_button );
		toolbar.add ( borrar_lista_button );

		this.cambios = false;
		this.listas_view = new TreeViewListas ();
		this.listas_view.set_model ( liststore_lista );
		this.listas_view.cursor_changed.connect ( elegir_lista );

		var scroll_listas_view = new ScrolledWindow (null,null);
		scroll_listas_view.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		scroll_listas_view.add ( this.listas_view );
 
		this.add ( toolbar );
		this.pack_start ( scroll_listas_view, true, true, 0);
		this.show_all ();
	}

	private void add_lista_dialog () {
		ListStoreListas liststore;
		Lista lista;
		
		var add_dialog = new AddListaDialog ( );
		add_dialog.show_all ();

		if (add_dialog.run() == ResponseType.APPLY) {
			lista = add_dialog.respuesta;
			this.db.insert_lista ( lista );
			lista.id = this.db.ultimo_rowid();
			liststore = this.listas_view.get_model () as ListStoreListas;
			liststore.agregar_lista ( lista, 0 );
			this.cambios = true;
		}
		
		add_dialog.destroy ();
	}

	private void edit_lista_dialog () {
		ListStoreListas liststore;
		var lista = this.listas_view.get_lista_cursor ();
		
		var edit_dialog = new EditListaDialog ();
		edit_dialog.set_datos ( lista );
		edit_dialog.show_all ();

		if (edit_dialog.run() == ResponseType.APPLY) {
			liststore = this.listas_view.get_model () as ListStoreListas;
			var cantidad_hechos = this.listas_view.get_hechos_lista ();
			this.listas_view.eliminar_lista ( lista );
			liststore.agregar_lista (edit_dialog.respuesta, cantidad_hechos);
			this.db.update_lista ( edit_dialog.respuesta );
			this.cambios = true;
		}	
		edit_dialog.destroy ();
	}

	private void borrar_lista_dialog () {
		var borrar_dialog = new BorrarListaDialogo ( this.listas_view.get_lista_cursor (),
		                                             this.listas_view.get_hechos_lista () );
		borrar_dialog.show_all ();

		if (borrar_dialog.run() == ResponseType.APPLY) {
			this.db.delete_lista ( this.listas_view.get_lista_cursor () );
			this.listas_view.eliminar_lista ( this.listas_view.get_lista_cursor () );
		}
		borrar_dialog.destroy ();

		this.cambios = true;
	}

	private void set_buttons_visible ( bool cambiar ) {
		this.editar_lista_button.set_visible_horizontal ( cambiar );
		this.borrar_lista_button.set_visible_horizontal ( cambiar );
	}

	private void elegir_lista () {
		if(this.listas_view.get_lista_cursor () != null) {
			this.set_buttons_visible ( true );
		} else {
			this.set_buttons_visible ( false );		
		}
	}
}
