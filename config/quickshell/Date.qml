import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io


Item {
    id: root

    width: 60

    property date currentDate: new Date()

    Item {
	width: parent.width
	height: parent.height
	/* anchors.centerIn: parent */
	Rectangle {
	    width: 60
	    height: 65
	    radius: 3
	    Text {
   		Layout.alignment: Qt.AlignHCenter
		anchors.centerIn: parent
   		font.pointSize: 20
   		color: "black"
   	    }

	}
    }
}

