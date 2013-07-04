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

public class BaseDeDatos : Object {

	private Database db;
	private int rc;

	public BaseDeDatos ( ) {
	}
	
	public bool open ( string nombreDb ) {
		bool retorno = true;

		print ("puto\n");
		
		this.rc = Database.open ( nombreDb, out this.db );

		if ( this.rc != Sqlite.OK) {
			stderr.printf ("No se oudo abrir la base de dato: %d, %s", this.rc, this.db.errmsg () );
			retorno = false;
		}

		print ("puto1\n");

		this.db.exec ("SELECT * FROM hechos", callback, null );

		if ( this.rc != Sqlite.OK) {
			stderr.printf ("No se pudo ejecutar la consulta: %d, %s", this.rc, this.db.errmsg () );
			retorno = false;
		}

		print ("puto2\n");

		return retorno;
	}

	public static int callback (int n_columns, string[] values, string[] column_names) {

		print ("Andó\n"); 
		
		return 0;
	}
}
