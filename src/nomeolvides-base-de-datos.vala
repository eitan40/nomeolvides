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
using Nomeolvides;

public interface Nomeolvides.BaseDeDatos : Object {
	
	protected abstract bool open ( );
	protected abstract bool query ( string sql_query, out Statement stmt );
	public abstract void insert ( string tabla, string valores );
	public abstract void del ( string tabla, string where );
	public abstract void update ( string tabla, string valores, string where ); 
	public abstract Statement select ( string tabla, string columnas, string where = "" );
	public abstract int64 ultimo_rowid ();
}
