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

	private Hechos hechos;
	public Deshacer deshacer;
	public HechosFuentes fuentes;
	public Listas listas;

	public Datos () {

		this.deshacer = new Deshacer ();
		this.hechos = new Hechos ();
		this.fuentes = new HechosFuentes ();
		this.listas = new Listas ();
		this.cargar_fuentes_predefinidas ();
		this.cargar_datos_listas ();

		this.hechos.hechos_cambio_anios.connect ( this.signal_cambio_anios );
		this.hechos.hechos_cambio_listas.connect ( this.signal_cambio_listas );
	}

	public void agregar_hecho (Hecho nuevo) {	
		this.hechos.agregar_hecho_anio ( nuevo.fecha.get_year (), nuevo );
	}

	private void cargar_datos_listas () {
		int i,j;
		string datos = Configuracion.cargar_listas_hechos ();
		string linea_lista_hash, linea_hecho_hash;

		var lineas = datos.split_set ("\n");

		for (i=0; i < (lineas.length - 1); i++) {
			var linea = lineas[i].split (",");
			linea_lista_hash = linea[0];
			linea_hecho_hash = linea[1];
			this.hechos.agregar_hecho_lista ( linea_lista_hash, linea_hecho_hash );
		}

	}

	public void eliminar_hecho ( Hecho a_eliminar, TreePath path ) {
		this.hechos.borrar_hecho (a_eliminar.fecha.get_year (), a_eliminar );

	}

	public void deshacer_cambios () {
		DeshacerItem item;
		item = this.deshacer.deshacer ();
		if ( item.get_tipo () == DeshacerTipo.EDITAR ) {
			this.eliminar_hecho ( item.get_editado(), item.get_path () );
		}
		this.agregar_hecho ( item.get_borrado() );
		this.guardar_un_archivo ( item.get_borrado().archivo_fuente);
	}

	public ArrayList<Hecho> lista_de_hechos () { 
		return this.hechos.lista_de_hechos ();
    }

	public ArrayList<int> lista_de_anios ()
	{
		return this.hechos.get_anios ();
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
		this.fuentes.actualizar_fuentes_liststore ( fuentes );
		this.cargar_fuentes_predefinidas ();
	}

	public void actualizar_listas_personalizadas ( ListStoreListas listas ) {
		this.listas.actualizar_listas_liststore ( listas );
		this.cargar_datos_listas ();
	}

	public void save_file () {
		int i;
		ArrayList<string> lista_archivos = this.fuentes.lista_de_archivos ( FuentesTipo.LOCAL);
	
		for (i=0; i < lista_archivos.size; i++) {
			guardar_un_archivo ( lista_archivos[i] );
		}
	
	}

	public void guardar_un_archivo ( string archivo ) {
		string a_guardar = "";
		ArrayList<Hecho> lista = this.lista_de_hechos ();
		int i;
		for (i=0; i < lista.size; i++) {
			if (lista[i].archivo_fuente == archivo) {
				a_guardar +=lista[i].a_json() + "\n";
			}
		}
		Archivo.escribir ( archivo, a_guardar );			
	}

	public void guardar_listas_hechos () {
		/*string hash, a_guardar = "";
		int i,j;
		ArrayList<Hecho> lista;
		
		for (i=0; i < this.cache_hechos_listas.size; i++) {
			lista = this.hechos_listas[i].lista_de_hechos ();
			hash = this.cache_hechos_listas[i];
			for (j=0; j < lista.size; j++) {

				a_guardar += hash + "," + lista[j].hash + "\n";
			}
		}
		this.listas.guardar_listas_hechos ( a_guardar );*/
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
		/*int i;
		string a_guardar = "";

		for (i=0; i < this.hechos_anios.size; i++) {
			a_guardar += hechos_anios[i].a_json(); 
		}

		Archivo.escribir ( archivo, a_guardar );*/
	}

	public ListStoreHechos get_liststore_anio ( int anio ) {
		return this.hechos.get_anio ( anio );
	}

	public ListStoreHechos get_liststore_lista ( string lista ) {
		var hash = this.listas.get_nombre_hash ( lista );
		return this.hechos.get_lista ( hash );
	}

	public ListStoreListas lista_de_listas () {
		return this.listas.temp ();
	}

	public void signal_cambio_anios () {
		this.datos_cambio_anios ();
	}

	public void signal_cambio_listas () {
		this.datos_cambio_listas ();
	}

	public signal void datos_cambio_anios ();
	public signal void datos_cambio_listas ();
}
