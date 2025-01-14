import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

Item {
    id: root

    height: 40
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
   		text: {
   		    const hours = clock.hours.toString().padStart(2, '0')
   		    const minutes = clock.minutes.toString().padStart(2, '0')
   		    return `${hours} ${minutes}`
   		}
   		font.pointSize: 15
   		color: "black"
   	    }

	}
	
    }
}
