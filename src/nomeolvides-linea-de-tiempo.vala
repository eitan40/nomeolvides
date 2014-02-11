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

	// Constructor
		public LineaDeTiempo () {

		this.hechos = new Array<Hecho> ();

		this.draw.connect (dibujar);

	}

	private bool dibujar (Context context) {
		int width = this.get_allocated_width ();
		int height = this.get_allocated_height ();
		int posx;
		int i;

		context.set_source_rgba (1, 0, 0, 1);
		context.set_line_width (3);

		int posy = height/2;
		if ( this.hechos.length > 0 ) {
			int intervalox = (width - 50) / (int) this.hechos.length+1;

			posx = 25;
			context.move_to (0,posy);
			context.line_to (posx ,posy);

			for (i=0; i < this.hechos.length; i++) {
				if (i != 0 ) {
					posx += intervalox;
				}
				context.line_to (posx ,posy);
				this.dibujar_hecho (context, this.hechos.index (i), posx, posy);
			}

			context.line_to (width ,posy);

			context.stroke ();
		}

		return true;
	}

	public void set_hechos ( Array<Hecho> nuevos_hechos ) {
		this.hechos = new Array<Hecho> ();
		for (int i=0; i < nuevos_hechos.length; i++) {
			this.hechos.append_val ( nuevos_hechos.index(i));
		}
		this.queue_draw ();
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
}
