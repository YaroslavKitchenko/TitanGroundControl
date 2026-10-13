import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtLocation
import QtPositioning

import QGroundControl
import QGroundControl.Controls
import QGroundControl.ScreenTools
import QGroundControl.Palette

/// Marker for displaying alternate vehicle positions (GPS 1, GPS 2, AHRS2) on the map
MapQuickItem {
    id: _root

    property var    map
    property double heading:        Number.NaN
    property real   size:           ScreenTools.defaultFontPixelHeight * 1.5
    property color  markerColor:    qgcPal.colorBlue
    property string labelText:      ""
    property bool   showBadge:      false

    anchorPoint.x:  size / 2
    anchorPoint.y:  size / 2
    z:              showBadge ? (QGroundControl.zOrderVehicles + 2) : (QGroundControl.zOrderVehicles + 1)
    visible:        coordinate.isValid

    QGCPalette { id: qgcPal }

    sourceItem: Item {
        id:         containerItem
        width:      _root.size
        height:     _root.size

        // Arrow marker
        Item {
            id:                 arrowItem
            anchors.centerIn:   parent
            width:              _root.size
            height:             _root.size

            transform: Rotation {
                origin.x:   arrowItem.width / 2
                origin.y:   arrowItem.height / 2
                angle:      isNaN(heading) ? 0 : heading
            }

            Canvas {
                id:             arrowCanvas
                anchors.fill:   parent

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.save()

                    var tipX = width / 2
                    var tipY = 0
                    var rX = width
                    var rY = height
                    var notchX = width / 2
                    var notchY = height * 0.72
                    var lX = 0
                    var lY = height

                    ctx.beginPath()
                    ctx.moveTo(tipX, tipY)
                    ctx.lineTo(rX, rY)
                    ctx.lineTo(notchX, notchY)
                    ctx.lineTo(lX, lY)
                    ctx.closePath()

                    ctx.fillStyle = markerColor
                    ctx.fill()

                    ctx.lineWidth = 1.5
                    ctx.strokeStyle = "#FFFFFF"
                    ctx.stroke()

                    ctx.restore()
                }

                Connections {
                    target: _root
                    function onMarkerColorChanged() { arrowCanvas.requestPaint() }
                    function onSizeChanged() { arrowCanvas.requestPaint() }
                }

                Component.onCompleted: arrowCanvas.requestPaint()
            }
        }

        // Click / touch area to toggle badge
        MouseArea {
            anchors.centerIn:   parent
            width:              Math.max(_root.size, ScreenTools.minTouchPixels)
            height:             Math.max(_root.size, ScreenTools.minTouchPixels)
            cursorShape:        Qt.PointingHandCursor
            hoverEnabled:       true
            onClicked:          _root.showBadge = !_root.showBadge
        }

        // Interactive Badge popup
        Rectangle {
            id:                         badgePopup
            anchors.bottom:             arrowItem.top
            anchors.bottomMargin:      ScreenTools.defaultFontPixelHeight * 0.4
            anchors.horizontalCenter:   arrowItem.horizontalCenter
            visible:                    _root.showBadge
            width:                      badgeLayout.width + ScreenTools.defaultFontPixelWidth * 1.5
            height:                     badgeLayout.height + ScreenTools.defaultFontPixelHeight * 0.8
            radius:                     ScreenTools.defaultFontPixelHeight * 0.3
            color:                      qgcPal.windowShadeDark
            border.color:               markerColor
            border.width:               2

            ColumnLayout {
                id:                 badgeLayout
                anchors.centerIn:   parent
                spacing:            ScreenTools.defaultFontPixelHeight * 0.2

                RowLayout {
                    Layout.fillWidth: true
                    spacing:          ScreenTools.defaultFontPixelWidth

                    Rectangle {
                        width:            ScreenTools.defaultFontPixelHeight * 0.6
                        height:           width
                        radius:           width / 2
                        color:            markerColor
                        Layout.alignment: Qt.AlignVCenter
                    }

                    QGCLabel {
                        text:             labelText
                        font.bold:        true
                        font.pointSize:   ScreenTools.smallFontPointSize
                        color:            qgcPal.text
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true }

                    QGCLabel {
                        text:             "✕"
                        font.bold:        true
                        font.pointSize:   ScreenTools.smallFontPointSize
                        color:            qgcPal.text
                        Layout.alignment: Qt.AlignVCenter

                        MouseArea {
                            anchors.fill:   parent
                            anchors.margins: -ScreenTools.defaultFontPixelWidth * 0.5
                            cursorShape:    Qt.PointingHandCursor
                            onClicked:      _root.showBadge = false
                        }
                    }
                }

                QGCLabel {
                    text:           qsTr("Lat: %1").arg(coordinate.latitude.toFixed(6))
                    font.pointSize: ScreenTools.smallFontPointSize * 0.9
                    color:          qgcPal.text
                }

                QGCLabel {
                    text:           qsTr("Lon: %1").arg(coordinate.longitude.toFixed(6))
                    font.pointSize: ScreenTools.smallFontPointSize * 0.9
                    color:          qgcPal.text
                }

                QGCLabel {
                    text:           qsTr("Alt: %1 %2").arg(QGroundControl.unitsConversion.metersToAppSettingsVerticalDistanceUnits(coordinate.altitude).toFixed(1)).arg(QGroundControl.unitsConversion.appSettingsVerticalDistanceUnitsString)
                    font.pointSize: ScreenTools.smallFontPointSize * 0.9
                    color:          qgcPal.text
                    visible:        !isNaN(coordinate.altitude)
                }

                QGCLabel {
                    text:           qsTr("Hdg: %1°").arg(heading.toFixed(1))
                    font.pointSize: ScreenTools.smallFontPointSize * 0.9
                    color:          qgcPal.text
                    visible:        !isNaN(heading)
                }
            }
        }
    }
}
