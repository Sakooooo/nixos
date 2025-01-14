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

        color: Theme.bg

        Image {
            anchors.fill: parent
            anchors.margins: 5
            source: parent.modelData.icon
        }

	QsMenuOpener {
            id: menuAnchor
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onClicked: (ev) => {
                switch (ev.button) {
                    case 1:
                        parent.modelData.activate();
                        break;
                    case 4:
                        parent.modelData.secondaryActivate();
                        break;
                    case 2:
                        console.log(parent.modelData.menu);
                        menuAnchor.menu = parent.modelData.menu;
                        menuAnchor.open();
                        break;
                }
            }
            cursorShape: Qt.PointingHandCursor
        }

    }
}
