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

	public void insert_lista ( Lista lista ) {
		this.dbms.insert_lista ( lista );
	}

	public void insert_hecho_lista ( Hecho hecho, Lista lista ) {
		this.dbms.insert_hecho_lista ( hecho, lista );
	}

	public void insert_coleccion ( Coleccion coleccion ) {
		this.dbms.insert_coleccion ( coleccion );
	}

	public void hecho_a_borrar ( Hecho hecho ) {
		this.dbms.hecho_a_borrar ( hecho );
	}

	public void delete_hecho ( Hecho hecho ) {
		this.dbms.delete_hecho ( hecho );
	}

	public void delete_lista ( Lista lista ) {
		this.dbms.delete_lista ( lista );
	}

	public void delete_hecho_lista ( Hecho hecho, Lista lista ) {
		this.dbms.delete_hecho_lista ( hecho, lista );
	}

	public void delete_coleccion ( Coleccion coleccion ) {
		this.dbms.delete_coleccion ( coleccion );
	}

	public void hecho_no_borrar ( Hecho hecho ) {
		this.dbms.hecho_no_borrar ( hecho );
	}

	public void borrar_deshacer ( ) {
		this.dbms.borrar_deshacer ();
	}

	public void update_hecho ( Hecho hecho ) {
		this.dbms.update_hecho ( hecho );
	}
 
	public void update_lista ( Lista lista ) {
		this.dbms.update_lista ( lista );
	}

	public void update_hecho_lista ( Hecho hecho, Lista lista ) {
		this.dbms.update_hecho_lista ( hecho, lista );
	}

	public void update_coleccion ( Coleccion coleccion ) {
		this.dbms.update_coleccion ( coleccion );
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

	public Coleccion select_coleccion ( string where = "" ) {
		return this.dbms.select_coleccion ( where ); 
	}

	public Lista select_lista ( string where = "" ) {
		return this.dbms.select_lista ( where );
	}

	public int count_hechos_coleccion ( Coleccion coleccion ) {
		return this.dbms.count_hechos_coleccion ( coleccion );
	}
	
	public int count_hechos_lista ( Lista lista ) {
		return this.dbms.count_hechos_lista ( lista );
	}

	public Array<int> lista_de_anios () {
		return this.dbms.lista_de_anios ( ); 
	}

	public int64 ultimo_rowid () {
		return this.dbms.ultimo_rowid ();
	}
}
