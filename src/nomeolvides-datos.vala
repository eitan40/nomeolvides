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
using Gee;
using GLib;
using Nomeolvides;

public class Nomeolvides.Datos : GLib.Object {
	private ArrayList<ListStoreHechos> hechos_anios;
	private ArrayList<string> cache_hechos_anios;

	public Datos () {
		this.cache_hechos_anios = new ArrayList<string> ();
		this.hechos_anios = new ArrayList<ListStoreHechos> ();
	}

	public void agregar_hecho (Hecho nuevo) {
		if ( this.cache_hechos_anios.contains ( nuevo.fecha.get_year().to_string() )) {
			this.hechos_anios[en_liststore (nuevo.fecha.get_year().to_string())].agregar (nuevo);
		} else {
			agregar_liststore ( nuevo.fecha.get_year().to_string() );
			this.hechos_anios[en_liststore (nuevo.fecha.get_year().to_string())].agregar (nuevo);
		}
		this.mostrar_anio ( nuevo.fecha.get_year().to_string() );		
	}

	public void eliminar_hecho ( Hecho a_eliminar ) {
		TreePath path;
		TreeViewColumn columna;
		TreeIter iterador;
		int anio = en_liststore (a_eliminar.fecha.get_year().to_string());

		
		this.get_cursor(out path, out columna);
		this.anio_mostrado_ahora.get_iter(out iterador, path);
		this.hechos_anios[anio].eliminar ( iterador, a_eliminar );

		if (this.hechos_anios[anio].length () == 0) {
			this.eliminar_liststore (anio);
		}		
	}

	private void agregar_liststore (string nuevo_anio) {
		this.hechos_anios.add ( new ListStoreHechos( nuevo_anio) );
		this.cache_hechos_anios.add (nuevo_anio);
	}

	private void eliminar_liststore (int a_eliminar) {
		
		this.hechos_anios.remove (this.hechos_anios[a_eliminar]);
		this.cache_hechos_anios.remove(this.cache_hechos_anios[a_eliminar]);
	}

	private int en_liststore (string anio) {

		int retorno;

		retorno = this.cache_hechos_anios.index_of( anio ); 

		return retorno;
	}

	public void borrar_datos () {
		this.hechos_anios.clear ();
		this.cache_hechos_anios.clear ();
	}

	public ArrayList<Hecho> lista_de_hechos () { 
        ArrayList<Hecho> hechos = new ArrayList<Hecho>();
		Value hecho;
		TreeIter iter;
		int i;


		for (i=0; i < this.cache_hechos_anios.size; i++ ) {
			this.hechos_anios[i].get_iter_first(out iter);
			do {
				this.hechos_anios[i].get_value(iter, 3, out hecho);
				hechos.add ((Hecho) hecho);
			}while (this.hechos_anios[i].iter_next(ref iter));
		}
		
		return hechos;
    }

	public string[] lista_de_anios ()
	{
		string[] retorno = {};
		int i;

		for (i=0; i < this.cache_hechos_anios.size; i++ ) {
			retorno += this.cache_hechos_anios[i];
		}		
		
		return retorno;
	}
}
