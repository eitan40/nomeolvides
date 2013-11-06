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

public class Nomeolvides.Deshacer<G> : Object {
	private Array<DeshacerItem<G>> lista_deshacer;
	private Array<DeshacerItem<G>> lista_rehacer;

	public Deshacer () {
		this.lista_deshacer = new Array<DeshacerItem<G>> ();
		this.lista_rehacer = new Array<DeshacerItem<G>> ();
	}

	public void guardar_borrado ( G borrar, DeshacerTipo tipo ) {		
		this.lista_deshacer.append_val ( new DeshacerItem<G> ( borrar, tipo) );
		this.deshacer_con_items ();
	}

	public void guardar_rehacer ( DeshacerItem<G> rehacer ) {		
		if ( rehacer.get_tipo () == DeshacerTipo.BORRAR ) {
			this.lista_rehacer.append_val ( new DeshacerItem<G> ( rehacer.get_borrado(), rehacer.get_tipo() ) );
		} else {
			var deshacer = new DeshacerItem<G> ( rehacer.get_editado(), rehacer.get_tipo() );
			deshacer.set_editado ( rehacer.get_borrado () );
			this.lista_rehacer.append_val ( deshacer );
		}
		this.rehacer_con_items ();
	}

	public void guardar_editado ( G editado ) {
		this.lista_deshacer.index ( this.lista_deshacer.length -1 ).set_editado ( editado );
	}

	public bool deshacer ( out DeshacerItem<G> item ) {
		bool retorno = false;
		item = null;
		
		if ( !(this.lista_deshacer.length == 0) ) {
			item = this.lista_deshacer.index ( this.lista_deshacer.length -1 );
			this.lista_deshacer.remove_index ( this.lista_deshacer.length -1 );
			if ( this.lista_deshacer.length == 0 ) {
				this.deshacer_sin_items ();
			}
			this.guardar_rehacer ( item );
			retorno = true;
		} else {
			this.deshacer_sin_items ();
		}
		return retorno;
	}

	public bool rehacer ( out DeshacerItem<G> item ) {
		bool retorno = false;
		item = null;

		if ( !(this.lista_rehacer.length == 0) ) {
			item = this.lista_rehacer.index ( this.lista_rehacer.length -1 );
			this.lista_rehacer.remove_index ( this.lista_rehacer.length -1 );
			if ( this.lista_rehacer.length == 0 ) {
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

	public void borrar_rehacer () {
		this.lista_rehacer = new Array<DeshacerItem<G>> ();;
		this.rehacer_sin_items ();
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
