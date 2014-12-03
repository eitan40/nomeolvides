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

public class Nomeolvides.ListasPreferencias: Nomeolvides.PanelConfiguracion {
	public ListasPreferencias ( ListStoreListas liststore_listas ) {
		this.treeview = new TreeViewListas ();
		this.treeview.set_border_width ( 20 );
		this.treeview.set_model ( liststore_listas );
		this.scroll_view.add ( this.treeview );
		this.pack_start ( scroll_view, true, true, 0 );

		this.conectar_signals ();

		this.agregar_dialog = new DialogListaAgregar () as DialogNmoBase;
		this.editar_dialog = new DialogListaEditar () as DialogNmoBase;
		this.borrar_dialog = new DialogListaBorrar () as DialogNmoBaseBorrar;
	}

	protected override bool agregar ( Base objeto ) {
		ListStoreListas liststore;
		if ( this.db.insert_lista ( objeto as Lista ) ) {
			objeto.id = this.db.ultimo_rowid();
			liststore = this.treeview.get_model () as ListStoreListas;
			liststore.agregar (objeto as Lista, 0);
			this.cambio_listas_signal ();
			return true;
		} else {
			return false;
		}
	}

	protected override bool actualizar ( Base objeto_viejo, Base objeto_nuevo ) {
		if ( this.db.update_lista ( objeto_nuevo as Lista ) ) {
			var liststore = this.treeview.get_model () as ListStoreListas;
			this.treeview.eliminar ( objeto_viejo );
			liststore.agregar ( objeto_nuevo as Lista, this.treeview.get_cantidad_hechos () );
			this.cambio_listas_signal ();
			return true;
		} else {
			return false;
		}
	}

	public override void borrar ( Base objeto ) {
		this.db.lista_a_borrar ( objeto as Lista );
		this.deshacer.guardar_borrado ( objeto, DeshacerTipo.BORRAR );
		this.deshacer.borrar_rehacer ();
		this.treeview.eliminar( objeto );
		this.cambio_listas_signal ();
	}

	protected override void efectuar_deshacer ( Base objeto ) {
		this.db.lista_no_borrar ( objeto as Lista );
		var liststore = this.treeview.get_model () as ListStoreListas;
		var cantidad_hechos = this.db.count_hechos_lista ( objeto as Lista );
		liststore.agregar ( objeto as Lista, cantidad_hechos );
	}

	protected override void efectuar_rehacer ( Base objeto ) {
		this.db.lista_a_borrar ( objeto as Lista );
		this.treeview.eliminar ( objeto as Lista );
	}

	public void actualizar_liststore () {
		var liststore = new ListStoreListas ();
		var listas = this.db.select_listas ();

		for ( int i=0; i < listas.length; i++ ) {
			var lista = listas.index (i);
			var cantidad_hechos = this.db.count_hechos_lista ( lista );
			liststore.agregar ( lista, cantidad_hechos );			
		}

		this.treeview.set_model ( liststore );
	}

	public signal void cambio_listas_signal ();
}

