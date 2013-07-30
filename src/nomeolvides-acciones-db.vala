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

public class Nomeolvides.AccionesDB : Object {

	private Sqlite3 dbms;

	public AccionesDB () {
		this.dbms = new Sqlite3 ();
	}

	public void insert_hecho ( Hecho hecho ) {
		this.dbms.insert ( "nomeolvides.db","hechos", hecho.to_string () );
	}

	public void delete_hecho ( Hecho hecho ) {
		this.dbms.del ( "nomeolvides.db", "hechos", "WHERE rowid=\"" + hecho.id.to_string() +"\"" );
	}

	public void update_hecho ( Hecho hecho ) {
		string valores = hecho.to_string ();
		
		string[] val = valores.split(",");

		val[0] = "nombre="+ val[0] + ",";
		val[1] = "descripcion="+ val[1] + ",";
		val[2] = "anio="+ val[2] + ",";
		val[3] = "mes="+ val[3] + ",";
		val[4] = "dia="+ val[4] + ",";
		val[5] = "fuente="+ val[5];

		valores = "";
		for ( int i = 0; i < 6; i++ ) {
			valores += val[i];
		}

		this.dbms.update ("nomeolvides.db", "hechos", valores, " WHERE rowid=\"" + hecho.id.to_string() + "\"" );
	}

	public ArrayList<Hecho> select_hechos ( ) {
		ArrayList<Hecho> hechos = new ArrayList<Hecho> ();
		string[] columnas = {"","","","","","",""};
		Hecho hecho;
		
		var stmt = this.dbms.select ( "nomeolvides.db", "hechos", "nombre,descripcion,anio,mes,dia,fuente,rowid"); 
	
		int cols = stmt.column_count ();
		int rc = stmt.step ();
		
		while ( rc == Sqlite.ROW ) {
			switch ( rc  ) {
				case Sqlite.DONE:
					break;
				case Sqlite.ROW:
					for ( int j = 0; j < cols; j++ ) {
						columnas[j] = stmt.column_text ( j );
					} 

					hecho = new Hecho (columnas[0],
					              columnas[1],
			    		          int.parse (columnas[2]),
			        		      int.parse (columnas[3]),
			            		  int.parse (columnas[4]),
								  "Base de datos local", 
								  columnas[5]);
					hecho.id = int64.parse(columnas[6]);
					hechos.add( hecho );
					break;
				default:
					print ("Error!!");
					break;
			}
			
			rc = stmt.step ();		
		}
		
		return hechos;
	}

	public int64 ultimo_hecho_id () {
		return this.dbms.ultimo_rowid ();
	}
}