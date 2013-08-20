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
		this.dbms.insert ( "hechos", hecho.to_string () );
	}

	public void insert_lista ( Lista lista ) {
		this.dbms.insert ( "listas", "\""+lista.nombre+"\"" );
	}

	public void insert_hecho_lista ( Hecho hecho, Lista lista ) {
		string valores = "\"" + lista.id.to_string() + "\", \""
			                        + hecho.id.to_string() + "\"";
		
		this.dbms.insert ( "listashechos", valores );
	}

	public void delete_hecho ( Hecho hecho ) {
		this.dbms.del ( "hechos", "WHERE rowid=\"" + hecho.id.to_string() +"\"" );
	}

	public void delete_lista ( Lista lista ) {
		this.dbms.del ( "listas", "WHERE rowid=\"" + lista.id.to_string() +"\"" );
	}

	public void delete_hecho_lista ( Hecho hecho, Lista lista ) {
		this.dbms.del ( "listashechos", "WHERE lista=\"" + lista.id.to_string()
		                                           + "\" AND hecho=\"" 
		                                           + hecho.id.to_string() +"\"" );
	}

	public void update_hecho ( Hecho hecho ) {
		string valores = hecho.a_sql ();

		this.dbms.update ( "hechos", valores, " WHERE rowid=\"" + hecho.id.to_string() + "\"" );
	}
 
	public void update_lista ( Lista lista ) {
		string valores = lista.a_sql ();

		this.dbms.update ( "listas", valores, " WHERE rowid=\"" + lista.id.to_string() + "\"" );
	}

	public void update_hecho_lista ( Hecho hecho, Lista lista ) {
		string valores = "lista=\"" + lista.id.to_string() + "\" hecho=\""
			                        + lista.id.to_string() + "\"";

		this.dbms.update ( "listashechos", valores, "WHERE lista=\"" + lista.id.to_string()
		                                           + "\" AND hecho=\"" 
		                                           + hecho.id.to_string() +"\"" );
	}

	public ArrayList<Hecho> select_hechos ( string where = "" ) {
		ArrayList<Hecho> hechos = new ArrayList<Hecho> ();
		
		var stmt = this.dbms.select ( "hechos", "nombre,descripcion,anio,mes,dia,fuente,rowid", where); 
	
		hechos = this.parse_query_hechos ( stmt );
		
		return hechos;
	}

	public ArrayList<Lista> select_listas ( ) {
		ArrayList<Lista> listas = new ArrayList<Lista> ();
		string[] columnas = {"",""};
		Lista lista;
		
		var stmt = this.dbms.select ( "listas", "nombre,rowid"); 
	
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
		string where = " WHERE lista=\"" + lista.id.to_string () + "\" and listashechos.hecho=hechos.rowid";
		
		var stmt = this.dbms.select ( "hechos,listashechos", "nombre,descripcion,anio,mes,dia,fuente,hechos.rowid", where ); 
	
		hechos = this.parse_query_hechos ( stmt );
		
		return hechos;
	}

	public int64 ultimo_hecho_id () {
		return this.dbms.ultimo_rowid ();
	}

	private ArrayList<Hecho> parse_query_hechos ( Statement stmt ) {
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

	public Array<int> lista_de_anios () {
		Array<int> anios = new Array<int>();

		var stmt = this.dbms.select_distinct ( "hechos", "anio", ""); 

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
	
}
