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
using Gee;
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

	public ArrayList<Hecho> select_hechos ( string where = "" ) {
		return this.dbms.select_hechos ( where );
	}

	public ArrayList<Hecho> select_hechos_visibles ( string where = "" ) {
		return this.dbms.select_hechos_visibles ( where );
	}

	public ArrayList<Lista> select_listas ( string where = "" ) {
		return this.dbms.select_listas ( where );
	}

	public ArrayList<Hecho> select_hechos_lista ( Lista lista ) {
		return this.dbms.select_hechos_lista ( lista ); 
	}

	public ArrayList<Coleccion> select_colecciones ( string where = "" ) {
		return this.dbms.select_colecciones ( where );
	}

	public Coleccion select_coleccion ( string where = "" ) {
		return this.dbms.select_coleccion ( where ); 
	}

	public Array<int> lista_de_anios () {
		return this.dbms.lista_de_anios ( ); 

	}

	public int64 ultimo_rowid () {
		return this.dbms.ultimo_rowid ();
	}
}
