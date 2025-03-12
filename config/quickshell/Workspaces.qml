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
	id: workspace
	height: 25
	width: 25
	color: (modelData.active) ? "#0099DD" : (modelData.visible) ? "#227722" : "#AAAAAA"

	MouseArea {
	    id: button
	    anchors.fill: parent
	    hoverEnabled: true
	    onClicked: {
		Hyprland.dispatch("workspace " + modelData.id)
	    }
	}

	states: State {
	    name: "hovered"; when: (button.containsMouse && !modelData.active)

	    PropertyChanges {
		target: workspace
		color: "#FFFFFF"
	    }
	}

	transitions: Transition {
	    ColorAnimation {
		duration: 500
	    }
	}
	
	Text {
	    text: modelData.text
	    anchors.centerIn: parent
	    color: "#000000"
	}
    }
}
