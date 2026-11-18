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

    component SettingSlider: Slider {
        Layout.fillWidth: true
        Layout.minimumWidth: Kirigami.Units.gridUnit * 12
        // Fine steps keep the style from drawing tick marks
        stepSize: 1
        snapMode: Slider.SnapAlways
    }

    Kirigami.FormLayout {
        wideMode: true

        CheckBox {
            id: showHourHandCheckBox
            Kirigami.FormData.label: i18n("Hands:")
            text: i18n("Show hours")
        }
        CheckBox {
            id: showMinuteHandCheckBox
            text: i18n("Show minutes")
        }
        ComboBox {
            id: secondsModeComboBox
            Kirigami.FormData.label: i18n("Seconds:")
            model: [i18n("Don't show"), i18n("Hand"), i18n("Dot")]
        }
        CheckBox {
            id: secondsAccentCheckBox
            enabled: secondsModeComboBox.currentIndex !== 0
            text: i18n("Accent color")
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Look")
        }

        SettingSlider {
            id: hourHandLengthSlider
            Kirigami.FormData.label: i18n("Hour hand:")
            enabled: showHourHandCheckBox.checked
            from: 10; to: 100
        }
        SettingSlider {
            id: minuteHandLengthSlider
            Kirigami.FormData.label: i18n("Minute hand:")
            enabled: showMinuteHandCheckBox.checked
            from: 10; to: 100
        }
        SettingSlider {
            id: secondHandLengthSlider
            Kirigami.FormData.label: i18n("Seconds hand:")
            enabled: secondsModeComboBox.currentIndex === 1
            from: 10; to: 100
        }
        SettingSlider {
            id: handThicknessSlider
            Kirigami.FormData.label: i18n("Hand thickness:")
            from: 0; to: 200
        }

        Item { Kirigami.FormData.isSection: true }

        CheckBox {
            id: showBorderCheckBox
            Kirigami.FormData.label: i18n("Border:")
            text: i18n("Show")
        }
        SettingSlider {
            id: borderThicknessSlider
            Kirigami.FormData.label: i18n("Border size:")
            enabled: showBorderCheckBox.checked || secondsModeComboBox.currentIndex === 2
            from: 0; to: 100
        }
        SettingSlider {
            id: backgroundOpacitySlider
            Kirigami.FormData.label: i18n("Background opacity:")
            from: 0; to: 100
        }

        Item { Kirigami.FormData.isSection: true }

        CheckBox {
            id: showTimezoneCheckBox
            Kirigami.FormData.label: i18n("Time zone:")
            text: i18n("Show")
        }
    }
}
