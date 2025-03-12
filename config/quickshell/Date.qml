import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io


Item {
    id: root

    width: 60
    height: bar.height

    property string time;
    Process {
	id: dateProc
	command: ["date", "+%d/%m"]
	running: true

	stdout: SplitParser {
	    // update the property instead of the clock directly
	    onRead: data => root.time = data
	}
    }

    Timer {
	interval: 86400000
	running: true
	repeat: true
	onTriggered: dateProc.running = true
    }

    Item {
	width: parent.width
	height: parent.height
	anchors.centerIn: parent
	Rectangle {
	    width: 70
	    height: parent.height
	    /* radius: 3 */
	    anchors.centerIn: parent
	    Text {
   		Layout.alignment: Qt.AlignHCenter
		anchors.centerIn: parent
   		font.pointSize: 13
   		color: "black"
		text: time
   	    }

	}
    }
}

