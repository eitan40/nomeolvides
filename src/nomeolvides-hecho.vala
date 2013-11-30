/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2012 Fernando Fernandez <fernando@softwareperonista.com.ar>
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

public class Nomeolvides.Hecho : GLib.Object {

	public int64 id;
	public string nombre { get; private set; }
	public string descripcion { get; private set; }
	public DateTime fecha {get; private set; }
	public string hash { get; private set; }
	public int64 coleccion;
	public string fuente { get; private set; }

	// Constructor
	public Hecho ( string nombre, string descripcion, int anio, int mes, int dia, int64 coleccion, string fuente = "" )
	{
		this.nombre = Hecho.ponerCaracterEspecial ( nombre );
		this.descripcion = Hecho.ponerCaracterEspecial ( descripcion );
		this.fecha = new DateTime.utc (anio, mes, dia, 0,0,0);
		this.coleccion = coleccion;
		this.fuente = Hecho.ponerCaracterEspecial ( fuente );
		this.calcular_checksum ();
	}

	public Hecho.vacio () {

	}

	public Hecho.json (string json, int64 coleccion ) {
		
		if ( json.contains ( "{\"Hecho\":{" ) ) {
			this.nombre = Hecho.ponerCaracterEspecial ( this.sacarDatoJson ( json, "nombre" ) );
			this.descripcion = Hecho.ponerCaracterEspecial ( this.sacarDatoJson ( json, "descripcion" ) );
			this.fecha = new DateTime.utc (int.parse (this.sacarDatoJson( json, "anio" ) ),
			                               int.parse (this.sacarDatoJson( json, "mes" ) ),
			                               int.parse (this.sacarDatoJson( json, "dia") ),
			                     		   0,0,0);
			this.fuente = Hecho.ponerCaracterEspecial ( this.sacarDatoJson ( json, "fuente" ) );
		} else {
			this.nombre = "null";
			this.descripcion = "null";
			this.fecha = new DateTime.utc ( 2013,2,20,0,0,0 );
			this.fuente = "null";
		}	
		this.calcular_checksum ();

		this.coleccion = coleccion;
	}

	private void calcular_checksum () {
		this.hash = Checksum.compute_for_string( ChecksumType.MD5, this.a_json () );
	}
	
	public string a_json () {
		string retorno = "{\"Hecho\":{";

		retorno += "\"nombre\":\"" + Hecho.sacarCaracterEspecial( this.nombre ) + "\",";
		retorno += "\"descripcion\":\"" + Hecho.sacarCaracterEspecial( this.descripcion ) + "\",";
		retorno += "\"anio\":\"" + this.fecha.get_year ().to_string () + "\",";
		retorno += "\"mes\":\"" + this.fecha.get_month ().to_string () + "\",";
		retorno += "\"dia\":\"" + this.fecha.get_day_of_month ().to_string () + "\",";
		retorno += "\"fuente\":\"" + Hecho.sacarCaracterEspecial( this.fuente ) + "\",";
		retorno += "\"coleccion\":\"" + this.coleccion.to_string () + "\"";

		retorno +="}}";	
		
		return retorno;
	}

	public string to_string () {
		string retorno;

		retorno  = "\"" + Hecho.sacarCaracterEspecial( this.nombre ) + "\",";
		retorno += "\"" + Hecho.sacarCaracterEspecial( this.descripcion ) + "\",";
		retorno += "\"" + this.fecha.get_year ().to_string () + "\",";
		retorno += "\"" + this.fecha.get_month ().to_string () + "\",";
		retorno += "\"" + this.fecha.get_day_of_month ().to_string () + "\",";
		retorno += "\"" + Hecho.sacarCaracterEspecial( this.fuente ) + "\",";
		retorno += "\"" + this.coleccion.to_string () + "\"";

		return retorno;
	}

	public string a_sql () {
		string retorno;

		retorno  = "nombre=\"" + Hecho.sacarCaracterEspecial( this.nombre ) + "\",";
		retorno += "descripcion=\"" + Hecho.sacarCaracterEspecial( this.descripcion ) + "\",";
		retorno += "anio=\"" + this.fecha.get_year ().to_string () + "\",";
		retorno += "mes=\"" + this.fecha.get_month ().to_string () + "\",";
		retorno += "dia=\"" + this.fecha.get_day_of_month ().to_string () + "\",";
		retorno += "fuente=\"" + Hecho.sacarCaracterEspecial( this.fuente ) + "\",";
		retorno += "coleccion=\"" + this.coleccion.to_string () + "\"";

		print (retorno + "\n");
		
		return retorno;
	}

	private string sacarDatoJson(string json, string campo) {
		int inicio,fin;
		inicio = json.index_of(":",json.index_of("\"" + campo + "\"")) + 2;
		fin = json.index_of ("\"", inicio);
		return json[inicio:fin];
	}

	public string fecha_to_string () {
		string texto;
		texto = this.fecha.format(_("%B %e, %Y"));
		return texto;
	}

	public bool esIgual (string otroSum) {
		
		if (this.hash == otroSum) {
			return true;
		}
		else {
			return false;
		}
	}

	public string nombre_para_archivo () {
		string retorno = this.nombre;

		retorno = retorno.replace (" ","-");
		retorno = retorno.down();
		retorno = retorno.replace ("á", "a");
		retorno = retorno.replace ("é", "e");
		retorno = retorno.replace ("í", "i");
		retorno = retorno.replace ("ó", "o");
		retorno = retorno.replace ("ú", "u");
		retorno = retorno.replace ("ñ", "ni");

		return retorno;
	}

	public int get_anio () {
		return this.fecha.get_year();
	}

	public int get_mes () {
		return this.fecha.get_month();
	}

	public int get_dia () {
		return this.fecha.get_day_of_month ();
	}

	public void set_id ( int64 id ) {
		this.id = id;
	}

	public void set_coleccion ( int64 coleccion ) {
		this.coleccion = coleccion;
	}

	public static string ponerCaracterEspecial ( string inicial ) {

		string saltoDeLinea = "\n";
		string reemplazoSaltoDeLinea = "|";
		string retorno = inicial.replace ( reemplazoSaltoDeLinea, saltoDeLinea );
		
		string comillas = "\"";
		string reemplazoComillas = "_";
		retorno = retorno.replace ( reemplazoComillas, comillas );

		return retorno;
	}

	public static string sacarCaracterEspecial ( string inicial ) {

		string saltoDeLinea = "\n";
		string reemplazoSaltoDeLinea = "|";
		string retorno = inicial.replace ( saltoDeLinea, reemplazoSaltoDeLinea );
		
		string comillas = "\"";
		string reemplazoComillas = "_";
		retorno = retorno.replace ( comillas, reemplazoComillas );

		return retorno;
	}	
}
