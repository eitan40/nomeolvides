/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * nomeolvides-importar-hechos.vala
 * Copyright (C) 2013 Fernando Fernandez <fernando@softwareperonista.com.ar>
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

public class Nomeolvides.ImportarHechos : OpenFileDialog {

	private ComboBox combo_colecciones;

	// Constructor
		public ImportarHechos ( string directorio_actual, ListStoreColecciones colecciones_liststore ) {

			base ( directorio_actual );
			this.set_modal ( true );
			this.title = _("Import Facts From File");

			this.boton_abrir.set_sensitive ( false );

			var coleccion = new Coleccion ( _("Select Colection"), true );

			colecciones_liststore.agregar_coleccion ( coleccion , 0, AgregarModo.PREPEND );

			var coleccion_label = new Label.with_mnemonic ( "" );
			coleccion_label.set_markup ( _("Import to") );

			this.combo_colecciones = new ComboBox ();
			this.set_combo_box ( colecciones_liststore );
			this.combo_colecciones.changed.connect ( cambio_coleccion );

			var grid = new Grid ();
			grid.set_column_spacing ( (uint)10 );
			grid.set_row_spacing ( (uint)10 );
			grid.set_border_width ( (uint)20 );

			grid.attach (coleccion_label,0,1,1,1);
			grid.attach (this.combo_colecciones,1,1,2,1);

			var contenido = this.get_content_area() as Box;
			contenido.pack_start(grid, false, true, 0);

			this.show_all ();

	}

	protected void set_combo_box ( ListStoreColecciones liststore) {
		CellRendererText renderer = new CellRendererText ();
		this.combo_colecciones.pack_start (renderer, true);
		this.combo_colecciones.add_attribute (renderer, "text", 0);
		this.combo_colecciones.active = 0;
		this.combo_colecciones.set_model ( liststore );
	}

	protected int64 get_coleccion () {
		TreeIter iter;
		Value value_coleccion_id;

		this.combo_colecciones.get_active_iter( out iter );
		ListStoreColecciones liststore = this.combo_colecciones.get_model () as ListStoreColecciones;
		liststore.get_value ( iter, 3, out value_coleccion_id );

		return (int64) value_coleccion_id;
	}

	public void cambio_coleccion () {
		if (this.combo_colecciones.active == 0 ) {
			this.boton_abrir.set_sensitive ( false );
		} else {
			this.boton_abrir.set_sensitive ( true );
		}
	}

	public int64 get_coleccion_id () {
		return this.get_coleccion ();
	}
}

