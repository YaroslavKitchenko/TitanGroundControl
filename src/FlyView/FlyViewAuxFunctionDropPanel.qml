import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCore

import QGroundControl
import QGroundControl.Controls

ColumnLayout {
    id: _root
    spacing: ScreenTools.defaultFontPixelHeight * 0.4

    property var   _activeVehicle:      QGroundControl.multiVehicleManager.activeVehicle
    property var   _lastSlotPositions:  ({0: -1, 1: -1, 2: -1, 3: -1, 4: -1, 5: -1, 6: -1, 7: -1})
    property string _lastCommandStatus: ""
    property int   _settingsRevision:   0

    readonly property var auxFunctionList: [
        { text: qsTr("Do Nothing"),           value: 0 },
        { text: qsTr("EKF Source Set"),       value: 90 },
        { text: qsTr("GPS Disable"),          value: 65 },
        { text: qsTr("Retract Mount 1"),      value: 27 },
        { text: qsTr("Retract Mount 2"),      value: 113 },
        { text: qsTr("Camera Trigger"),       value: 9 },
        { text: qsTr("Camera Rec Video"),     value: 166 },
        { text: qsTr("Camera Zoom"),          value: 167 },
        { text: qsTr("Mount Lock"),           value: 163 },
        { text: qsTr("Arm / Disarm"),         value: 153 },
        { text: qsTr("Motor E-Stop"),         value: 31 },
        { text: qsTr("Motor Interlock"),      value: 32 },
        { text: qsTr("Landing Gear"),         value: 29 },
        { text: qsTr("Parachute Release"),    value: 22 },
        { text: qsTr("Relay 1"),              value: 28 },
        { text: qsTr("Relay 2"),              value: 34 },
        { text: qsTr("Relay 3"),              value: 35 },
        { text: qsTr("Relay 4"),              value: 36 },
        { text: qsTr("Terrain Disable"),      value: 86 },
        { text: qsTr("Crow Select"),          value: 87 },
        { text: qsTr("Flaps"),                value: 208 },
        { text: qsTr("Airbrake"),             value: 210 },
        { text: qsTr("Lost Vehicle Sound"),   value: 30 },
        { text: qsTr("Brake Mode"),           value: 33 },
        { text: qsTr("RTL Mode"),             value: 4 },
        { text: qsTr("Smart RTL"),            value: 42 },
        { text: qsTr("QRTL Mode"),            value: 108 },
        { text: qsTr("Auto Mode"),            value: 16 },
        { text: qsTr("Manual Mode"),          value: 51 },
        { text: qsTr("FBWA Mode"),            value: 92 },
        { text: qsTr("Cruise Mode"),          value: 150 },
        { text: qsTr("Loiter Mode"),          value: 56 },
        { text: qsTr("Takeoff"),              value: 77 },
        { text: qsTr("Land Mode"),            value: 18 },
        { text: qsTr("GPS Disable Yaw"),      value: 105 },
        { text: qsTr("EKF Lane Switch"),      value: 103 },
        { text: qsTr("EKF Yaw Reset"),        value: 104 },
        { text: qsTr("Disable Airspeed Use"), value: 106 },
        { text: qsTr("Compass Learn"),        value: 62 },
        { text: qsTr("Soaring"),              value: 88 },
        { text: qsTr("Winch Enable"),         value: 44 },
        { text: qsTr("Winch Control"),        value: 45 },
        { text: qsTr("User Func 1"),          value: 47 },
        { text: qsTr("User Func 2"),          value: 48 },
        { text: qsTr("User Func 3"),          value: 49 }
    ]

    Settings {
        id: auxSettings
        category: "FlyViewAuxFunctions_v2"
        property int slot0: 0
        property int slot1: 0
        property int slot2: 0
        property int slot3: 0
        property int slot4: 0
        property int slot5: 0
        property int slot6: 0
        property int slot7: 0
    }

    function getSlotFunc(index) {
        switch (index) {
        case 0: return auxSettings.slot0
        case 1: return auxSettings.slot1
        case 2: return auxSettings.slot2
        case 3: return auxSettings.slot3
        case 4: return auxSettings.slot4
        case 5: return auxSettings.slot5
        case 6: return auxSettings.slot6
        case 7: return auxSettings.slot7
        default: return 0
        }
    }

    function setSlotFunc(index, val) {
        switch (index) {
        case 0: auxSettings.slot0 = val; break
        case 1: auxSettings.slot1 = val; break
        case 2: auxSettings.slot2 = val; break
        case 3: auxSettings.slot3 = val; break
        case 4: auxSettings.slot4 = val; break
        case 5: auxSettings.slot5 = val; break
        case 6: auxSettings.slot6 = val; break
        case 7: auxSettings.slot7 = val; break
        }
        _settingsRevision++
    }

    function findIndexForValue(val) {
        for (var i = 0; i < auxFunctionList.length; i++) {
            if (auxFunctionList[i].value === val) {
                return i
            }
        }
        return 0
    }

    QGCPalette { id: qgcPal }

    // Header
    QGCLabel {
        text: qsTr("Aux Functions")
        font.pointSize: ScreenTools.mediumFontPointSize
        font.bold: true
        Layout.fillWidth: true
    }

    // Status label
    QGCLabel {
        Layout.fillWidth: true
        text: _lastCommandStatus !== "" ? _lastCommandStatus : qsTr("Select function & switch position")
        font.pointSize: ScreenTools.smallFontPointSize
        color: _lastCommandStatus !== "" ? qgcPal.colorOrange : qgcPal.text
        elide: Text.ElideRight
    }

    // Separator
    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: qgcPal.groupBorder
    }

    // Slot Rows
    Repeater {
        model: 8

        RowLayout {
            id: slotRow
            property int slotIndex: index
            spacing: ScreenTools.defaultFontPixelWidth * 0.5

            QGCComboBox {
                id: combo
                Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 16
                Layout.preferredHeight: ScreenTools.implicitButtonHeight
                model: auxFunctionList
                textRole: "text"
                valueRole: "value"
                currentIndex: {
                    var _ = _settingsRevision
                    return findIndexForValue(getSlotFunc(slotIndex))
                }
                onActivated: (comboIndex) => {
                    setSlotFunc(slotIndex, auxFunctionList[comboIndex].value)
                }
            }

            Repeater {
                model: [
                    { label: qsTr("Low"),  pos: 0 },
                    { label: qsTr("Mid"),  pos: 1 },
                    { label: qsTr("High"), pos: 2 }
                ]

                QGCButton {
                    id: switchBtn
                    Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 6.0
                    Layout.preferredHeight: ScreenTools.implicitButtonHeight
                    text: modelData.label
                    enabled: _activeVehicle !== null
                    leftPadding: 0
                    rightPadding: 0
                    topPadding: 0
                    bottomPadding: 0

                    property int switchPos: modelData.pos
                    property bool isSelected: _lastSlotPositions[slotIndex] === switchPos

                    backgroundColor: isSelected ? qgcPal.colorOrange : qgcPal.button
                    textColor: isSelected ? qgcPal.buttonHighlightText : qgcPal.buttonText

                    contentItem: QGCLabel {
                        text: switchBtn.text
                        font.pointSize: ScreenTools.smallFontPointSize
                        font.bold: switchBtn.isSelected
                        color: switchBtn.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        if (_activeVehicle) {
                            var funcId = getSlotFunc(slotIndex)
                            _activeVehicle.sendDoAuxFunction(funcId, switchPos)
                            var newPos = Object.assign({}, _lastSlotPositions)
                            newPos[slotIndex] = switchPos
                            _lastSlotPositions = newPos
                            _lastCommandStatus = qsTr("Sent: %1 -> %2").arg(combo.currentText).arg(modelData.label)
                        }
                    }
                }
            }
        }
    }
}
