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
			stderr.printf ( _("Could not open the data base") + ": %d, %s\n", this.rc, this.db.errmsg () );
			retorno = false;
		}

		var rc = this.db.exec ("PRAGMA foreign_keys=ON;", null, null);

		if (rc != Sqlite.OK) { 
            stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
        }
		
		return retorno;
	}

	protected bool query (string sql_query, out Statement stmt) {
		bool retorno = true;

		this.rc = this.db.prepare_v2 ( sql_query, -1, out stmt, null );

		if ( rc == 1 ) {
			stderr.printf ( _("Failed to execute the sentence") + ": %s - %d - %s", sql_query, this.rc, this.db.errmsg () );
			retorno = false;
		}

		return retorno;
	}

	protected void insert ( string tabla, string columnas ,string valores ) {
		this.open ( );

		var rc = this.db.exec ("INSERT INTO \""+ tabla +"\" (" + columnas + ") VALUES (" + valores + ")", null, null);

		//print ("INSERT INTO \""+ tabla +"\" VALUES (" + valores + ")" + "\n");

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

		//print ("SQL: " + "SELECT " + columnas + " FROM " + tabla + " " + where + "\n");
		
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

	protected Statement count ( string tabla, string where ) {
		Statement stmt;
		
		this.open ( );
		this.query ( "SELECT COUNT (*) FROM " + tabla + " " + where, out stmt);

		return stmt;
	} 

	protected Array<Hecho> parse_query_hechos ( Statement stmt ) {
		Array<Hecho> hechos = new Array<Hecho> ();
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
								  int64.parse (columnas[5]), 
								  columnas[6]);
					hecho.id = int64.parse(columnas[7]);
					hechos.append_val( hecho );
					break;
				default:
					print (_("Error parsing facts"));
					break;
			}
			
			rc = stmt.step ();		
		}

		return hechos;
	}

	public void insert_hecho ( Hecho hecho ) {
		this.insert ( "hechos", "nombre,descripcion,anio,mes,dia,fuente,coleccion" ,hecho.to_string ()   );
	}

	public void insert_lista ( Lista lista ) {
		this.insert ( "listas", "nombre" ,"\""+lista.nombre+"\"" );
	}

	public void insert_hecho_lista ( Hecho hecho, Lista lista ) {
		string valores = "\"" + lista.id.to_string() + "\", \""
			                  + hecho.id.to_string() + "\"";
		
		this.insert ( "listashechos", "lista,hecho",valores );
	}

	public void insert_coleccion ( Coleccion coleccion ) {
		this.insert ( "colecciones", "nombre,visible",coleccion.to_string () );
	}

	public void delete_hecho ( Hecho hecho ) {
		this.del ( "hechos", "WHERE id=\"" + hecho.id.to_string() +"\"" );
	}

	public void delete_lista ( Lista lista ) {
		this.del ( "listas", "WHERE id=\"" + lista.id.to_string() +"\"" );
	}

	public void delete_hecho_lista ( Hecho hecho, Lista lista ) {
		this.del ( "listashechos",
		           "WHERE lista=\"" + lista.id.to_string()
		                            + "\" AND hecho=\"" 
		                            + hecho.id.to_string() +"\"" );
	}
	
	public void delete_coleccion ( Coleccion coleccion ) {
		this.del ( "colecciones", "WHERE id=\"" + coleccion.id.to_string() +"\"" );
	}

	public void update_hecho ( Hecho hecho ) {
		string valores = hecho.a_sql ();

		this.update ( "hechos",
		              valores,
		              " WHERE id=\"" + hecho.id.to_string() + "\"" );
	}
 
	public void update_lista ( Lista lista ) {
		string valores = lista.a_sql ();

		this.update ( "listas",
		              valores,
		              " WHERE id=\"" + lista.id.to_string() + "\"" );
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
		              " WHERE id=\"" + coleccion.id.to_string() + "\"" );
	}

	public Array<Hecho> select_hechos ( string where = "" ) {
		Array<Hecho> hechos = new Array<Hecho> ();
		
		var stmt = this.select ( "hechos",
		                         "nombre,descripcion,anio,mes,dia,coleccion,fuente,id",
		                         where); 
	
		hechos = this.parse_query_hechos ( stmt );
		
		return hechos;
	}

	public Array<Hecho> select_hechos_visibles ( string where = "" ) {
		Array<Hecho> hechos = new Array<Hecho> ();
		string where_nuevo = "";

		if ( where == "" ) {
			where_nuevo = "WHERE";
		} else {
			where_nuevo = where + " AND";
		}

		var stmt = this.select ( "hechos,colecciones",
		                         "hechos.nombre,descripcion,anio,mes,dia,coleccion,fuente,hechos.id",
		                         where_nuevo + " colecciones.visible=\"true\" AND hechos.coleccion = colecciones.id;");

		hechos = this.parse_query_hechos ( stmt );

		return hechos;
	}

	public Array<Lista> select_listas ( string where = "" ) {
		Array<Lista> listas = new Array<Lista> ();
		string[] columnas = {"",""};
		Lista lista;
		
		var stmt = this.select ( "listas", "nombre,id", where);
	
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
					listas.append_val( lista );
					break;
				default:
					print (_("Error"));
					break;
			}
			
			rc = stmt.step ();		
		}
		
		return listas;
	}

	public Array<Hecho> select_hechos_lista ( Lista lista ) {
		Array<Hecho> hechos = new Array<Hecho> ();
		string where = " WHERE lista=\"" + lista.id.to_string ()
			                             + "\" AND listashechos.hecho=hechos.id AND colecciones.visible=\"true\" AND hechos.coleccion=colecciones.id;";
		
		var stmt = this.select ( "hechos,listashechos,colecciones",
		                         "hechos.nombre,descripcion,anio,mes,dia,coleccion,fuente,hechos.id",
		                         where ); 
	
		hechos = this.parse_query_hechos ( stmt );
		
		return hechos;
	}

	public Array<Coleccion> select_colecciones ( string where = "" ) {
		Array<Coleccion> colecciones = new Array<Coleccion> ();
		string[] columnas = {"","",""};
		Coleccion coleccion;
		
		var stmt = this.select ( "colecciones", "nombre,visible,id", where ); 
	
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
					colecciones.append_val( coleccion );
					break;
				default:
					print (_("Error"));
					break;
			}
			
			rc = stmt.step ();		
		}
		
		return colecciones;
	}

	public Coleccion select_coleccion ( string where = "" ) {
		string[] columnas = {"","",""};
		Coleccion coleccion = null;

		var stmt = this.select ( "colecciones", "nombre,visible,id", where );

		int cols = stmt.column_count ();
		int rc = stmt.step ();

		if ( rc == Sqlite.ROW ) {
			switch ( rc  ) {
				case Sqlite.DONE:
					break;
				case Sqlite.ROW:
					for ( int j = 0; j < cols; j++ ) {
						columnas[j] = stmt.column_text ( j );
					}
					coleccion = new Coleccion (columnas[0], bool.parse (columnas[1]) );
					coleccion.id = int64.parse(columnas[2]);
					break;
				default:
					print (_("Error"));
					break;
			}
		}

		return coleccion;
	}

	public Lista select_lista ( string where = "" ) {
		string[] columnas = {"",""};
		Lista lista = null;

		var stmt = this.select ( "listas", "nombre,id", where );

		int cols = stmt.column_count ();
		int rc = stmt.step ();

		if ( rc == Sqlite.ROW ) {
			switch ( rc  ) {
				case Sqlite.DONE:
					break;
				case Sqlite.ROW:
					for ( int j = 0; j < cols; j++ ) {
						columnas[j] = stmt.column_text ( j );
					}
					lista = new Lista (columnas[0]);
					lista.id = int64.parse(columnas[1]);
					break;
				default:
					print (_("Error"));
					break;
			}
		}

		return lista;
	}

	public int count_hechos_coleccion ( Coleccion coleccion ) {
		int cantidad_hechos = 0;

		var stmt = this.count ("hechos", "WHERE coleccion=" + coleccion.id.to_string() );

		int rc = stmt.step ();

		if ( rc == Sqlite.ROW ) {
			cantidad_hechos = int.parse (stmt.column_text (0));
		}

		return cantidad_hechos;
	}
	
	public int count_hechos_lista ( Lista lista ) {
		int cantidad_hechos = 0;

		var stmt = this.count ("listashechos", "WHERE lista=" + lista.id.to_string() );

		int rc = stmt.step ();

		if ( rc == Sqlite.ROW ) {
			cantidad_hechos = int.parse (stmt.column_text (0));
		}

		return cantidad_hechos;
	}

	public Array<int> lista_de_anios ( string where = "" ) {
		Array<int> anios = new Array<int>();
		string where_nuevo = "";

		if ( where == "" ) {
			where_nuevo = "WHERE";
		} else {
			where_nuevo = where + " AND";
		}

		var stmt = this.select_distinct ( "hechos,colecciones", "anio", where_nuevo + " colecciones.visible=\"true\" AND hechos.coleccion = colecciones.id;");

		int rc = stmt.step ();
		
		while ( rc == Sqlite.ROW ) {
			switch ( rc  ) {
				case Sqlite.DONE:
					break;
				case Sqlite.ROW:

					anios.append_val( int.parse (stmt.column_text (0)) );
					
					break;
				default:
					print (_("Error parsing lists"));
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
