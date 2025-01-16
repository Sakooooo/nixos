import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Repeater {
    id: repeater

    model: SystemTray.items

    Rectangle {
	id: itemRect
        required property SystemTrayItem modelData

        Layout.preferredWidth: height
        Layout.fillHeight: true
        onHeightChanged: {
            width = height
        }

        Image {
	    id: hi
            anchors.fill: parent
            anchors.margins: 5
            source: parent.modelData.icon
        }

	QsMenuAnchor {
	    id: opener
	    anchor.window: bar
	    anchor.onAnchoring: {
                this.anchor.rect.x = parent.mapToItem(repeater.parent.contentItem, 0, 0).x
            }
	    anchor.rect.width: parent.width
            anchor.rect.height: parent.height
            anchor.edges: Edges.Top
            anchor.gravity: Edges.Top
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
