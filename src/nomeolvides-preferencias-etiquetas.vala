/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2014 Andres Fernandez <andres@softwareperonista.com.ar>
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

public class Nomeolvides.PreferenciasEtiquetas: Nomeolvides.PreferenciasBase {
	public PreferenciasEtiquetas ( ListStoreEtiquetas liststore ) {
		this.treeview = new TreeViewEtiquetas ();
		this.treeview.set_border_width ( 20 );
		this.treeview.set_model ( liststore );
		this.scroll_view.add ( this.treeview );
		this.pack_start ( scroll_view, true, true, 0 );

		this.conectar_signals ();

		this.agregar_dialog = new DialogEtiquetaAgregar () as DialogBase;
		this.editar_dialog = new DialogEtiquetaEditar () as DialogBase;
		this.borrar_dialog = new DialogEtiquetaBorrar () as DialogBaseBorrar;
	}

	protected override bool agregar ( Base objeto ) {
		ListStoreEtiquetas liststore;
		if ( this.db.insert_etiqueta ( objeto as Etiqueta ) ) {
			objeto.id = this.db.ultimo_rowid ();
			liststore = this.treeview.get_model () as ListStoreEtiquetas;
			liststore.agregar ( objeto as Etiqueta, 0);
			this.cambio_etiquetas_signal ();
			return true;
		} else {
			return false;
		}
	}

	protected override bool actualizar ( Base objeto_viejo, Base objeto_nuevo ) {
		if ( this.db.update_etiqueta ( objeto_nuevo as Etiqueta ) ) {
			var liststore = this.treeview.get_model () as ListStoreEtiquetas;
			liststore.agregar ( objeto_nuevo as Etiqueta, this.treeview.get_cantidad_hechos () );
			this.treeview.eliminar ( objeto_viejo );
			this.cambio_etiquetas_signal ();
			return true;
		} else {
			return false;
		}
	}

	public override void borrar ( Base objeto ) {
		this.db.etiqueta_a_borrar ( objeto as Etiqueta );
		this.deshacer.guardar_borrado ( objeto, DeshacerTipo.BORRAR );
		this.deshacer.borrar_rehacer ();
		this.treeview.eliminar( objeto );
		this.cambio_etiquetas_signal ();
	}

	protected override void efectuar_deshacer ( Base objeto ) {
		this.db.etiqueta_no_borrar ( objeto as Etiqueta );
		var liststore = this.treeview.get_model () as ListStoreEtiquetas;
		var cantidad_hechos = this.db.count_hechos_etiqueta ( objeto as Etiqueta );
		liststore.agregar ( objeto as Etiqueta, cantidad_hechos );
	}

	protected override void efectuar_rehacer ( Base objeto ) {
		this.db.etiqueta_a_borrar ( objeto as Etiqueta );
		this.treeview.eliminar ( objeto as Etiqueta );
	}

	public void actualizar_liststore () {
		var liststore = new ListStoreEtiquetas ();
		var etiquetas = this.db.select_etiquetas ();

		for ( int i=0; i < etiquetas.length; i++ ) {
			var etiqueta = etiquetas.index (i);
			var cantidad_hechos = this.db.count_hechos_etiqueta ( etiqueta );
			liststore.agregar ( etiqueta, cantidad_hechos );
		}

		this.treeview.set_model ( liststore );
	}

	public signal void cambio_etiquetas_signal ();
}
