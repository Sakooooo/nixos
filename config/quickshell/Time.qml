import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

Item {
    id: root

    height: bar.height
    width: 20
    SystemClock {
	id: clock
	precision: SystemClock.Minutes
    }

    Item {
	width: parent.width
	height: parent.height

	Rectangle {
	    width: 70
	    /* height: 30 */
	    height: parent.height
	    /* radius: 3 */
	    Text {
   		Layout.alignment: Qt.AlignHCenter
		anchors.centerIn: parent
		text: Qt.formatDateTime(clock.date, "hh:mm")
   		font.pointSize: 13
   		color: "black"
   	    }

	}
	
    }
}
