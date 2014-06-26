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

public class Nomeolvides.Hecho : Nomeolvides.Base {
	public string descripcion { get; private set; }
	public DateTime fecha {get; private set; }
	public int64 coleccion;
	public string fuente { get; private set; }
	public Array<Etiqueta> etiquetas;

	// Constructor
	public Hecho ( string nombre, string descripcion, int anio, int mes, int dia, int64 coleccion, string fuente = "" )
	{
		base ( nombre );
		this.descripcion = Utiles.ponerCaracterEspecial ( descripcion );
		this.fecha = new DateTime.utc (anio, mes, dia, 0,0,0);
		this.coleccion = coleccion;
		this.fuente = Utiles.ponerCaracterEspecial ( fuente );
		this.etiquetas = new Array<Etiqueta> ();
		this.hash = Utiles.calcular_checksum ( this.a_json () );
	}

	public Hecho.json (string json, int64 coleccion ) {
		base.vacio();
		if ( !json.contains ( "{\"Hecho\":{" ) ) {
			this.nombre = "null";
			this.descripcion = "null";
			this.fecha = new DateTime.utc ( 2013,2,20,0,0,0 );
			this.fuente = "null";
		} else {
			this.nombre = Utiles.ponerCaracterEspecial ( Utiles.sacarDatoJson ( json, "nombre" ) );
			this.descripcion = Utiles.ponerCaracterEspecial ( Utiles.sacarDatoJson ( json, "descripcion" ) );
			this.fecha = new DateTime.utc (int.parse ( Utiles.sacarDatoJson( json, "anio" ) ),
			                               int.parse ( Utiles.sacarDatoJson( json, "mes" ) ),
			                               int.parse ( Utiles.sacarDatoJson( json, "dia" ) ),
			                     		   0,0,0);
			this.fuente = Utiles.ponerCaracterEspecial ( Utiles.sacarDatoJson ( json, "fuente" ) );
		}	
		this.hash = Utiles.calcular_checksum ( this.a_json () );

		this.coleccion = coleccion;
	}

	public void set_etiquetas ( Array<Etiqueta> etiquetas ) {
		for ( int i = 0; i < etiquetas.length; i++ ) {
			this.etiquetas.append_val ( etiquetas.index ( i ) );
		}
	}

	public new string a_json () {
		var retorno = "{\"Hecho\":{";
		retorno += base.a_json () + ",";
		retorno += "\"descripcion\":\"" + Utiles.sacarCaracterEspecial( this.descripcion ) + "\",";
		retorno += "\"anio\":\"" + this.fecha.get_year ().to_string () + "\",";
		retorno += "\"mes\":\"" + this.fecha.get_month ().to_string () + "\",";
		retorno += "\"dia\":\"" + this.fecha.get_day_of_month ().to_string () + "\",";
		retorno += "\"fuente\":\"" + Utiles.sacarCaracterEspecial( this.fuente ) + "\",";
		retorno += "\"coleccion\":\"" + this.coleccion.to_string () + "\"";

		retorno +="}}";	
		
		return retorno;
	}

	public new string to_string () {
		var retorno  = base.to_string () + ",";
		retorno += "\"" + this.descripcion + "\",";
		retorno += "\"" + this.fecha.get_year ().to_string () + "\",";
		retorno += "\"" + this.fecha.get_month ().to_string () + "\",";
		retorno += "\"" + this.fecha.get_day_of_month ().to_string () + "\",";
		retorno += "\"" + this.fuente + "\",";
		retorno += "\"" + this.coleccion.to_string () + "\"";

		return retorno;
	}

	public new string a_sql () {
		var retorno  = base.a_sql () + ",";
		retorno += "descripcion=\"" + Utiles.sacarCaracterEspecial( this.descripcion ) + "\",";
		retorno += "anio=\"" + this.fecha.get_year ().to_string () + "\",";
		retorno += "mes=\"" + this.fecha.get_month ().to_string () + "\",";
		retorno += "dia=\"" + this.fecha.get_day_of_month ().to_string () + "\",";
		retorno += "fuente=\"" + Utiles.sacarCaracterEspecial( this.fuente ) + "\",";
		retorno += "coleccion=\"" + this.coleccion.to_string () + "\"";
		
		return retorno;
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
}
