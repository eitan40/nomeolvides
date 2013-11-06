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

	protected bool insert ( string tabla, string columnas ,string valores ) {
		bool retorno = false;
		if ( this.open ( ) ) {
			retorno = true;
			var rc = this.db.exec ("INSERT INTO \""+ tabla +"\" (" + columnas + ") VALUES (" + valores + ")", null, null);

			//print ("INSERT INTO \""+ tabla +"\" VALUES (" + valores + ")" + "\n");

			if (rc != Sqlite.OK) { 
 	          stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
			  retorno = false;
  			}
		}

		return retorno;
	}

	protected bool del ( string tabla, string where = "" ) {
		bool retorno = false;
		if ( this.open ( ) ) {
			retorno = true;
			//print ("DELETE FROM " + tabla + " " + where + "\n");

			var rc = this.db.exec ("DELETE FROM " + tabla + " " + where, null, null);

			if (rc != Sqlite.OK) { 
  				stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
				retorno = false;
    		}
		}

		return retorno;
	}

	protected bool update ( string tabla, string valores, string where ) {
		bool retorno = false;
		if ( this.open ( ) ) {
			retorno = true;		
			//print ("SQL: " + "UPDATE " + tabla + " SET " + valores + " " + where + "\n");
		
			var rc = this.db.exec ("UPDATE " + tabla + " SET " + valores + " " + where, null, null);

			if (rc != Sqlite.OK) { 
        		stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
				retorno = false;
    		}
		}

		return retorno;
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
		Array<Hecho> existe = select_hechos ( "WHERE hechos.nombre=\"" + hecho.nombre + "\" AND " +
											  "anio=\"" + hecho.get_anio ().to_string () + "\" AND " +
		                                      "mes=\"" + hecho.get_mes ().to_string () + "\" AND " +
		                                      "dia=\"" + hecho.get_dia ().to_string () + "\"" );
		if ( existe.length == 0 ) {
			this.insert ( "hechos", "nombre,descripcion,anio,mes,dia,fuente,coleccion" ,hecho.to_string ()   );
		}
	}

	public bool insert_lista ( Lista lista ) {
		bool retorno = false;
		Lista existe = select_lista ( "WHERE nombre='" + lista.nombre + "'" );

		if ( existe == null ) {
			retorno = true;
			if ( !(this.insert ( "listas", "nombre" ,"\"" + lista.nombre + "\"" ))) {
				retorno = false;
			}
		}

		return retorno;
	}

	public void insert_hecho_lista ( Hecho hecho, Lista lista ) {
		string valores = "\"" + lista.id.to_string() + "\", \""
			                  + hecho.id.to_string() + "\"";
		
		this.insert ( "listashechos", "lista,hecho",valores );
	}

	public bool insert_coleccion ( Coleccion coleccion ) {
		bool retorno = false;
		Coleccion existe = select_coleccion ( "WHERE nombre=\"" + coleccion.nombre + "\"" );

		if ( existe == null ) {
			retorno = true;
			 if ( !(this.insert ( "colecciones", "nombre,visible", coleccion.to_string () ))) {
				retorno = false;
			 }
		}

		return retorno;
	}

	public void hecho_a_borrar ( Hecho hecho ) {
		this.insert ( "hechosborrar", "id", hecho.id.to_string() );
	}

	public void coleccion_a_borrar ( Coleccion coleccion ) {
		this.insert ( "coleccionesborrar", "id", coleccion.id.to_string() );
	}

	public void lista_a_borrar ( Lista lista ) {
		this.insert ( "listasborrar", "id", lista.id.to_string() );
	}

	public void delete_hecho ( Hecho hecho ) {
		this.del ( "hechos", "WHERE id=\"" + hecho.id.to_string() +"\"" );
	}

	public bool delete_lista ( Lista lista ) {
		bool retorno = false;
		
		if (this.del ( "listas", "WHERE id=\"" + lista.id.to_string() +"\"" ) ) {
			retorno = true;
		}

		return retorno;
	}

	public void delete_hecho_lista ( Hecho hecho, Lista lista ) {
		this.del ( "listashechos",
		           "WHERE lista=\"" + lista.id.to_string()
		                            + "\" AND hecho=\"" 
		                            + hecho.id.to_string() +"\"" );
	
	}
	
	public bool delete_coleccion ( Coleccion coleccion ) {
		bool retorno = false;
		
		if( this.del ( "colecciones", "WHERE id=\"" + coleccion.id.to_string() +"\"" )) {
			retorno = true;
		}

		return retorno;
	}

	public void hecho_no_borrar ( Hecho hecho ) {
		this.del ( "hechosborrar", "WHERE id=\"" + hecho.id.to_string () +"\"" );
	}

	public void coleccion_no_borrar ( Coleccion coleccion ) {
		this.del ( "coleccionesborrar", "WHERE id=\"" + coleccion.id.to_string () +"\"" );
	}

	public void lista_no_borrar ( Lista lista ) {
		this.del ( "listasborrar", "WHERE id=\"" + lista.id.to_string () +"\"" );
	}

	public void borrar_deshacer ( ) {
		this.del ( "hechos", "WHERE hechos.id IN hechosborrar" );
		this.del ( "hechosborrar" );
		this.del ( "colecciones", "WHERE colecciones.id IN coleccionesborrar" );
		this.del ( "coleccionesborrar" );
		this.del ( "listas", "WHERE listas.id IN listasborrar" );
		this.del ( "listasborrar" );
	}

	public void update_hecho ( Hecho hecho ) {
		string valores = hecho.a_sql ();

		this.update ( "hechos",
		              valores,
		              " WHERE id=\"" + hecho.id.to_string() + "\"" );
	}
 
	public bool update_lista ( Lista lista ) {
		bool retorno = false;
		string valores = lista.a_sql ();

		if ( this.update ( "listas",valores," WHERE id=\"" + lista.id.to_string() + "\"" )) {
			retorno = true;
		}

		return retorno;
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

	public bool update_coleccion ( Coleccion coleccion ) {
		bool retorno = false;
		string valores = coleccion.a_sql ();

		if (this.update ( "colecciones",valores," WHERE id=\"" + coleccion.id.to_string() + "\"" )) {
			retorno = true;
		}

		return retorno;
	}

	public Array<Hecho> select_hechos ( string where = "" ) {
		Array<Hecho> hechos = new Array<Hecho> ();
		string where_nuevo;
		
		if ( where == "" ) {
			where_nuevo = "WHERE";
		} else {
			where_nuevo = where + " AND";
		}
		
		var stmt = this.select ( "hechos,colecciones",
		                         "hechos.nombre,descripcion,anio,mes,dia,coleccion,fuente,hechos.id",
		                         where_nuevo + " hechos.id NOT IN hechosborrar"); 
	
		hechos = this.parse_query_hechos ( stmt );
		
		return hechos;
	}

	public Array<Hecho> select_hechos_visibles ( string where = "" ) {
		Array<Hecho> hechos;
		string where_nuevo = "";

		if ( where == "" ) {
			where_nuevo = "WHERE";
		} else {
			where_nuevo = where + " AND";
		}

		hechos = this.select_hechos ( where_nuevo + " colecciones.visible=\"true\" AND hechos.coleccion = colecciones.id");

		return hechos;
	}

	public Array<Lista> select_listas ( string where = "" ) {
		Array<Lista> listas = new Array<Lista> ();
		string[] columnas = {"",""};
		string nuevo_where;
		Lista lista;

		if ( where == "" ) {
			nuevo_where = "WHERE listas.id NOT IN listasborrar";
		} else {
			nuevo_where = where + " AND listas.id NOT IN listasborrar";
		}
		
		var stmt = this.select ( "listas", "nombre,id", nuevo_where );
	
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
		string where = " WHERE lista=\"" + lista.id.to_string () + "\"" 
                     + "AND listashechos.hecho=hechos.id " 
				     + "AND colecciones.visible=\"true\" AND hechos.coleccion=colecciones.id "
					 + "AND hechos.id NOT IN hechosborrar";

		var stmt = this.select ( "hechos,listashechos,colecciones",
		                    	 "hechos.nombre,descripcion,anio,mes,dia,coleccion,fuente,hechos.id",
								 where ); 
  
		hechos = this.parse_query_hechos ( stmt );
		
		return hechos;
	}

	public Array<Coleccion> select_colecciones ( string where = "" ) {
		Array<Coleccion> colecciones = new Array<Coleccion> ();
		string[] columnas = {"","",""};
		string nuevo_where;
		Coleccion coleccion;

		if ( where == "" ) {
			nuevo_where = "WHERE colecciones.id NOT IN coleccionesborrar";
		} else {
			nuevo_where = where + " AND colecciones.id NOT IN coleccionesborrar";
		}
		
		var stmt = this.select ( "colecciones", "nombre,visible,id", nuevo_where ); 
	
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

		var stmt = this.select_distinct ( "hechos,colecciones", "anio", 
		                                   where_nuevo + " colecciones.visible=\"true\" "+ 
		                                   "AND hechos.coleccion = colecciones.id" +
		                                   " AND hechos.id NOT IN hechosborrar GROUP BY hechos.id");

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
