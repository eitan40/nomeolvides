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
	private int total_dias;

	// Constructor
		public LineaDeTiempo () {

		this.hechos = new Array<Hecho> ();
		this.dias_hecho = new Array<int> ();

		this.draw.connect (dibujar);

	}

	private bool dibujar (Context context) {
		int width = this.get_allocated_width ();
		int height = this.get_allocated_height ();
		int posx;
		int i;
		int posy = height/2;
		int corrimiento_x = width / 10;
		int ancho_linea = width - ( corrimiento_x * 2 );
		
		context.set_source_rgba (1, 0, 0, 1);
		context.set_line_width (3);

		if ( this.hechos.length > 1 ) {

			this.visible = true;
			context.move_to ( 0, posy );
			context.line_to ( corrimiento_x, posy );

			for (i=0; i < this.hechos.length; i++) {
				posx = ( ( this.dias_hecho.index (i) * ancho_linea ) / this.total_dias ) + corrimiento_x;
				//print ( "hecho %d: (( %d * %d ) / %d) + %d = %d\n", i, this.dias_hecho.index (i), ancho_linea,  this.total_dias, corrimiento_x, posx);
				context.line_to (posx ,posy);
				this.dibujar_hecho (context, this.hechos.index (i), posx, posy);
			}
			print ( "\n" );
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
			this.calcular_total_dias ();
			this.calcular_dias_hechos ();
			this.queue_draw ();
		} else {
			this.visible = false;
		}
	}

	private void dibujar_hecho ( Context context, Hecho hecho, int x, int y ) {
		TextExtents extents;

		context.arc (x, y, 5, 0, 2 * Math.PI);

		context.set_font_size (15);
		context.text_extents (hecho.nombre, out extents);
		double nombre_x = x - (extents.width/2 + extents.x_bearing);
		context.move_to (nombre_x, y-20);
		context.set_source_rgba (0.1, 0.1, 0.1, 1);
		context.show_text ( hecho.nombre );

		context.move_to (x, y);
		context.set_source_rgba (1, 0, 0, 1);
	}

	private void calcular_total_dias () {
		DateTime primer_dia, ultimo_dia;

		primer_dia = this.hechos.index(0).fecha;
		ultimo_dia = this.hechos.index( this.hechos.length - 1 ).fecha;

		this.total_dias = this.diferencia_dias ( primer_dia, ultimo_dia );
		
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
}
