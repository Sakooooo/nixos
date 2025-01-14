import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { Variable } from "astal"

const time = Variable("").poll(1000, "date")

export default function Bar(monitor: Gdk.Monitor) {
  const anchor = Astal.WindowAnchor.BOTTOM
    | Astal.WindowAnchor.LEFT
    | Astal.WindowAnchor.RIGHT

      return <window
      className="Bar"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
						   anchor={anchor}>
           <centerbox>
             <box hexpand halign={Gtk.Align.START}>
	       <button
		 onClicked="echo hello"
		 halign={Gtk.Align.CENTER} >
					      Welcome to AGS!
               </button>
             </box>
             <box>
             </box>
             <box className="right" hexpand halign={Gtk.Align.END} >
	       <button
                 onClick={() => print("hello")}
                 halign={Gtk.Align.CENTER} >
                 <label label={time()} />
               </button>
             </box>
           </centerbox>
	 </window>
}
