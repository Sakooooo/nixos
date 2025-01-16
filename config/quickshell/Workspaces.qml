import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Repeater {
    id: workspaces
    property var workspaceArray: Array.from({ length: 10}, (_, i) => ({
	id: i + 1,
	text: i + 1,
	visible: Hyprland.workspaces.values.some(e => e.id === i + 1),
	active: Hyprland.focusedMonitor.activeWorkspace.id === i + 1
    }))
    model: workspaceArray
    Rectangle {
	height: 30
	width: 30
	color: (modelData.active) ? "#0099DD" : (modelData.visible) ? "#227722" : "#FFFFFF"
	Text {
	    text: modelData.text
	    anchors.centerIn: parent
	    color: "#000000"
	}
    }
}
