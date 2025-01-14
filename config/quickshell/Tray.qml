import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Repeater {
    id: repeater

    model: SystemTray.items

    Rectangle {
        required property SystemTrayItem modelData

        Layout.preferredWidth: height
        Layout.fillHeight: true
        onHeightChanged: {
            width = height
        }

        Image {
            anchors.fill: parent
            anchors.margins: 5
            source: parent.modelData.icon
        }

	QsMenuOpener {
	    id: openthing
	}

	QsMenuAnchor {
	    id: opener
	    /* anchor.window: root */
	}

	MouseArea {
	    anchors.fill: parent
	    acceptedButtons: Qt.LeftButton | Qt.RightButton
	    onClicked: (event) => {
		switch (event.button) {
		case Qt.LeftButton:
		    parent.modelData.activate();
		    break;
		case Qt.RightButton:
		    opener.menu = parent.modelData.menu;
		    opener.open();
		    break;
		}
	    }
	}
    }
}
