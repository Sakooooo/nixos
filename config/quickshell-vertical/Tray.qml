import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.SystemTray

ListView {
    id: trayMenu
    model: SystemTray.Items;
    Item {
	id: trayItem
	Layout.fillWidth: true
    }
}
