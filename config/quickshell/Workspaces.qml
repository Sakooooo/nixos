import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Repeater {
    id: repeater

    model: Hyprland.workspaces.values.map(ws => ws.id)
    property list<HyprlandWorkspace> workspaces: HyprlandIO.sortedworkspaces
}
