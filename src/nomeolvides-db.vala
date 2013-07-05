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

public class BaseDeDatos : Object {

	private Database db;
	private int rc;

	public BaseDeDatos ( ) {
	}
	
	private bool open ( string nombre_db ) {
		bool retorno = true;
		
		this.rc = Database.open ( nombre_db, out this.db );

		if ( this.rc != Sqlite.OK) {
			stderr.printf ( "No se pudo abrir la base de dato: %d, %s\n", this.rc, this.db.errmsg () );
			retorno = false;
		}
		
		return retorno;
	}

	private bool query (string sql_query, out Statement stmt) {
		bool retorno = true;
		
		this.rc = this.db.prepare_v2 ( sql_query, -1, out stmt, null );

		if ( rc == 1 ) {
			stderr.printf ( "No se pudo ejecutar la sentencia: %s - %d - %s", sql_query, this.rc, this.db.errmsg () );
			retorno = false;
		}

		return retorno;
	}

	public Hecho select ( string sql_query, string nombre_db ) {
		Statement stmt;
		string[] columnas = {"","","",""};
		
		if ( this.open ( nombre_db) ) {
			if (this.query ( sql_query, out stmt) ) {
				int cols = stmt.column_count ();

				stmt.step ();
				
				for ( int i = 0; i < cols; i++ ) {
					columnas[i] = stmt.column_text ( i );
				//	print (columnas[i] + "\n");
				}

				return new Hecho (columnas[0], columnas[3], 1945, 10, 17, nombre_db, columnas[2]);
			}
		}

		return (Hecho) null;
	}
}
