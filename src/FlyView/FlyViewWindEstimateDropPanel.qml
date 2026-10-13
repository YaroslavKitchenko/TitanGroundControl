import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCore

import QGroundControl
import QGroundControl.Controls

ColumnLayout {
    id: _root
    spacing: ScreenTools.defaultFontPixelHeight * 0.4

    readonly property real panelWidth: ScreenTools.defaultFontPixelWidth * 36
    implicitWidth: panelWidth
    width: panelWidth

    property var   _activeVehicle:      QGroundControl.multiVehicleManager.activeVehicle
    property string _lastCommandStatus: ""

    QGCPalette { id: qgcPal }

    Settings {
        id: windSettings
        category: "FlyViewWindEstimate"
        property real speed: 5.0
        property real direction: 0.0
    }

    function getCardinalDirection(heading) {
        var deg = ((Math.round(heading) % 360) + 360) % 360
        var directions = [
            qsTr("N"),
            qsTr("NNE"),
            qsTr("NE"),
            qsTr("ENE"),
            qsTr("E"),
            qsTr("ESE"),
            qsTr("SE"),
            qsTr("SSE"),
            qsTr("S"),
            qsTr("SSW"),
            qsTr("SW"),
            qsTr("WSW"),
            qsTr("W"),
            qsTr("WNW"),
            qsTr("NW"),
            qsTr("NNW")
        ]
        var idx = Math.round(deg / 22.5) % 16
        return directions[idx]
    }

    // Header
    RowLayout {
        Layout.fillWidth: true
        spacing: ScreenTools.defaultFontPixelWidth

        QGCLabel {
            text: qsTr("External Wind Estimate")
            font.pointSize: ScreenTools.mediumFontPointSize
            font.bold: true
            Layout.fillWidth: true
        }
    }

    // Status label
    QGCLabel {
        Layout.fillWidth: true
        text: _lastCommandStatus !== "" ? _lastCommandStatus : qsTr("Set wind speed & direction for EKF")
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

    // Wind Speed Slider
    ValueSlider {
        id: speedSlider
        Layout.fillWidth: true
        Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 3.6
        label: qsTr("Wind Speed")
        from: 0
        to: 35
        majorTickStepSize: 5
        decimalPlaces: 1
        unitsString: "m/s"
        value: windSettings.speed
    }

    // Speed Presets
    RowLayout {
        Layout.fillWidth: true
        spacing: ScreenTools.defaultFontPixelWidth * 0.5

        Repeater {
            model: [
                { label: qsTr("Calm (0)"), val: 0.0 },
                { label: qsTr("3 m/s"),    val: 3.0 },
                { label: qsTr("6 m/s"),    val: 6.0 },
                { label: qsTr("10 m/s"),   val: 10.0 },
                { label: qsTr("15 m/s"),   val: 15.0 }
            ]

            QGCButton {
                Layout.fillWidth: true
                Layout.preferredHeight: ScreenTools.implicitButtonHeight * 0.85
                text: modelData.label
                pointSize: ScreenTools.smallFontPointSize
                onClicked: speedSlider.setValue(modelData.val)
            }
        }
    }

    Item {
        Layout.fillWidth: true
        height: ScreenTools.defaultFontPixelHeight * 0.2
    }

    // Wind Direction Slider
    ValueSlider {
        id: directionSlider
        Layout.fillWidth: true
        Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 3.6
        label: qsTr("Wind Direction (From)")
        from: 0
        to: 360
        majorTickStepSize: 45
        decimalPlaces: 0
        unitsString: "°"
        value: windSettings.direction
    }

    // Direction Cardinal Indicator & Presets
    RowLayout {
        Layout.fillWidth: true
        spacing: ScreenTools.defaultFontPixelWidth * 0.5

        QGCLabel {
            text: qsTr("From: %1 (%2°)").arg(getCardinalDirection(directionSlider.value)).arg(Math.round(directionSlider.value))
            font.pointSize: ScreenTools.smallFontPointSize
            font.bold: true
            color: qgcPal.text
            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 12
        }

        Repeater {
            model: [
                { label: qsTr("N (0°)"),   val: 0 },
                { label: qsTr("E (90°)"),  val: 90 },
                { label: qsTr("S (180°)"), val: 180 },
                { label: qsTr("W (270°)"), val: 270 }
            ]

            QGCButton {
                Layout.fillWidth: true
                Layout.preferredHeight: ScreenTools.implicitButtonHeight * 0.85
                text: modelData.label
                pointSize: ScreenTools.smallFontPointSize
                onClicked: directionSlider.setValue(modelData.val)
            }
        }
    }

    // Separator
    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: qgcPal.groupBorder
    }

    // Send Button
    QGCButton {
        Layout.fillWidth: true
        Layout.preferredHeight: ScreenTools.implicitButtonHeight
        text: qsTr("Send Wind Estimate")
        enabled: _activeVehicle !== null

        onClicked: {
            if (_activeVehicle) {
                var spd = parseFloat(speedSlider.value)
                var dir = parseFloat(directionSlider.value)
                _activeVehicle.sendExternalWindEstimate(spd, dir)
                windSettings.speed = spd
                windSettings.direction = dir
                _lastCommandStatus = qsTr("Sent: %1 m/s @ %2° (%3)").arg(spd.toFixed(1)).arg(Math.round(dir)).arg(getCardinalDirection(dir))
            }
        }
    }
}
