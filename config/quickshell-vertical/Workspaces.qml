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
    height: 135
    width: 60
    spacing: 5
    interactive: false
    delegate: Item {
	width: Math.max((modelData.active) ? 70 : 40, 70)
	height: 10
	Rectangle {
	    id: workspace
	    width: (modelData.active) ? 60 : 45
	    height: 10
	    radius: height / 2
	    border.width: 2
	    color: (modelData.active) ? "#0099DD" : (modelData.visible) ? "#227722" : "#222222"
	    /* border.color: (modelData.active) ? "#AACCFF" : (modelData.visible) ? "#3399FF" : "#FFFFFF" */
	    border.color: "#999999"
            anchors.centerIn: parent
	}
	MouseArea {
	    id: mouseArea
	    anchors.fill: parent
	    hoverEnabled: true
	    onClicked: {
		Hyprland.dispatch("workspace " + modelData.id)
	    }
	}
	states: State {
	    name: "hovered"; when: (mouseArea.containsMouse && !modelData.active)

	    PropertyChanges {
		target: workspace
		height: 10
		width: 50
	    }
	}
    }
}
