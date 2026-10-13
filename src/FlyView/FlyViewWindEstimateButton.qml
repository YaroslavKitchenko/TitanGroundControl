import QGroundControl
import QGroundControl.FlyView

ToolStripAction {
    id:         action
    text:       qsTr("Wind")
    iconSource: "/res/wind-rose.svg"
    visible:    _windAvailable

    property var   _activeVehicle:  QGroundControl.multiVehicleManager.activeVehicle
    property bool  _windAvailable:  _activeVehicle !== null

    dropPanelComponent: Component {
        FlyViewWindEstimateDropPanel {
        }
    }
}
