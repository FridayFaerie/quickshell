import Quickshell
import QtQuick
import QtQuick.Layouts
import "../config"

Rectangle {
    Layout.preferredWidth: timeText.width + 30
    height: Config.bar.sectionHeight
    radius: 10
    color: Colors.background
    border.width: 1.5
    border.color: Colors.outline

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        id: timeText
        font: Config.infoFont
        color: Colors.foreground
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: Qt.formatDateTime(clock.date, "hh:mm · dd MMM, ddd")
    }
}
