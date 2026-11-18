/*
    SPDX-FileCopyrightText: 2026 Mauricio <mauriciosmit100@gmail.com>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtQuick.Shapes

// Flat, vector-drawn clock face. All sizes are in logical pixels (points).
Item {
    id: face

    property int hours
    property int minutes
    property int seconds

    property bool showHourHand: true
    property bool showMinuteHand: true
    // 0 = not shown, 1 = hand, 2 = dot at the edge
    property int secondsMode: 0
    // Sweep the seconds continuously instead of ticking
    property bool smoothSeconds: false

    // Fractions of the inner radius
    property real hourHandLength: 0.55
    property real minuteHandLength: 0.9
    property real secondHandLength: 0.95

    // Fractions of the diameter; the minimums below always win
    property real hourHandThickness: 0.08
    property real borderThickness: 0.025

    property bool showBorder: true
    property real backgroundOpacity: 0

    property color handColor: "black"
    property color secondsColor: handColor
    property color borderColor: handColor
    property color backgroundColor: "white"

    property bool animate: true

    readonly property real minHourWidth: 2.5
    readonly property real minMinuteWidth: 1
    readonly property real minSecondWidth: 0.5
    readonly property real minBorderWidth: 0.5

    readonly property real diameter: Math.min(width, height)
    readonly property real outerRadius: diameter / 2

    readonly property real hourWidth: Math.max(minHourWidth, diameter * hourHandThickness)
    readonly property real minuteWidth: Math.max(minMinuteWidth, hourWidth * 0.4)
    readonly property real secondWidth: Math.max(minSecondWidth, hourWidth * 0.2)
    readonly property real borderWidth: Math.max(minBorderWidth, diameter * borderThickness)
    readonly property real dotDiameter: borderWidth * 3

    readonly property real innerRadius: showBorder ? outerRadius - borderWidth : outerRadius

    // A smooth sweep runs one second ahead, so it reaches each mark as that second starts
    readonly property real secondsAngle: (smoothSeconds ? seconds + 1 : seconds) * 6

    // Background disc and border ring
    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        visible: face.showBorder || face.backgroundOpacity > 0

        ShapePath {
            fillColor: Qt.rgba(face.backgroundColor.r, face.backgroundColor.g, face.backgroundColor.b, face.backgroundOpacity)
            strokeColor: face.showBorder ? face.borderColor : "transparent"
            strokeWidth: face.showBorder ? face.borderWidth : -1
            PathAngleArc {
                centerX: face.width / 2
                centerY: face.height / 2
                // The stroke is centred on the path, keep it fully inside the item
                radiusX: face.showBorder ? face.outerRadius - face.borderWidth / 2 : face.outerRadius
                radiusY: radiusX
                startAngle: 0
                sweepAngle: 360
            }
        }
    }

    component Hand: Shape {
        id: hand

        property real angle
        property real length
        property real thickness
        property color color
        property bool animate
        property bool sweep

        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        rotation: angle

        Behavior on rotation {
            enabled: hand.animate || hand.sweep
            RotationAnimation {
                duration: hand.sweep ? 1000 : 250
                direction: RotationAnimation.Clockwise
                easing.type: hand.sweep ? Easing.Linear : Easing.OutElastic
                easing.overshoot: 0.5
            }
        }

        ShapePath {
            strokeColor: hand.color
            strokeWidth: hand.thickness
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            startX: hand.width / 2
            startY: hand.height / 2
            // The round cap sticks out by half the width, so a 100% hand ends at the border
            PathLine {
                x: hand.width / 2
                y: hand.height / 2 - Math.max(0, hand.length - hand.thickness / 2)
            }
        }
    }

    Hand {
        visible: face.showHourHand
        angle: (face.hours % 12) * 30 + face.minutes / 2
        length: face.innerRadius * face.hourHandLength
        thickness: face.hourWidth
        color: face.handColor
        animate: face.animate
    }

    Hand {
        visible: face.showMinuteHand
        angle: face.minutes * 6
        length: face.innerRadius * face.minuteHandLength
        thickness: face.minuteWidth
        color: face.handColor
        animate: face.animate
    }

    Hand {
        visible: face.secondsMode === 1
        angle: face.secondsAngle
        length: face.innerRadius * face.secondHandLength
        thickness: face.secondWidth
        color: face.secondsColor
        animate: face.animate
        sweep: face.smoothSeconds
    }

    // Seconds dot, touching the border (or the edge when there is no border)
    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        visible: face.secondsMode === 2
        rotation: face.secondsAngle

        Behavior on rotation {
            enabled: face.animate || face.smoothSeconds
            RotationAnimation {
                duration: face.smoothSeconds ? 1000 : 250
                direction: RotationAnimation.Clockwise
                easing.type: face.smoothSeconds ? Easing.Linear : Easing.OutElastic
                easing.overshoot: 0.5
            }
        }

        ShapePath {
            fillColor: face.secondsColor
            strokeWidth: -1
            PathAngleArc {
                centerX: face.width / 2
                centerY: face.height / 2 - (face.innerRadius - face.dotDiameter / 2)
                radiusX: face.dotDiameter / 2
                radiusY: radiusX
                startAngle: 0
                sweepAngle: 360
            }
        }
    }
}
