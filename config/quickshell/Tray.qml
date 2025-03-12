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

        Layout.preferredWidth: parent.height
        Layout.fillHeight: true
	Layout.fillWidth: true
	height: parent.height
        onHeightChanged: {
            width = height
        }

        Image {
	    id: hi
            anchors.fill: parent
            anchors.margins: 2
            source: parent.modelData.icon
        }

	QsMenuAnchor {
	    id: opener
	    anchor.window: bar
            anchor {
		rect.x: 0
		rect.y: 0
		onAnchoring: {
		    if (anchor.window) {
			let coords = anchor.window.contentItem.mapFromItem(itemRect, 0, 0);
			anchor.rect.x = coords.x;
			anchor.rect.y = coords.y + 6;
		    }
		}
		rect.width: hi.width
		rect.height: hi.height
		gravity: Edges.Bottom
		edges: Edges.Bottom
		adjustment: PopupAdjustment.SlideY
            }
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
