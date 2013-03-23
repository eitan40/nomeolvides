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
	public HechosFuentes fuentes;

	public Datos () {
		this.archivo_configuracion ();
		this.cache_hechos_anios = new ArrayList<string> ();
		this.hechos_anios = new ArrayList<ListStoreHechos> ();
		this.fuentes = new HechosFuentes ( );
		this.cargar_fuentes_predefinidas ( );
	}

	public void agregar_hecho (Hecho nuevo) {
		int indice;
		if ( en_liststore ( nuevo.fecha.get_year().to_string(), out indice ) ) {
			this.hechos_anios[indice].agregar ( nuevo );
		} else {
			agregar_liststore ( nuevo.fecha.get_year().to_string() );
			if ( en_liststore ( nuevo.fecha.get_year().to_string(), out indice ) ) {
				this.hechos_anios[indice].agregar (nuevo);
				this.cambio_anios ();
			}
		}
	}


	public void eliminar_hecho ( Hecho a_eliminar, TreePath path ) {
		TreeIter iterador;
		int anio;
		if ( en_liststore (a_eliminar.fecha.get_year().to_string(), out anio) ) {	
			this.hechos_anios[anio].get_iter(out iterador, path);
			this.hechos_anios[anio].eliminar ( iterador, a_eliminar );

			if (this.hechos_anios[anio].length () == 0) {
				this.eliminar_liststore (anio);
				this.cambio_anios ();
			}
		}
	}

	private void agregar_liststore (string cambio_anios) {
		this.hechos_anios.add ( new ListStoreHechos( cambio_anios) );
		this.cache_hechos_anios.add (cambio_anios);
	}

	private void eliminar_liststore ( int a_eliminar ) {
		
		this.hechos_anios.remove (this.hechos_anios[a_eliminar]);
		this.cache_hechos_anios.remove(this.cache_hechos_anios[a_eliminar]);
	}

	private bool en_liststore ( string anio, out int indice ) {

		bool retorno = false;

		indice = this.cache_hechos_anios.index_of( anio ); 

		if ( indice >= 0 ) {
			retorno = true;
		}
		
		return retorno;
	}

	public void borrar_datos () {
		this.hechos_anios.clear ();
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

	public ArrayList<string> lista_de_anios ()
	{
		ArrayList<string> retorno = new ArrayList<string> ();
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

	public void actualizar_fuentes_predefinidas () {
		this.borrar_datos ();

		this.cargar_fuentes_predefinidas ();
	}

	public void archivo_configuracion () {
		var directorio_configuracion = File.new_for_path(GLib.Environment.get_user_config_dir () + "/nomeolvides/");

		if (!directorio_configuracion.query_exists ()) {

			try {
				directorio_configuracion.make_directory ();
			}  catch (Error e) {
				error (e.message);
			}
			
		}
	}

	public void save_file () {
/*		int i,y;
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
			try {
				FileUtils.set_contents (archivo, a_guardar);
			} catch (Error e) {
				error (e.message);
			}

			a_guardar = "";
		}*/	
	}

	public void open_file ( string nombre_archivo, FuentesTipo tipo ) {
		File archivo = null;
		uint8[] contenido;
		string todo = "";
		string[] lineas;
		Hecho nuevoHecho;
		int i;	

		if (tipo == FuentesTipo.LOCAL) {
			try {
				archivo = File.new_for_path ( nombre_archivo );
			}  catch (Error e) {
				error (e.message);
			}
		}
		
		if (tipo == FuentesTipo.HTTP) {
			try {
				archivo = File.new_for_uri ( nombre_archivo );		
			}  catch (Error e) {
				error (e.message);
			}
		}
		
		try {
			archivo.load_contents(null ,out contenido, null);
		}  catch (Error e) {
			error (e.message);
		}
		
		todo = (string) contenido;
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

		try {
			FileUtils.set_contents (archivo, a_guardar);
		}  catch (Error e) {
			error (e.message);
		} 
	}

	public ListStoreHechos get_liststore ( string anio ) {

		ListStoreHechos retorno = null;
		int indice;
		
		if ( this.en_liststore ( anio, out indice ) ) {
			retorno = this.hechos_anios[indice];
		}

		if ( retorno == null ) {
			retorno = new ListStoreHechos ("0");
		}
			
		return retorno;
	}

	public signal void cambio_anios ();
}
