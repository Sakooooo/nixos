//@ pragma UseQApplication
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

// thanks ImNotTwig for giving me your shell.qml as reference

ShellRoot {
    
  id: root

  ReloadPopup {}
  property string time;

  Variants {
    model: Quickshell.screens

      PanelWindow {
	  id: bar
	property var modelData
	
        property var workspaceArray: Array.from({ length: 10 }, (_, i) => ({
            id: i + 1,
            text: i + 1,
            visible: Hyprland.workspaces.values.some(e => e.id === i + 1),
            active: Hyprland.focusedMonitor.activeWorkspace.id === i + 1 
        }))


      color: "#222222"
      screen: modelData


	/* margins { */
	/*     top: 10 */
	/*     /\* bottom: 10 *\/ */
	/*     left: 10 */
	/*     right: 10 */
	/* } */
	
      anchors {
	  /* top: true; */
          bottom: true;
          left: true;
          right: true;
      }

	height: 25;

	// left
	RowLayout {
	    anchors.left: parent.left
	    /* anchors.top: parent.top */
	    /* anchors.bottom: parent.bottom */
	    /* spacing: 5 */
	    anchors.verticalCenter: parent.verticalCenter

	    Workspaces {}

	}

	// Center
	RowLayout {
	/*     anchors.centerIn: parent */
	/*     Text { */
	/* 	color: "#FFFFFF" */
        /* // now just time instead of root.time */
        /*         text: time */
        /*     } */

	}
	
	// right
	RowLayout {
	    /* anchors.bottom: parent.bottom */
	    /* anchors.horizontalCenter: parent.horizontalCenter */
	    anchors.right: parent.right
	    anchors.rightMargin: 50;
	    spacing: 10


	    Tray {}
	    Battery {}
	    Date {}
	    Time {}
	}

    }
  }
}

