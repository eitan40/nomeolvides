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

[GtkTemplate (ui = "/org/gnome/nomeolvides/borrar-lista-dialog.ui")]
public class Nomeolvides.BorrarListaDialogo : Dialog {
	
	[GtkChild]
	private Label label_pregunta;
	
	[GtkChild]
	private Label label_lista_nombre;
	
	[GtkChild]
	private Label label_lista_cantidad_hechos;
	
	public BorrarListaDialogo ( Lista lista_a_borrar ) {

		this.label_pregunta.set_markup ( "<big>¿Est seguro que desea borrar la siguiente lista personalizada?</big>" );
		this.label_lista_nombre.set_markup ( "<span font_weight=\"heavy\">"+ lista_a_borrar.nombre +"</span>");
		this.label_lista_cantidad_hechos.set_markup ( "contiene <span font_style=\"italic\">"+ lista_a_borrar.cantidad_hechos.to_string() +"</span> hecho");

		this.show_all ();
	}
}
