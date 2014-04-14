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
	protected Array<Etiqueta> etiquetas;
	protected Button boton_etiqueta;
	public Hecho respuesta { get; protected set; }
	
	public DialogHecho (VentanaPrincipal ventana, ListStoreColecciones colecciones_liststore, ListStoreEtiquetas etiquetas_liststore) {
		this.resizable = true;
		this.modal = true;
		this.set_default_size (600,400);
		this.set_size_request (400,250);
		this.set_transient_for ( ventana as Window );

		this.add_button ( _("Cancel") , ResponseType.CLOSE);

		var nombre_label = new Label.with_mnemonic (_("Name") + ": ");
		var fecha_label = new Label.with_mnemonic (_("Date") + ": ");
		var coleccion_label = new Label.with_mnemonic (_("Colection") + ": ");
		var fuente_label = new Label.with_mnemonic (_("Source") + ": ");
		var etiquetas_label = new Label.with_mnemonic (_("Tags") + ": ");

		nombre_label.set_halign ( Align.END );
		fecha_label.set_halign ( Align.END );
		coleccion_label.set_halign ( Align.END );
		fuente_label.set_halign ( Align.END );
		etiquetas_label.set_halign ( Align.END );
#if DISABLE_GNOME3
		nombre_label.set_margin_left ( 15 );
		fecha_label.set_margin_left ( 15 );
		coleccion_label.set_margin_left ( 15 );
		fuente_label.set_margin_left ( 15 );
		etiquetas_label.set_margin_right ( 15 );
#else
		nombre_label.set_margin_end ( 15 );
		fecha_label.set_margin_end ( 15 );
		coleccion_label.set_margin_end ( 15 );
		fuente_label.set_margin_end ( 15 );
		etiquetas_label.set_margin_end ( 15 );
#endif

		this.nombre_entry = new Entry ();
		this.fuente_entry = new Entry ();
		this.etiquetas_entry = new Entry ();

		this.etiquetas_completion = new EntryCompletion ();
		this.etiquetas_completion.set_model ( etiquetas_liststore );
		this.etiquetas_completion.set_text_column ( 0 );
		this.etiquetas_entry.set_completion ( this.etiquetas_completion );
		
		this.combo_colecciones = new ComboBox ();
		this.fecha = new SelectorFecha ();
		this.etiquetas = new Array<Etiqueta> ();
		this.boton_etiqueta = new Button.with_label (_("Add tag"));

		var descripcion_frame = new Frame( _("Description") );
		descripcion_frame.set_shadow_type(ShadowType.ETCHED_IN);
		this.descripcion_scroll = new ScrolledWindow ( null, null );
		this.descripcion_scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		this.descripcion_textview = new TextView ();
		this.descripcion_textview.set_wrap_mode (WrapMode.WORD);
		
		this.descripcion_scroll.add_with_viewport ( this.descripcion_textview );
		descripcion_frame.add ( this.descripcion_scroll );

		this.set_combo_box ( colecciones_liststore );
		this.boton_etiqueta.clicked.connect ( this.agregar_etiqueta );
		
		Box box_hecho = new Box (Orientation.HORIZONTAL, 0);
		Box box_labels = new Box (Orientation.VERTICAL, 0);
		Box box_widgets = new Box (Orientation.VERTICAL, 0);

		box_labels.pack_start ( nombre_label, false, false, 5 );		
		box_labels.pack_start ( fecha_label, false, false, 5 );
		box_labels.pack_start ( coleccion_label, false, false, 5 );
		box_labels.pack_start ( fuente_label, false, false, 5 );
		box_labels.pack_start ( etiquetas_label, false, false, 5 );
		box_widgets.pack_start ( nombre_entry, false, false, 0 );
		box_widgets.pack_start ( fecha, false, false, 0 );
		box_widgets.pack_start ( combo_colecciones, false, false, 0 );
		box_widgets.pack_start ( fuente_entry, false, false, 0 );
		box_widgets.pack_start ( etiquetas_entry, false, false, 0 );
		box_widgets.pack_start ( boton_etiqueta, false, false, 0 );
		
		box_hecho.pack_start (box_labels, true, false, 0);
		box_hecho.pack_start (box_widgets, true, true, 0);
	
		var contenido = this.get_content_area() as Box;

		contenido.pack_start(box_hecho, false, false, 0);
		contenido.pack_start(descripcion_frame, true, true, 0);
		
		this.show_all ();
	}

	protected void crear_respuesta() {
		if(this.nombre_entry.get_text_length () > 0)
		{
			this.respuesta  = new Hecho ( Utiles.sacarCaracterEspecial ( this.nombre_entry.get_text () ),
										  Utiles.sacarCaracterEspecial ( this.descripcion_textview.buffer.text ),
										  this.fecha.get_anio (),
										  this.fecha.get_mes (),
										  this.fecha.get_dia (),
										  this.get_coleccion (),
										  Utiles.sacarCaracterEspecial ( this.fuente_entry.get_text () ) );
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
		var etiqueta = new Etiqueta ( nombre );

		if ( liststore_etiquetas.contiene_nombre ( nombre )) {} else {
			var db = new AccionesDB ( Configuracion.base_de_datos() );
			db.insert_etiqueta ( etiqueta );
		}

		this.etiquetas.append_val ( etiqueta );
		this.etiquetas_entry.set_text ( "" );
	}
}
