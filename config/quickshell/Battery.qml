import QtQuick
import Quickshell.Services.UPower

Item {
    id: battery
    
    readonly property var chargeState: UPower.displayDevice.state
    readonly property bool isCharging: chargeState == UPowerDeviceState.Charging;
    readonly property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge;
    readonly property real percentage: UPower.displayDevice.percentage
    readonly property bool isLow: percentage <= 0.2
    
    Text {
	color: isCharging ? "#00FF00" : isLow ? "#FF0000" : "#FFFFFF"
	text: percentage * 100
    }
}
