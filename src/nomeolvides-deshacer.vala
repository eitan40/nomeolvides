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
using Gee;
using Nomeolvides;

public class Nomeolvides.Deshacer : Object {
	private LinkedList<DeshacerItem> lista_deshacer;
	private LinkedList<DeshacerItem> lista_rehacer;

	public Deshacer () {
		this.lista_deshacer = new LinkedList<DeshacerItem> ();
		this.lista_rehacer = new LinkedList<DeshacerItem> ();
	}

	public void guardar_borrado ( Hecho borrar, DeshacerTipo tipo ) {		
		this.lista_deshacer.offer_head ( new DeshacerItem ( borrar, tipo) );
		this.deshacer_con_items ();
	}

	public void guardar_rehacer ( DeshacerItem rehacer ) {		
		if ( rehacer.get_tipo () == DeshacerTipo.BORRAR ) {
			this.lista_rehacer.offer_head ( new DeshacerItem ( rehacer.get_borrado(), rehacer.get_tipo() ) );
		} else {
			this.lista_rehacer.offer_head ( new DeshacerItem ( rehacer.get_editado(), rehacer.get_tipo() ) );
			this.lista_rehacer.peek_head ().set_editado ( rehacer.get_borrado () );
		}
		this.rehacer_con_items ();
	}

	public void guardar_editado ( Hecho editado ) {
		this.lista_deshacer.peek_head ().set_editado ( editado );
	//	this.con_items ();
	}

	public bool deshacer ( out DeshacerItem item ) {
		bool retorno = false;
		item = null;
		
		if ( !(this.lista_deshacer.is_empty) ) {
			item = this.lista_deshacer.poll_head ();
			if ( this.lista_deshacer.is_empty) {
				this.deshacer_sin_items ();
			}
			this.guardar_rehacer ( item );
			retorno = true;
		} else {
			this.deshacer_sin_items ();
		}
		return retorno;
	}

	public bool rehacer ( out DeshacerItem item ) {
		bool retorno = false;
		item = null;
		
		if ( !(this.lista_rehacer.is_empty) ) {
			item = this.lista_rehacer.poll_head ();
			if ( this.lista_rehacer.is_empty) {
				this.rehacer_sin_items ();
			}
			
			if ( item.get_tipo () == DeshacerTipo.EDITAR ) {
				this.guardar_borrado ( item.get_editado (), item.get_tipo ());
				this.guardar_editado ( item.get_borrado ());
			} else {
				this.guardar_borrado ( item.get_borrado (), item.get_tipo ());
			}
			retorno = true;
		} else {
			this.rehacer_sin_items ();
		}
		return retorno;
	}

	public signal void deshacer_sin_items ();
	public signal void deshacer_con_items ();
	public signal void rehacer_sin_items ();
	public signal void rehacer_con_items ();
}

public enum Nomeolvides.DeshacerTipo {
	BORRAR,
	EDITAR;
}
