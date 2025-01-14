import QtQuick
import Quickshell.Services.UPower

Item {
    id: battery
    width: 50
    
    readonly property var chargeState: UPower.displayDevice.state
    readonly property bool isCharging: chargeState == UPowerDeviceState.Charging;
    readonly property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge;
    readonly property real percentage: UPower.displayDevice.percentage
    readonly property bool isLow: percentage <= 0.2

    visible: (chargeState)
    /* visible: false */

    Text {
	color: isCharging ? "#00FF00" : isLow ? "#FF0000" : "#FFFFFF"
	text: Math.floor(percentage * 100)
    }
}
