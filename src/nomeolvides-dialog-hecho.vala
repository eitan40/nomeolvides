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

public class Nomeolvides.DialogHecho : Dialog
{
	protected Entry nombre_entry;
	protected TextView descripcion_textview;
	protected ScrolledWindow descripcion_scroll;
	protected ComboBox combo_colecciones;
	protected SelectorFecha fecha;
	protected Entry fuente_entry;
	protected Entry etiquetas_entry;
	protected EntryCompletion etiquetas_completion;
	protected Button boton_etiqueta;
	protected Frame etiquetas_frame;
	protected Label etiquetas_label;
	protected Array<Etiqueta> etiquetas;
	protected Grid grid;
	public Hecho respuesta { get; protected set; }
	
	public DialogHecho (VentanaPrincipal ventana, ListStoreColecciones colecciones_liststore, ListStoreEtiquetas etiquetas_liststore) {
		this.resizable = true;
		this.modal = true;
		this.set_default_size (800,400);
		this.set_size_request (400,250);
		this.set_transient_for ( ventana as Window );

		this.add_button ( _("Cancel") , ResponseType.CLOSE);
		this.grid = new Grid ();
		this.grid.set_valign ( Align.CENTER );
		this.grid.set_halign ( Align.CENTER );
		this.etiquetas_frame = new Frame ( _("Tags") );

		var nombre_label = new Label.with_mnemonic (_("Name") + ": ");
		var fecha_label = new Label.with_mnemonic (_("Date") + ": ");
		var coleccion_label = new Label.with_mnemonic (_("Colection") + ": ");
		var fuente_label = new Label.with_mnemonic (_("Source") + ": ");

		nombre_label.set_halign ( Align.START );
		fecha_label.set_halign ( Align.START );
		coleccion_label.set_halign ( Align.START );
		fuente_label.set_halign ( Align.START );

		this.nombre_entry = new Entry ();
		this.fuente_entry = new Entry ();
		this.etiquetas_entry = new Entry ();
		this.etiquetas_entry.set_valign ( Align.START );

		this.etiquetas_completion = new EntryCompletion ();
		this.etiquetas_completion.set_model ( etiquetas_liststore );
		this.etiquetas_completion.set_text_column ( 0 );
		this.etiquetas_entry.set_completion ( this.etiquetas_completion );
		
		this.combo_colecciones = new ComboBox ();
		this.fecha = new SelectorFecha ();
		this.etiquetas = new Array<Etiqueta> ();
		this.boton_etiqueta = new Button.with_label (_("Add tag"));
		this.boton_etiqueta.set_valign ( Align.START );
		
		this.etiquetas_label = new Label.with_mnemonic ("");
		this.etiquetas_label.set_valign ( Align.FILL );
		this.etiquetas_label.set_vexpand ( true );
		this.etiquetas_label.set_size_request ( 50, 70 );
	#if DISABLE_GNOME3
		this.boton_etiqueta.set_margin_right ( 5 );
		this.etiquetas_label.set_margin_left ( 5 );
		this.etiquetas_entry.set_margin_left ( 5 );
		this.etiquetas_frame.set_margin_left ( 5 );
	#else
		this.boton_etiqueta.set_margin_end ( 5 );
		this.etiquetas_label.set_margin_start ( 5 );
		this.etiquetas_entry.set_margin_start ( 5 );
		this.etiquetas_frame.set_margin_start ( 5 );
	#endif 
		var etiquetas_grid = new Grid ();
		etiquetas_grid.set_valign ( Align.CENTER );
		etiquetas_grid.set_halign ( Align.CENTER );
		etiquetas_grid.attach ( etiquetas_entry, 0, 0, 1, 1 );
		etiquetas_grid.attach ( boton_etiqueta, 1, 0, 1, 1 );
		etiquetas_grid.attach ( etiquetas_label, 0, 1, 2, 1 );
		this.etiquetas_frame.add ( etiquetas_grid );

		var descripcion_frame = new Frame( _("Description") );
		descripcion_frame.set_shadow_type(ShadowType.ETCHED_IN);
		this.descripcion_scroll = new ScrolledWindow ( null, null );
		this.descripcion_scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		this.descripcion_textview = new TextView ();
		this.descripcion_textview.set_wrap_mode (WrapMode.WORD);
		
		this.descripcion_scroll.add_with_viewport ( this.descripcion_textview );
		descripcion_frame.add ( this.descripcion_scroll );
		descripcion_frame.set_size_request ( 300, 150 );

		this.set_combo_box ( colecciones_liststore );
		this.boton_etiqueta.clicked.connect ( this.agregar_etiqueta );
		
		grid.attach ( nombre_label, 0, 0, 1, 1 );
		grid.attach ( nombre_entry, 1, 0, 1, 1 );
		grid.attach ( fecha_label, 0, 1, 1, 1 );
		grid.attach ( fecha, 1, 1, 1, 1 );
		grid.attach ( coleccion_label, 0, 2, 1, 1 );
		grid.attach ( combo_colecciones, 1, 2, 1, 1 );
		grid.attach ( fuente_label, 0, 3, 1, 1 );
		grid.attach ( fuente_entry, 1, 3, 1, 1 );
		grid.attach ( etiquetas_frame, 2, 0, 1, 4 );
		grid.attach ( descripcion_frame, 0, 4, 3, 1 );
		
		var contenido = this.get_content_area() as Box;

		contenido.pack_start ( this.grid, true, true, 0 );
		
		this.show_all ();
	}

	protected void crear_respuesta() {
		if(this.nombre_entry.get_text_length () > 0) {
			this.respuesta  = new Hecho ( Utiles.sacarCaracterEspecial ( this.nombre_entry.get_text () ),
										  Utiles.sacarCaracterEspecial ( this.descripcion_textview.buffer.text ),
										  this.fecha.get_anio (),
										  this.fecha.get_mes (),
										  this.fecha.get_dia (),
										  this.get_coleccion (),
										  Utiles.sacarCaracterEspecial ( this.fuente_entry.get_text () ) );
			this.respuesta.set_etiquetas ( this.etiquetas );
		}
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
		Value value_coleccion;
		Coleccion coleccion;

		this.combo_colecciones.get_active_iter( out iter );
		ListStoreColecciones liststore = this.combo_colecciones.get_model () as ListStoreColecciones;
		liststore.get_value ( iter, 2, out value_coleccion );
		coleccion = value_coleccion as Coleccion;
		
		return coleccion.id;
	}

	protected void agregar_etiqueta () {
		var nombre = this.etiquetas_entry.get_text ();
		ListStoreEtiquetas liststore_etiquetas = this.etiquetas_completion.get_model () as ListStoreEtiquetas;
		Etiqueta etiqueta;

		if ( liststore_etiquetas.contiene_nombre ( nombre )) {
			etiqueta = liststore_etiquetas.get_elemento_por_nombre ( nombre ) as Etiqueta;
		} else {
			var db = new AccionesDB ( Configuracion.base_de_datos() );
			etiqueta = new Etiqueta ( nombre );
			db.insert_etiqueta ( etiqueta );
			etiqueta.id = db.ultimo_rowid ();
			this.dialogo_hecho_agregada_etiqueta ();
		}

		this.etiquetas.append_val ( etiqueta );
		this.mostrar_etiquetas_label ();
		this.etiquetas_entry.set_text ( "" );
	}

	private void mostrar_etiquetas_label ( ) {
		this.etiquetas_label.set_label ( "" );
		for ( int i = 0; i < this.etiquetas.length; i++ ) {
			if ( this.etiquetas_label.get_text () != "" ) {
				this.etiquetas_label.set_label ( this.etiquetas_label.get_text () + ", " + this.etiquetas.index ( i ).nombre );
			} else {
				this.etiquetas_label.set_label ( this.etiquetas.index ( i ).nombre );
			}
		}
	}

	public Array<Etiqueta> get_etiquetas_lista () {
		var lista_de_etiquetas = new Array<Etiqueta> ();
		for ( int i = 0; i < this.etiquetas.length; i++ ) {
				lista_de_etiquetas.append_val (this.etiquetas.index (i) );
			}
		return lista_de_etiquetas;
	}

	public signal void dialogo_hecho_agregada_etiqueta ();
}
