/*
    SPDX-FileCopyrightText: 2012 Viranch Mehta <viranch.mehta@gmail.com>
    SPDX-FileCopyrightText: 2012 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2013-2023 David Edmundson <davidedmundson@kde.org>
    SPDX-FileCopyrightText: 2026 Mauricio <mauriciosmit100@gmail.com>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.ksvg as KSvg
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

import org.kde.plasma.clock
import org.kde.plasma.workspace.calendar as PlasmaCalendar

PlasmoidItem {
    id: analogclock

    width: Kirigami.Units.gridUnit * 15
    height: Kirigami.Units.gridUnit * 15

    readonly property string currentTime: Qt.locale().toString(clockSource.dateTime, Qt.locale().timeFormat(Locale.LongFormat))
    readonly property string currentDate: Qt.locale().toString(clockSource.dateTime, Qt.locale().dateFormat(Locale.LongFormat).replace(/(^dddd.?\s)|(,?\sdddd$)/, ""))

    property int hours: clockSource.dateTime.getHours()
    property int minutes: clockSource.dateTime.getMinutes()
    property int seconds: clockSource.dateTime.getSeconds()
    property bool showSeconds: Plasmoid.configuration.secondsMode !== 0
    property bool showTimezone: Plasmoid.configuration.showTimezoneString

    // Blend amount of b into a
    function mix(a: color, b: color, amount: real): color {
        return Qt.rgba(a.r + (b.r - a.r) * amount, a.g + (b.g - a.g) * amount, a.b + (b.b - a.b) * amount, 1);
    }

    // Scale the channels so the largest one is at full intensity
    function brightest(c: color): color {
        const top = Math.max(c.r, c.g, c.b);
        return top > 0 ? Qt.rgba(c.r / top, c.g / top, c.b / top, 1) : c;
    }

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    preferredRepresentation: compactRepresentation

    toolTipMainText: {
        const day = Qt.locale().toString(clockSource.dateTime, "dddd");
        return day.charAt(0).toUpperCase() + day.slice(1);
    }
    toolTipSubText: `${currentTime}\n${currentDate}`

    Clock {
        id: clockSource
        trackSeconds: analogclock.showSeconds || (analogclock.compactRepresentationItem as MouseArea).containsMouse
    }

    compactRepresentation: MouseArea {
        id: representation

        Layout.minimumWidth: Plasmoid.formFactor !== PlasmaCore.Types.Vertical ? representation.height : Kirigami.Units.gridUnit
        Layout.minimumHeight: Plasmoid.formFactor === PlasmaCore.Types.Vertical ? representation.width : Kirigami.Units.gridUnit

        property bool wasExpanded

        activeFocusOnTab: true
        hoverEnabled: true

        Accessible.name: Plasmoid.title
        Accessible.description: i18nc("@info:tooltip", "Current time is %1; Current date is %2", analogclock.currentTime, analogclock.currentDate)
        Accessible.role: Accessible.Button

        onPressed: wasExpanded = analogclock.expanded
        onClicked: analogclock.expanded = !wasExpanded

        ClockFace {
            id: clock

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: analogclock.showTimezone ? timezoneBg.top : parent.bottom
                // The panel gives the widget no margins, so keep the border off its edges
                margins: Plasmoid.configuration.showBorder
                         ? Math.round(Math.min(representation.width, representation.height) * Plasmoid.configuration.borderPadding / 100)
                         : 0
            }

            hours: analogclock.hours
            minutes: analogclock.minutes
            seconds: analogclock.seconds

            showHourHand: Plasmoid.configuration.showHourHand
            showMinuteHand: Plasmoid.configuration.showMinuteHand
            secondsMode: Plasmoid.configuration.secondsMode
            smoothSeconds: Plasmoid.configuration.smoothSeconds

            hourHandLength: Plasmoid.configuration.hourHandLength / 100
            minuteHandLength: Plasmoid.configuration.minuteHandLength / 100
            secondHandLength: Plasmoid.configuration.secondHandLength / 100

            // Stored in tenths of a percent of the diameter
            hourHandThickness: Plasmoid.configuration.handThickness / 1000
            borderThickness: Plasmoid.configuration.borderThickness / 1000

            showBorder: Plasmoid.configuration.showBorder
            backgroundOpacity: Plasmoid.configuration.backgroundOpacity / 100

            readonly property bool handsAccent: Plasmoid.configuration.handsAccentColor

            handColor: handsAccent ? analogclock.mix(Kirigami.Theme.highlightColor, Kirigami.Theme.textColor, 0.33) : Kirigami.Theme.textColor
            borderColor: Kirigami.Theme.textColor
            // Whichever of accent and critical the hands don't already use
            secondsColor: !Plasmoid.configuration.secondsAltColor ? handColor
                        : analogclock.mix(analogclock.brightest(handsAccent ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.highlightColor),
                                          Kirigami.Theme.textColor, 0.15)
            // Black behind light hands, white behind dark hands
            backgroundColor: Kirigami.ColorUtils.brightnessForColor(Kirigami.Theme.textColor) === Kirigami.ColorUtils.Light ? "black" : "white"

            animate: Kirigami.Units.longDuration > 1
        }

        KSvg.FrameSvgItem {
            id: timezoneBg

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 10
            }
            width: childrenRect.width + margins.right + margins.left
            height: childrenRect.height + margins.top + margins.bottom
            visible: analogclock.showTimezone

            imagePath: "widgets/background"

            PlasmaComponents.Label {
                id: timezoneText
                x: timezoneBg.margins.left
                y: timezoneBg.margins.top
                text: clockSource.timeZone
                textFormat: Text.PlainText
            }
        }
    }

    fullRepresentation: PlasmaCalendar.MonthView {
        Layout.minimumWidth: Kirigami.Units.gridUnit * 22
        Layout.maximumWidth: Kirigami.Units.gridUnit * 80
        Layout.minimumHeight: Kirigami.Units.gridUnit * 22
        Layout.maximumHeight: Kirigami.Units.gridUnit * 40

        readonly property var appletInterface: analogclock

        today: clockSource.dateTime
    }
}
