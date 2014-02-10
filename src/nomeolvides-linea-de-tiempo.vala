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
		
		context.set_source_rgba (1, 0, 0, 1);
		context.set_line_width (3);

		int posy = height/2;
		if ( this.hechos.length > 0 ) {
			int intervalox = (width - 20) / (int) this.hechos.length;
		
			context.move_to (10,posy);

			for (int i=0; i < this.hechos.length; i++) {
				int posx = (intervalox * (i+1))+10;
				context.line_to (posx ,posy);
				context.arc (posx, posy, 5, 0, 2 * Math.PI);
			}
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
}
