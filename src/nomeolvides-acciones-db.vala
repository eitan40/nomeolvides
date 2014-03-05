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

using GLib;
using Sqlite;

public class Nomeolvides.AccionesDB : Object {

	private BaseDeDatos dbms;

	public AccionesDB ( string nombredb) {
		this.dbms = new Sqlite3 ( nombredb );
	}

	public void insert_hecho ( Hecho hecho ) {
		this.dbms.insert_hecho ( hecho );
	}

	public bool insert_lista ( Lista lista ) {
		return this.dbms.insert_lista ( lista );
	}

	public void insert_hecho_lista ( Hecho hecho, Lista lista ) {
		this.dbms.insert_hecho_lista ( hecho, lista );
	}

	public bool insert_coleccion ( Coleccion coleccion ) {
		return this.dbms.insert_coleccion ( coleccion );
	}

	public bool insert_etiqueta ( Etiqueta etiqueta ) {
		return this.dbms.insert_etiqueta ( etiqueta );
	}

	public void insert_hecho_etiqueta ( Hecho hecho, Etiqueta etiqueta ) {
		this.dbms.insert_hecho_etiqueta ( hecho, etiqueta );
	}

	public void hecho_a_borrar ( Hecho hecho ) {
		this.dbms.hecho_a_borrar ( hecho );
	}

	public void coleccion_a_borrar ( Coleccion coleccion ) {
		this.dbms.coleccion_a_borrar ( coleccion );
	}

	public void lista_a_borrar ( Lista lista ) {
		this.dbms.lista_a_borrar ( lista );
	}

	public void etiqueta_a_borrar ( Etiqueta etiqueta ) {
		this.dbms.etiqueta_a_borrar ( etiqueta );
	}

	public void delete_hecho ( Hecho hecho ) {
		this.dbms.delete_hecho ( hecho );
	}

	public bool delete_lista ( Lista lista ) {
		return this.dbms.delete_lista ( lista );
	}

	public void delete_hecho_lista ( Hecho hecho, Lista lista ) {
		this.dbms.delete_hecho_lista ( hecho, lista );
	}

	public bool delete_coleccion ( Coleccion coleccion ) {
		return this.dbms.delete_coleccion ( coleccion );
	}

	public bool delete_etiqueta ( Etiqueta etiqueta ) {
		return this.dbms.delete_etiqueta ( etiqueta );
	}

	public void delete_hecho_etiqueta ( Hecho hecho, Etiqueta etiqueta ) {
		this.dbms.delete_hecho_etiqueta ( hecho, etiqueta );
	}

	public void hecho_no_borrar ( Hecho hecho ) {
		this.dbms.hecho_no_borrar ( hecho );
	}

	public void coleccion_no_borrar ( Coleccion coleccion ) {
		this.dbms.coleccion_no_borrar ( coleccion );
	}

	public void lista_no_borrar ( Lista lista ) {
		this.dbms.lista_no_borrar ( lista );
	}

	public void etiqueta_no_borrar ( Etiqueta etiqueta ) {
		this.dbms.etiqueta_no_borrar ( etiqueta );
	}

	public void borrar_deshacer ( ) {
		this.dbms.borrar_deshacer ();
	}

	public void update_hecho ( Hecho hecho ) {
		this.dbms.update_hecho ( hecho );
	}
 
	public bool update_lista ( Lista lista ) {
		return this.dbms.update_lista ( lista );
	}

	public void update_hecho_lista ( Hecho hecho, Lista lista ) {
		this.dbms.update_hecho_lista ( hecho, lista );
	}

	public bool update_coleccion ( Coleccion coleccion ) {
		return this.dbms.update_coleccion ( coleccion );
	}

	public bool update_etiqueta ( Etiqueta etiqueta ) {
		return this.dbms.update_etiqueta ( etiqueta );
	}

	public Array<Hecho> select_hechos ( string where = "" ) {
		return this.dbms.select_hechos ( where );
	}

	public Array<Hecho> select_hechos_visibles ( string where = "" ) {
		return this.dbms.select_hechos_visibles ( where );
	}

	public Array<Lista> select_listas ( string where = "" ) {
		return this.dbms.select_listas ( where );
	}

	public Array<Hecho> select_hechos_lista ( Lista lista ) {
		return this.dbms.select_hechos_lista ( lista ); 
	}

	public Array<Coleccion> select_colecciones ( string where = "" ) {
		return this.dbms.select_colecciones ( where );
	}

	public Array<Etiqueta> select_etiquetas ( string where = "" ) {
		return this.dbms.select_etiquetas ( where );
	}

	public Array<Hecho> select_hechos_etiqueta ( Etiqueta etiqueta ) {
		return this.dbms.select_hechos_etiqueta ( etiqueta ); 
	}

	public Coleccion select_coleccion ( string where = "" ) {
		return this.dbms.select_coleccion ( where ); 
	}

	public Lista select_lista ( string where = "" ) {
		return this.dbms.select_lista ( where );
	}

	public Etiqueta select_etiqueta ( string where = "" ) {
		return this.dbms.select_etiqueta ( where );
	}

	public int count_hechos_coleccion ( Coleccion coleccion ) {
		return this.dbms.count_hechos_coleccion ( coleccion );
	}
	
	public int count_hechos_lista ( Lista lista ) {
		return this.dbms.count_hechos_lista ( lista );
	}

	public int count_hechos_etiqueta ( Etiqueta etiqueta ) {
		return this.dbms.count_hechos_etiqueta ( etiqueta );
	}

	public Array<int> lista_de_anios () {
		return this.dbms.lista_de_anios ( ); 
	}

	public int64 ultimo_rowid () {
		return this.dbms.ultimo_rowid ();
	}
}
