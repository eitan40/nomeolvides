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
	private string nombre_db;

	public Sqlite3 ( string nombredb ) {
		this.nombre_db = nombredb;
	}
	
	protected bool open ( ) {
		bool retorno = true;
		
		this.rc = Database.open ( nombre_db, out this.db );
		if ( this.rc != Sqlite.OK) {
			stderr.printf ( "No se pudo abrir la base de dato: %d, %s\n", this.rc, this.db.errmsg () );
			retorno = false;
		}
		return retorno;
	}

	protected bool query (string sql_query, out Statement stmt) {
		bool retorno = true;

		this.rc = this.db.prepare_v2 ( sql_query, -1, out stmt, null );

		if ( rc == 1 ) {
			stderr.printf ( "No se pudo ejecutar la sentencia: %s - %d - %s", sql_query, this.rc, this.db.errmsg () );
			retorno = false;
		}

		return retorno;
	}

	protected void insert ( string tabla, string valores ) {
		this.open ( );

		var rc = this.db.exec ("INSERT INTO \""+ tabla +"\" VALUES (" + valores + ")", null, null);

		if (rc != Sqlite.OK) { 
            stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
        }
	}

	protected void del ( string tabla, string where ) {
		this.open ( );

		//print ("DELETE FROM " + tabla + " " + where + "\n");

		var rc = this.db.exec ("DELETE FROM " + tabla + " " + where, null, null);

		if (rc != Sqlite.OK) { 
            stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
        }
	}

	protected void update ( string tabla, string valores, string where ) {
		this.open ( );

		//print ("SQL: " + "UPDATE " + tabla + " SET " + valores + " " + where + "\n");
		
		var rc = this.db.exec ("UPDATE " + tabla + " SET " + valores + " " + where, null, null);

		if (rc != Sqlite.OK) { 
            stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
        }
	}

	protected Statement select ( string tabla, string columnas, string where = "" ) {
		Statement stmt;
		
		this.open ( );
		this.query ( "SELECT " + columnas + " FROM " + tabla + " " + where, out stmt);

		return stmt;
	}

	protected Statement select_distinct ( string tabla, string columnas, string where = "" ) {
		Statement stmt;
		
		this.open ( );
		this.query ( "SELECT DISTINCT " + columnas + " FROM " + tabla + " " + where, out stmt);

		return stmt;
	}

	protected ArrayList<Hecho> parse_query_hechos ( Statement stmt ) {
		ArrayList<Hecho> hechos = new ArrayList<Hecho> ();
		string[] columnas = {"","","","","","",""};
		Hecho hecho;
	
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
					print ("Error al parsear hechos!!");
					break;
			}
			
			rc = stmt.step ();		
		}

		return hechos;
	}

	public void insert_hecho ( Hecho hecho ) {
		this.insert ( "hechos", hecho.to_string () );
	}

	public void insert_lista ( Lista lista ) {
		this.insert ( "listas", "\""+lista.nombre+"\"" );
	}

	public void insert_hecho_lista ( Hecho hecho, Lista lista ) {
		string valores = "\"" + lista.id.to_string() + "\", \""
			                  + hecho.id.to_string() + "\"";
		
		this.insert ( "listashechos", valores );
	}

	public void insert_coleccion ( Coleccion coleccion ) {
		this.insert ( "colecciones", "\""+ coleccion.to_string () +"\"");
	}

	public void delete_hecho ( Hecho hecho ) {
		this.del ( "hechos", "WHERE rowid=\"" + hecho.id.to_string() +"\"" );
	}

	public void delete_lista ( Lista lista ) {
		this.del ( "listas", "WHERE rowid=\"" + lista.id.to_string() +"\"" );
	}

	public void delete_hecho_lista ( Hecho hecho, Lista lista ) {
		this.del ( "listashechos",
		           "WHERE lista=\"" + lista.id.to_string()
		                            + "\" AND hecho=\"" 
		                            + hecho.id.to_string() +"\"" );
	}
	
	public void delete_coleccion ( Coleccion coleccion ) {
		this.del ( "colecciones", "WHERE rowid=\"" + coleccion.id.to_string() +"\"" );
	}

	public void update_hecho ( Hecho hecho ) {
		string valores = hecho.a_sql ();

		this.update ( "hechos",
		              valores,
		              " WHERE rowid=\"" + hecho.id.to_string() + "\"" );
	}
 
	public void update_lista ( Lista lista ) {
		string valores = lista.a_sql ();

		this.update ( "listas",
		              valores,
		              " WHERE rowid=\"" + lista.id.to_string() + "\"" );
	}

	public void update_hecho_lista ( Hecho hecho, Lista lista ) {
		string valores = "lista=\"" + lista.id.to_string() + "\" hecho=\""
			                        + lista.id.to_string() + "\"";

		this.update ( "listashechos",
		              valores,
		              "WHERE lista=\"" + lista.id.to_string()
		                               + "\" AND hecho=\"" 
		                               + hecho.id.to_string() +"\"" );
	}

	public void update_coleccion ( Coleccion coleccion ) {
		string valores = coleccion.a_sql ();

		this.update ( "colecciones",
		              valores,
		              " WHERE rowid=\"" + coleccion.id.to_string() + "\"" );
	}

	public ArrayList<Hecho> select_hechos ( string where = "" ) {
		ArrayList<Hecho> hechos = new ArrayList<Hecho> ();
		
		var stmt = this.select ( "hechos",
		                         "nombre,descripcion,anio,mes,dia,fuente,rowid",
		                         where); 
	
		hechos = this.parse_query_hechos ( stmt );
		
		return hechos;
	}

	public ArrayList<Lista> select_listas ( ) {
		ArrayList<Lista> listas = new ArrayList<Lista> ();
		string[] columnas = {"",""};
		Lista lista;
		
		var stmt = this.select ( "listas", "nombre,rowid"); 
	
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

					lista = new Lista (columnas[0]);
					lista.id = int64.parse(columnas[1]);
					listas.add( lista );
					break;
				default:
					print ("Error!!");
					break;
			}
			
			rc = stmt.step ();		
		}
		
		return listas;
	}

	public ArrayList<Hecho> select_hechos_lista ( Lista lista ) {
		ArrayList<Hecho> hechos = new ArrayList<Hecho> ();
		string where = " WHERE lista=\"" + lista.id.to_string ()
			                             + "\" and listashechos.hecho=hechos.rowid";
		
		var stmt = this.select ( "hechos,listashechos",
		                         "nombre,descripcion,anio,mes,dia,fuente,hechos.rowid",
		                         where ); 
	
		hechos = this.parse_query_hechos ( stmt );
		
		return hechos;
	}

	public ArrayList<Coleccion> select_colecciones ( string where = "" ) {
		ArrayList<Coleccion> colecciones = new ArrayList<Coleccion> ();
		string[] columnas = {"","",""};
		Coleccion coleccion;
		
		var stmt = this.select ( "colecciones", "nombre,visible,rowid", where ); 
	
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

					coleccion = new Coleccion (columnas[0], bool.parse (columnas[1]) );
					coleccion.id = int64.parse(columnas[2]);
					colecciones.add( coleccion );
					break;
				default:
					print ("Error!!");
					break;
			}
			
			rc = stmt.step ();		
		}
		
		return colecciones;
	}

	public Array<int> lista_de_anios ( string where = "" ) {
		Array<int> anios = new Array<int>();

		var stmt = this.select_distinct ( "hechos", "anio", where); 

		int rc = stmt.step ();
		
		while ( rc == Sqlite.ROW ) {
			switch ( rc  ) {
				case Sqlite.DONE:
					break;
				case Sqlite.ROW:

					anios.append_val( int.parse (stmt.column_text (0)) );
					
					break;
				default:
					print ("Error al obtener la lista de años!!");
					break;
			}
			
			rc = stmt.step ();
		}
		return anios;
	}

	public int64 ultimo_rowid () {
		return this.db.last_insert_rowid ();
	}
}
