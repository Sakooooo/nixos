import QuickShell.Hyprland
import QtQuick
import QtQuick.Layouts


ColumnLayout {
    property int workspaceCount: 10;
    
    id: workspaces
    spacing: 0
    anchors {
	fill: parent;
	topMargin: 0;
	margins: 5;
    }
}
