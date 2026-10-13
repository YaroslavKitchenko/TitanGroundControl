import QGroundControl
import QGroundControl.FlyView

ToolStripAction {
    id:         action
    text:       qsTr("Aux Func")
    iconSource: "/res/AdvancedSliders.svg"
    visible:    _auxAvailable

    property var   _activeVehicle:  QGroundControl.multiVehicleManager.activeVehicle
    property bool  _auxAvailable:   _activeVehicle !== null

    dropPanelComponent: Component {
        FlyViewAuxFunctionDropPanel {
        }
    }
}
