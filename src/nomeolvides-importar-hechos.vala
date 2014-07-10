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

public class Nomeolvides.ImportarHechos : Dialog {
	private ComboBox combo_colecciones;
	private Label archivo_label;
	private string directorio;
	private string archivo;
	
	public ImportarHechos ( string directorio_actual, ListStoreColecciones colecciones_liststore ) {
		this.title = _("Import Facts From File");
		this.directorio = directorio_actual;
		this.set_default_size ( 450, 200 );

		this.add_button ( _("Cancel"), ResponseType.CANCEL );
		this.add_button ( _("Import"), ResponseType.ACCEPT );
		
		var coleccion = new Coleccion ( _("Select Colection"), true );

		colecciones_liststore.agregar_al_inicio ( coleccion , 0 );

		var boton_elegir_archivo = new Button ();
		boton_elegir_archivo.set_label (_("Choose File"));
		boton_elegir_archivo.clicked.connect ( this.elegir_archivo );

		var coleccion_label = new Label.with_mnemonic ( _("Colection") );
		this.archivo_label = new Label.with_mnemonic ( _("File") );
		coleccion_label.set_halign ( Align.START );
		this.archivo_label.set_halign ( Align.START );

		this.combo_colecciones = new ComboBox ();
		this.set_combo_box ( colecciones_liststore );
		this.combo_colecciones.changed.connect ( this.set_sensitive_import );

		var grid = new Grid ();
		grid.set_column_spacing ( (uint)40 );
		grid.set_row_spacing ( (uint)10 );
		grid.set_border_width ( (uint)20 );
		grid.set_valign ( Align.CENTER );
		grid.set_halign ( Align.CENTER );

		grid.attach ( archivo_label, 0 , 0 , 1, 1 );
		grid.attach ( boton_elegir_archivo, 1, 0, 1, 1 );
		grid.attach ( coleccion_label, 0, 1, 1, 1 );
		grid.attach ( this.combo_colecciones, 1, 1, 1, 1 );

		var contenido = this.get_content_area() as Box;
		contenido.pack_start(grid, false, true, 0);

		this.show_all ();
	}

	private void elegir_archivo () {
		var abrir_archivo = new FileChooserDialog ( _("Select a file"), null,
		                                            FileChooserAction.OPEN, _("Cancel"),
		                                            Gtk.ResponseType.CANCEL, _("Open"), 
		                                            ResponseType.ACCEPT	);
		abrir_archivo.set_current_folder ( this.directorio );

		if (abrir_archivo.run () == ResponseType.ACCEPT) {
			this.archivo = abrir_archivo.get_filename ();
			this.archivo_label.set_label ( this.archivo.slice ( this.archivo.last_index_of ( "/" ) + 1, this.archivo.length ));
		}
		abrir_archivo.destroy ();
	}

	public void set_combo_box ( ListStoreColecciones liststore) {
		CellRendererText renderer = new CellRendererText ();
		this.combo_colecciones.pack_start (renderer, true);
		this.combo_colecciones.add_attribute (renderer, "text", 0);
		this.combo_colecciones.active = 0;
		this.combo_colecciones.set_model ( liststore );
		this.set_sensitive_import ();
	}

	public int64 get_coleccion () {
		TreeIter iter;
		Value value_coleccion;
		Coleccion coleccion;

		this.combo_colecciones.get_active_iter( out iter );
		ListStoreColecciones liststore = this.combo_colecciones.get_model () as ListStoreColecciones;
		liststore.get_value ( iter, 2, out value_coleccion );
		coleccion = value_coleccion as Coleccion;

		return coleccion.id;
	}

	private void set_sensitive_import () {
		if ( this.combo_colecciones.active == 0 || this.archivo_label.get_text () == _("File") ) {
			this.get_widget_for_response ( ResponseType.ACCEPT ).set_sensitive ( false );
		} else {
			this.get_widget_for_response ( ResponseType.ACCEPT ).set_sensitive ( true );
		}
	}

	public int64 get_coleccion_id () {
		return this.get_coleccion ();
	}

	public string get_filename () {
		return this.archivo;
	}
}
