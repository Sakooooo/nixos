import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
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
	property var modelData
	
        property var workspaceArray: Array.from({ length: 10 }, (_, i) => ({
            id: i + 1,
            text: i + 1,
            visible: Hyprland.workspaces.values.some(e => e.id === i + 1),
            active: Hyprland.focusedMonitor.activeWorkspace.id === i + 1 
        }))


      width: 70
      color: "#222222"
      screen: modelData


	margins {
	    top: 10
	    bottom: 10
	    left: 10
	}
	
      anchors {
	  top: true;
          bottom: true;
          left: true;
          /* right: true; */
      }

	height: 30;

	// top
	ColumnLayout {
	    /* anchors.left: parent.left */
	    anchors.top: parent.top
	    /* anchors.bottom: parent.bottom */
	    anchors.topMargin: 5;
	    spacing: 5

	    Workspaces {}

	}

	// Center
	ColumnLayout {
	/*     anchors.centerIn: parent */
	/*     Text { */
	/* 	color: "#FFFFFF" */
        /* // now just time instead of root.time */
        /*         text: time */
        /*     } */

	}
	
	// bottom
	ColumnLayout {
	    anchors.bottom: parent.bottom
	    anchors.horizontalCenter: parent.horizontalCenter
	    spacing: 15

	    Tray {}
	    Battery { }
	    /* Date {} */
	    Time {}
	}

    }
  }

  /* Process { */
  /*   id: dateProc */
  /*   command: ["date", "+%m %d"] */
  /*   running: true */

  /*   stdout: SplitParser { */
  /*     // now just time instead of root.time */
  /*     onRead: data => time = data */
  /*   } */
  /* } */

  /* Timer { */
  /*   interval: 1000 */
  /*   running: true */
  /*   repeat: true */
  /*   /\* onTriggered: dateProc.running = true *\/ */
  /* } */
}

