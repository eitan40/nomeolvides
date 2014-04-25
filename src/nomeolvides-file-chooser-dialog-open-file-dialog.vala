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

using Gtk;
using Nomeolvides;

public class Nomeolvides.OpenFileDialog : FileChooserDialog {

    private string ultimo_directorio;
	protected Button boton_abrir;

    public OpenFileDialog (string directorio_actual) {
        this.title = _("Choose File");
        this.action = FileChooserAction.OPEN;
		this.set_current_folder (directorio_actual);

        add_button ( _("Cancel"), ResponseType.CANCEL);
        this.boton_abrir = add_button ( _("Open"), ResponseType.ACCEPT) as Button;
        set_default_response (ResponseType.ACCEPT);

        if (this.ultimo_directorio != null) {
            set_current_folder (this.ultimo_directorio);
        }
    }

    public override void response (int type) {
        if (type == ResponseType.ACCEPT) {
            this.ultimo_directorio = get_current_folder ();
        }
    }
}
