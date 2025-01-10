import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

ListView {
    id: root

    height: 70
    width: 60
    SystemClock {
	id: clock
	precision: SystemClock.Minutes
    }

    Item {
	width: parent.width
	height: parent.height
	anchors.centerIn: parent

	Rectangle {
	    width: 60
	    height: 60
	    radius: 3
	    anchors.centerIn: parent
	    Text {
   		Layout.alignment: Qt.AlignHCenter
		anchors.centerIn: parent
   		text: {
   		    const hours = clock.hours.toString().padStart(2, '0')
   		    const minutes = clock.minutes.toString().padStart(2, '0')
   		    return `${hours}\n${minutes}`
   		}
   		font.pointSize: 20
   		color: "black"
   	    }

	}
	
    }
}
