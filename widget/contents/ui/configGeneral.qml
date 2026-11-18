/*
    SPDX-FileCopyrightText: 2013 David Edmundson <davidedmundson@kde.org>
    SPDX-FileCopyrightText: 2026 Mauricio <mauriciosmit100@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_showHourHand: showHourHandCheckBox.checked
    property alias cfg_showMinuteHand: showMinuteHandCheckBox.checked
    property alias cfg_secondsMode: secondsModeComboBox.currentIndex
    property alias cfg_secondsAccentColor: secondsAccentCheckBox.checked
    property alias cfg_hourHandLength: hourHandLengthSlider.value
    property alias cfg_minuteHandLength: minuteHandLengthSlider.value
    property alias cfg_secondHandLength: secondHandLengthSlider.value
    property alias cfg_handThickness: handThicknessSlider.value
    property alias cfg_showBorder: showBorderCheckBox.checked
    property alias cfg_borderThickness: borderThicknessSlider.value
    property alias cfg_backgroundOpacity: backgroundOpacitySlider.value
    property alias cfg_showTimezoneString: showTimezoneCheckBox.checked

    component ValueSlider: RowLayout {
        property alias from: slider.from
        property alias to: slider.to
        property alias stepSize: slider.stepSize
        property alias value: slider.value
        property string valueText

        Slider {
            id: slider
            Layout.fillWidth: true
            Layout.minimumWidth: Kirigami.Units.gridUnit * 10
            snapMode: Slider.SnapAlways
        }
        Label {
            Layout.minimumWidth: Kirigami.Units.gridUnit * 5
            text: parent.valueText
        }
    }

    // Thickness settings are stored in tenths of a percent of the clock diameter
    function thicknessText(value: real, minimum: string): string {
        return value === 0 ? i18nc("@item:valuesuffix", "Minimum (%1)", minimum)
                           : i18nc("@item:valuesuffix percent of clock size", "%1%", (value / 10).toLocaleString(Qt.locale(), 'f', 1));
    }

    Kirigami.FormLayout {
        CheckBox {
            id: showHourHandCheckBox
            Kirigami.FormData.label: i18n("Hands:")
            text: i18n("Show hour hand")
        }
        CheckBox {
            id: showMinuteHandCheckBox
            text: i18n("Show minute hand")
        }
        ComboBox {
            id: secondsModeComboBox
            Kirigami.FormData.label: i18n("Seconds:")
            model: [i18n("Not shown"), i18n("Show hand"), i18n("Show dot at the edge")]
        }
        CheckBox {
            id: secondsAccentCheckBox
            enabled: secondsModeComboBox.currentIndex !== 0
            text: i18n("Use accent color for seconds")
        }

        Item { Kirigami.FormData.isSection: true }

        ValueSlider {
            id: hourHandLengthSlider
            Kirigami.FormData.label: i18n("Hour hand length:")
            enabled: showHourHandCheckBox.checked
            from: 10; to: 100; stepSize: 1
            valueText: i18nc("@item:valuesuffix percent of radius", "%1%", value)
        }
        ValueSlider {
            id: minuteHandLengthSlider
            Kirigami.FormData.label: i18n("Minute hand length:")
            enabled: showMinuteHandCheckBox.checked
            from: 10; to: 100; stepSize: 1
            valueText: i18nc("@item:valuesuffix percent of radius", "%1%", value)
        }
        ValueSlider {
            id: secondHandLengthSlider
            Kirigami.FormData.label: i18n("Seconds hand length:")
            enabled: secondsModeComboBox.currentIndex === 1
            from: 10; to: 100; stepSize: 1
            valueText: i18nc("@item:valuesuffix percent of radius", "%1%", value)
        }
        ValueSlider {
            id: handThicknessSlider
            Kirigami.FormData.label: i18n("Hand thickness:")
            from: 0; to: 200; stepSize: 5
            valueText: thicknessText(value, i18nc("@item:valuesuffix", "2.5 pt"))
        }
        Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            font: Kirigami.Theme.smallFont
            text: i18n("Hour hand width, relative to the clock size. The minute and seconds hands are 40% and 20% of it. Never thinner than 2.5, 1 and 0.5 points.")
        }

        Item { Kirigami.FormData.isSection: true }

        CheckBox {
            id: showBorderCheckBox
            Kirigami.FormData.label: i18n("Border:")
            text: i18n("Show border (fills the whole panel height)")
        }
        ValueSlider {
            id: borderThicknessSlider
            Kirigami.FormData.label: i18n("Border thickness:")
            enabled: showBorderCheckBox.checked || secondsModeComboBox.currentIndex === 2
            from: 0; to: 100; stepSize: 5
            valueText: thicknessText(value, i18nc("@item:valuesuffix", "0.5 pt"))
        }
        Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            font: Kirigami.Theme.smallFont
            text: i18n("Relative to the clock size, never thinner than 0.5 points. The seconds dot is three times this size.")
        }

        ValueSlider {
            id: backgroundOpacitySlider
            Kirigami.FormData.label: i18n("Background opacity:")
            from: 0; to: 100; stepSize: 5
            valueText: value === 0 ? i18n("Transparent") : i18nc("@item:valuesuffix percent", "%1%", value)
        }

        Item { Kirigami.FormData.isSection: true }

        CheckBox {
            id: showTimezoneCheckBox
            Kirigami.FormData.label: i18n("General:")
            text: i18n("Show time zone")
        }
    }
}
