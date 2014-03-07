/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * nomeolvides-linea-de-tiempo.vala
 * Copyright (C) 2014 Fernando Fernandez <fernando@softwareperonista.com.ar>
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

using Nomeolvides;
using Gtk;
using Cairo;

public class Nomeolvides.LineaDeTiempo : Gtk.DrawingArea {

	private Array<Hecho> hechos;
	private Array<int> dias_hecho;
	private int unidades;
	private Escala escala;

	private int px_por_unidad;

	// Constructor
	public LineaDeTiempo () {

		this.hechos = new Array<Hecho> ();
		this.dias_hecho = new Array<int> ();
		this.escala = Escala.DIA;
		this.px_por_unidad = 30;

		this.draw.connect (dibujar);

	}

	private bool dibujar (Context context) {
		int width = this.get_allocated_width ();
		int height = this.get_allocated_height ();
		int posx = 0;
		int posy = height/2;
		int corrimiento_x = this.px_por_unidad * 2;
		int ancho_linea = width - ( corrimiento_x * 2 );
		
		if ( this.hechos.length > 1 ) {

			context.set_source_rgba (1, 0, 0, 1);
			context.set_line_width (3);
			this.visible = true;
			context.move_to ( 0, posy );
			context.set_dash ({10, 5}, 0);
			context.line_to ( corrimiento_x, posy );
			context.stroke ();

			context.set_dash (null, 0);
			context.move_to ( corrimiento_x, posy );

			posx = ancho_linea + corrimiento_x;
			context.line_to (posx ,posy);
			context.stroke ();

			dibujar_unidad (context, posx, posy, corrimiento_x);
			//print ( "posx = %d\n", posx );
			context.stroke ();

			context.move_to (posx ,posy);
			context.set_dash ({10, 5}, 0);
			context.set_line_width (3);
			context.line_to (width ,posy);

			context.stroke ();

		} else {
			this.visible = false;
		}

		return true;
	}

	public void set_hechos ( Array<Hecho> nuevos_hechos ) {
		int i;
		
		this.hechos = new Array<Hecho> ();
		
		for (i=0; i < nuevos_hechos.length; i++) {
			this.hechos.append_val ( nuevos_hechos.index(i));
		}
		if ( i > 0 ) {  // workaround para evitar sigsev cuando recibe un array vacio
			this.visible = true;
			this.calcular_unidades ();
			this.calcular_dias_hechos ();
			this.cambiar_width ();
			this.queue_draw ();
		} else {
			this.visible = false;
		}
	}

	private void dibujar_hecho ( Context context, Hecho hecho, int x, int y ) {
		TextExtents extents;

		context.set_font_size (12);
		context.text_extents (hecho.nombre, out extents);
		double nombre_x = x - (extents.width/2 + extents.x_bearing);
		context.move_to (nombre_x, y-20);
		context.set_source_rgba (0.1, 0.1, 0.1, 1);
		context.show_text ( hecho.nombre );
		context.stroke ();

		context.set_font_size (10);
		context.text_extents (hecho.fecha_to_string(), out extents);
		double fecha_x = x - (extents.width/2 + extents.x_bearing);
		context.move_to (fecha_x, y+20);
		context.set_source_rgba (0.1, 0.1, 0.1, 1);
		context.show_text ( hecho.fecha_to_string() );
		context.stroke ();

		context.set_source_rgba (1, 0, 0, 1);
		context.arc (x, y, 5, 0, 2 * Math.PI);
		context.fill ();
		context.move_to (x, y);
	}

	private void calcular_unidades () {
		DateTime primer_dia, ultimo_dia;
		int dias;

		primer_dia = this.hechos.index(0).fecha;
		ultimo_dia = this.hechos.index( this.hechos.length - 1 ).fecha;

		dias = this.diferencia_dias ( primer_dia, ultimo_dia );

		if  ( dias < 60 ) {
			this.escala = Escala.DIA;
			this.unidades = dias;
			this.px_por_unidad = 60;
		} else {
			if ( dias < 183 ) {
				this.escala = Escala.DIA;
				this.unidades = dias;
				this.px_por_unidad = 30;
			} else {
			if ( dias < 365 ) {
					this.escala = Escala.SEMANA;
					this.unidades = dias/7;
					this.px_por_unidad = 30;
				}
			}
		}
		
	}

	private int diferencia_dias ( DateTime primer_dia, DateTime ultimo_dia ) {
		TimeSpan diferencia = ultimo_dia.difference ( primer_dia );

		int retorno = int.parse ( (diferencia / TimeSpan.DAY).to_string () );

		return retorno;
	}

	private void calcular_dias_hechos () {
		int diferencia;
		DateTime primer_hecho = this.hechos.index(0).fecha;

		this.dias_hecho = new Array<int> ();
		
		for (int i=0; i < this.hechos.length; i++) {
			diferencia = this.diferencia_dias ( primer_hecho, this.hechos.index(i).fecha );
			this.dias_hecho.append_val ( diferencia );
			//print ( "Hecho %d:\n\tNombre:%s\n\tFecha:%s\n\tDiferencia con el primero:%s\n", i, this.hechos.index(i).nombre, this.hechos.index(i).fecha_to_string(), diferencia.to_string() );
		}
	}

	private void cambiar_width () {
		this.width_request = (this.unidades + 4 ) * this.px_por_unidad;
		//print ( this.unidades.to_string() + " Dias > " + ((this.unidades + 4 ) * this.px_por_unidad).to_string() + "px\n");
	}

	private void dibujar_referencia (Context context, int posx, int posy) {
		context.set_source_rgba (1, 0, 0, 1);
		context.set_line_width (1);
		context.move_to (posx, posy - 5);
		context.line_to (posx, posy + 5);
		context.stroke ();
	}


	private void dibujar_unidad (Context context, int posx, int posy, int corrimiento_x) {
		switch (this.escala) {
			case Escala.DIA:
				dibujar_dias (context, posx, posy, corrimiento_x);
				break;
			case Escala.SEMANA:
				dibujar_semanas (context, posx, posy, corrimiento_x);
				break;
		}
	}

	private void dibujar_dias (Context context, int posx, int posy, int corrimiento_x) {
		int i=0,j;
		DateTime dia_a_dibujar =  this.hechos.index(0).fecha;
		DateTime ultimo_dia = this.hechos.index( this.hechos.length - 1 ).fecha;

		while ( dia_a_dibujar.compare (ultimo_dia) < 1 ) {
			//print (dia_a_dibujar.to_string () + "\n");
			posx = (i * this.px_por_unidad) + corrimiento_x;
			for (j=0; j < this.hechos.length; j++) {
				if ( i == this.dias_hecho.index (j) ) {
					//print ( "hecho %d: (( %d * %d ) / %d) + %d = %d\n", i, this.dias_hecho.index (i), ancho_linea,  this.unidades, corrimiento_x, posx);
					this.dibujar_hecho (context, this.hechos.index (j), posx, posy);
				} else {
					this.dibujar_referencia (context, posx, posy);
				}
			}
			i++;
			dia_a_dibujar = dia_a_dibujar.add ( TimeSpan.DAY );
		}
	}

		private void dibujar_semanas (Context context, int posx, int posy, int corrimiento_x) {
		int i=0,j;
		DateTime dia_a_dibujar =  this.hechos.index(0).fecha;
		DateTime ultimo_dia = this.hechos.index( this.hechos.length - 1 ).fecha;

		while ( dia_a_dibujar.compare (ultimo_dia) < 1 ) {
			//print (dia_a_dibujar.to_string () + "\n");

			for (j=0; j < this.hechos.length; j++) {
				if ( i == this.dias_hecho.index (j) ) {
					posx = ((i * this.unidades * this.px_por_unidad) / this.dias_hecho.index ( this.hechos.length - 1 )) + corrimiento_x;
					//print ( "((%d * %d * %d) / %d) + %d)\n", i, this.unidades, this.px_por_unidad, this.dias_hecho.index ( this.hechos.length - 1 ), corrimiento_x);
					//print ( "hecho %d: (( %d * %d ) / %d) + %d = %d\n", i, this.dias_hecho.index (i), ancho_linea,  this.unidades, corrimiento_x, posx);
					this.dibujar_hecho (context, this.hechos.index (j), posx, posy);
				}
			}
			if ( dia_a_dibujar.get_day_of_week () == 1 ) { // 1 = Lunes
						posx = (i/7 * this.px_por_unidad) + corrimiento_x;
						this.dibujar_referencia (context, posx, posy);
			}
			i++;
			dia_a_dibujar = dia_a_dibujar.add ( TimeSpan.DAY );
		}
	}

	private enum Escala {
		DIA,
		SEMANA,
		ANIO
	}
}
