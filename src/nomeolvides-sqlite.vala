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
using Gee;
using Nomeolvides;

public class Nomeolvides.Sqlite3 : Nomeolvides.BaseDeDatos, Object {
	private Database db;
	private  int rc;
	
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

	public void insert ( string nombre_db, string tabla, string valores ) {
		this.open ( nombre_db );

		var rc = this.db.exec ("INSERT INTO \""+ tabla +"\" VALUES (" + valores + ")", null, null);

		if (rc != Sqlite.OK) { 
            stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
        }
	}

	public void del ( string nombre_db, string tabla, string where ) {
		this.open ( nombre_db );

		var rc = this.db.exec ("DELETE FROM " + tabla + " " + where, null, null);

		if (rc != Sqlite.OK) { 
            stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
        }
	}

	public void update ( string nombre_db, string tabla, string valores, string where ) {
		this.open ( nombre_db );

		print ("SQL: " + "UPDATE " + tabla + " SET " + valores + " " + where + "\n");
		
		var rc = this.db.exec ("UPDATE " + tabla + " SET " + valores + " " + where, null, null);

		if (rc != Sqlite.OK) { 
            stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
        }
	}

	public Statement select ( string nombre_db, string tabla, string columnas ) {
		Statement stmt;
		
		this.open ( nombre_db);
		this.query ( "SELECT " + columnas + " FROM " + tabla, out stmt);

		return stmt;
	}

	public int64 ultimo_rowid () {
		return this.db.last_insert_rowid ();
	}

}
