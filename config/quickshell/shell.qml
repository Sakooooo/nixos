import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

// thanks ImNotTwig for giving me your shell.qml as reference

ShellRoot {

  ReloadPopup {}
  property string time;

  Variants {
    model: Quickshell.screens

    PanelWindow {
	property var modelData
	property var workspaceArray: Array.from({ length: 7 }, (_, i) => ({
                id: i + 1,
                text: getWorkspaceIcon((i + 1)),
                visible: Hyprland.workspaces.values.some(e => e.id === i + 1),
                active: Hyprland.focusedMonitor.activeWorkspace.id === i + 1
        }))

      screen: modelData

      anchors {
          bottom: true;
          left: true;
          right: true;
      }

	height: 30;

	// left
	RowLayout {
	    anchors.left: parent.left
	    anchors.top: parent.top
	    anchors.bottom: parent.bottom
	    spacing: 5

	    Text {
		text: "Left side"
	    }
	}

	// Center
	RowLayout {
	    anchors.centerIn: parent
	    Text {
        // now just time instead of root.time
                text: time
            }

	}
	
	// right
	RowLayout {
	    anchors.right: parent.right
	    anchors.top: parent.top
	    anchors.bottom: parent.bottom
	    spacing: 5

	    Text {
		text: "Right side"
	    }
	}

    }
  }

  Process {
    id: dateProc
    command: ["date"]
    running: true

    stdout: SplitParser {
      // now just time instead of root.time
      onRead: data => time = data
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }
}

