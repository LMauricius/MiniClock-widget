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

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    // With a border the face is the whole widget, so take the full panel thickness
    Plasmoid.constraintHints: Plasmoid.configuration.showBorder ? Plasmoid.CanFillArea : Plasmoid.NoHint
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
                top: parent.top
                bottom: analogclock.showTimezone ? timezoneBg.top : parent.bottom
            }
            width: parent.width

            hours: analogclock.hours
            minutes: analogclock.minutes
            seconds: analogclock.seconds

            showHourHand: Plasmoid.configuration.showHourHand
            showMinuteHand: Plasmoid.configuration.showMinuteHand
            secondsMode: Plasmoid.configuration.secondsMode

            hourHandLength: Plasmoid.configuration.hourHandLength / 100
            minuteHandLength: Plasmoid.configuration.minuteHandLength / 100
            secondHandLength: Plasmoid.configuration.secondHandLength / 100

            // Stored in tenths of a percent of the diameter
            hourHandThickness: Plasmoid.configuration.handThickness / 1000
            borderThickness: Plasmoid.configuration.borderThickness / 1000

            showBorder: Plasmoid.configuration.showBorder
            backgroundOpacity: Plasmoid.configuration.backgroundOpacity / 100

            handColor: Kirigami.Theme.textColor
            secondsColor: Plasmoid.configuration.secondsAccentColor ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
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
