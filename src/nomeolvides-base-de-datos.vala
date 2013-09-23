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
using Nomeolvides;

public interface Nomeolvides.BaseDeDatos : Object {
	
	protected abstract bool open ( );
	protected abstract bool query ( string sql_query, out Statement stmt );
	protected abstract void insert ( string tabla, string columnas,string valores );
	protected abstract void del ( string tabla, string where );
	protected abstract void update ( string tabla, string valores, string where ); 
	protected abstract Statement select ( string tabla, string columnas, string where = "" );
	protected abstract Statement select_distinct ( string tabla, string columnas, string where = "" );
	protected abstract Statement count ( string tabla, string where );
	protected abstract ArrayList<Hecho> parse_query_hechos ( Statement stmt );
	public abstract void insert_hecho ( Hecho hecho );
	public abstract void insert_lista ( Lista lista );
	public abstract void insert_hecho_lista ( Hecho hecho, Lista lista );
	public abstract void insert_coleccion ( Coleccion coleccion );
	public abstract void delete_hecho ( Hecho hecho );
	public abstract void delete_lista ( Lista lista );
	public abstract void delete_hecho_lista ( Hecho hecho, Lista lista );
	public abstract void delete_coleccion ( Coleccion coleccion );
	public abstract void update_hecho ( Hecho hecho );
	public abstract void update_lista ( Lista lista );
	public abstract void update_hecho_lista ( Hecho hecho, Lista lista );
	public abstract void update_coleccion ( Coleccion coleccion );
	public abstract ArrayList<Hecho> select_hechos ( string where = "" );
	public abstract ArrayList<Hecho> select_hechos_visibles ( string where = "" );	
	public abstract ArrayList<Lista> select_listas ( string where = "" );
	public abstract ArrayList<Hecho> select_hechos_lista ( Lista lista );
	public abstract ArrayList<Coleccion> select_colecciones ( string where = "" );
	public abstract Coleccion select_coleccion ( string where = "" );
	public abstract Lista select_lista ( string where = "" );
	public abstract int count_hechos_coleccion ( Coleccion coleccion );
	public abstract int count_hechos_lista ( Lista lista );
	public abstract Array<int> lista_de_anios ( string where = "" );
	public abstract int64 ultimo_rowid ();
}
