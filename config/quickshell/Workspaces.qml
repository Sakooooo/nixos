import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

ListView {
    id: workspaceList
    property var workspaceArray: Array.from({ length: 10}, (_, i) => ({
	id: i + 1,
	text: i + 1,
	visible: Hyprland.workspaces.values.some(e => e.id === i + 1),
	active: Hyprland.focusedMonitor.activeWorkspace.id === i + 1
    }))

    model: workspaceArray
    anchors.top: parent.top
    anchors.centerIn: parent
    height: 500
    width: 60
    spacing: 2
    delegate: Item {
	width: Math.max((modelData.active) ? 50 : 40, 50)
	height: 10
	Rectangle {
	    id: workspace
	    width: (modelData.active) ? 50 : 40
	    height: 10
	    radius: height / 2
	    border.width: 1
	    border.color: (modelData.active) ? "#FFF8C8DC" : (modelData.visible) ? "#3399FF" : "#FFFFFF"
            anchors.centerIn: parent
	}
    }
}
