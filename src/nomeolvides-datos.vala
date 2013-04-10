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
	private ArrayList<ListStoreHechos> hechos_listas;
	private ArrayList<string> cache_hechos_listas;
	private ArrayList<int> cache_hechos_anios;
	public HechosFuentes fuentes;
	public Listas listas;

	public Datos () {
		this.cache_hechos_anios = new ArrayList<int> ();
		this.hechos_anios = new ArrayList<ListStoreHechos> ();
		this.cache_hechos_listas = new ArrayList<string> ();
		this.hechos_listas = new ArrayList<ListStoreHechos> ();
		this.fuentes = new HechosFuentes ();
		this.listas = new Listas ();
		this.cargar_fuentes_predefinidas ();
		this.cargar_datos_listas ();
	}

	public void agregar_hecho (Hecho nuevo) {
		int indice;
		if ( en_liststore ( nuevo.fecha.get_year(), out indice ) ) {
			this.hechos_anios[indice].agregar ( nuevo );
		} else {
			agregar_liststore ( nuevo.fecha.get_year() );
			if ( en_liststore ( nuevo.fecha.get_year(), out indice ) ) {
				this.hechos_anios[indice].agregar (nuevo);
				this.cambio_anios ();
			}
		}
	}

	private void inicializar_liststore_listas () {
		int i;
		ArrayList<string> hash_listas = this.listas.get_listas_hash ();

		for ( i=0; i < hash_listas.size; i++ ) {
			this.hechos_listas.add ( new ListStoreHechos () );
			print ("Lista hash : " + hash_listas[i] + "\n");
			this.cache_hechos_listas.add ( hash_listas[i] );
		}
		print ("Tamaño del arraylist de liststorehechos: " + this.hechos_listas.size.to_string () + "\n");

	}

	private void cargar_datos_listas () {
		int i,j;
		string datos = Configuracion.cargar_listas_hechos ();
		string linea_lista_hash, linea_hecho_hash;
		ArrayList<Hecho> hechos = this.lista_de_hechos ();
		var lineas = datos.split_set ("\n");

		this.inicializar_liststore_listas ();
			
		for (i=0; i < (lineas.length - 1); i++) {
			var linea = lineas[i].split (",");
			linea_lista_hash = linea[0];
			linea_hecho_hash = linea[1];
			for(j=0; j < hechos.size; j++ ) {
				if ( hechos[j].hash == linea_hecho_hash ) {
					var indice_lista = this.cache_hechos_listas.index_of (linea_lista_hash);
					print ( "hecho (" + hechos[j].nombre + ") a lista\n");
					this.hechos_listas[indice_lista].agregar (hechos[j]);
				}
			}	
		}
	}

	public void eliminar_hecho ( Hecho a_eliminar, TreePath path ) {
		TreeIter iterador;
		int anio;
		if ( en_liststore (a_eliminar.fecha.get_year(), out anio) ) {	
			this.hechos_anios[anio].get_iter(out iterador, path);
			this.hechos_anios[anio].eliminar ( iterador, a_eliminar );

			if (this.hechos_anios[anio].length () == 0) {
				this.eliminar_liststore (anio);
				this.cambio_anios ();
			}
		}
	}

	private void agregar_liststore (int cambio_anios) {
		this.hechos_anios.add ( new ListStoreHechos.anio_int (cambio_anios) );
		this.cache_hechos_anios.add (cambio_anios);
	}

	private void eliminar_liststore ( int a_eliminar ) {
		
		this.hechos_anios.remove (this.hechos_anios[a_eliminar]);
		this.cache_hechos_anios.remove(this.cache_hechos_anios[a_eliminar]);
	}

	private bool en_liststore ( int anio, out int indice ) {

		bool retorno = false;

		indice = this.cache_hechos_anios.index_of( anio ); 

		if ( indice >= 0 ) {
			retorno = true;
		}
		
		return retorno;
	}

	public void borrar_datos_hechos () {
		this.hechos_anios.clear ();
		this.cache_hechos_anios.clear ();
	}

	public void borrar_datos_listas () {
		this.hechos_listas.clear ();
		this.cache_hechos_anios.clear ();
	}

	public ArrayList<Hecho> lista_de_hechos () { 
        ArrayList<Hecho> hechos = new ArrayList<Hecho>();
		int i;

		for (i=0; i < this.hechos_anios.size; i++ ) {
			hechos.add_all (this.hechos_anios[i].lista_de_hechos ());
		}
		
		return hechos;
    }

	public ArrayList<int> lista_de_anios ()
	{
		ArrayList<int> retorno = new ArrayList<int> ();
		int i;

		for (i=0; i < this.cache_hechos_anios.size; i++ ) {
			retorno.add ( this.cache_hechos_anios[i] );
		}		
		
		return retorno;
	}

	public void cargar_fuentes_predefinidas ( ) {		
		int indice;
		ArrayList<string> locales = fuentes.lista_de_archivos ( FuentesTipo.LOCAL );
		ArrayList<string> http = fuentes.lista_de_archivos ( FuentesTipo.HTTP );
		
		for (indice = 0; indice < locales.size; indice++ ) {
			this.open_file (locales[indice], FuentesTipo.LOCAL );
		}
		for (indice = 0; indice < http.size; indice++ ) {
			this.open_file (http[indice], FuentesTipo.HTTP );
		}
	}

	public void actualizar_fuentes_predefinidas ( ListStoreFuentes fuentes ) {
		this.borrar_datos_hechos ();
		this.fuentes.actualizar_fuentes_liststore ( fuentes );
		this.cargar_fuentes_predefinidas ();
	}

	public void actualizar_listas_personalizadas ( ListStoreListas listas ) {
		this.borrar_datos_listas ();
		this.listas.actualizar_listas_liststore ( listas );
		this.cargar_datos_listas ();
	}

	public void save_file () {
		int i,y;
		ArrayList<Hecho> lista;
		string archivo;
		string a_guardar = "";
		ArrayList<string> lista_archivos = this.fuentes.lista_de_archivos ( FuentesTipo.LOCAL);
		lista = this.lista_de_hechos ();
	
		for (i=0; i < lista_archivos.size; i++) {
			archivo = lista_archivos[i];
			for (y=0; y < lista.size; y++) {
				if (lista[y].archivo_fuente == archivo) {
					a_guardar +=lista[y].a_json() + "\n";
					lista.remove_at(y);
					y--;
				}
			}

			Archivo.escribir ( archivo, a_guardar );			
			a_guardar = "";
		}	
	}

	public void open_file ( string nombre_archivo, FuentesTipo tipo ) {
		string todo;
		string[] lineas;
		Hecho nuevoHecho;
		int i;	

		todo = Archivo.leer ( nombre_archivo );

		lineas = todo.split_set ("\n");

		for (i=0; i < (lineas.length - 1); i++) {
        	nuevoHecho = new Hecho.json(lineas[i], nombre_archivo);
			if ( nuevoHecho.nombre != "null" ) {
				this.agregar_hecho(nuevoHecho);
			}
		}
	}

	public void save_as_file ( string archivo ) {
		int i;
		string a_guardar = "";

		for (i=0; i < this.hechos_anios.size; i++) {
			a_guardar += hechos_anios[i].a_json(); 
		}

		Archivo.escribir ( archivo, a_guardar );
	}

	public ListStoreHechos get_liststore ( int anio ) {

		ListStoreHechos retorno = null;
		int indice;
		
		if ( this.en_liststore ( anio, out indice ) ) {
			retorno = this.hechos_anios[indice];
		}

		if ( retorno == null ) {
			retorno = new ListStoreHechos.anio_int (0);
		}
			
		return retorno;
	}

	public signal void cambio_anios ();
}
