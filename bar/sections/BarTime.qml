import Quickshell
import QtQuick
import QtQuick.Layouts
import "root:/config"

Rectangle {
    Layout.preferredWidth: timeText.width + Config.bar.componentPadding
    height: Config.bar.sectionHeight
    radius: 10
    color: Colors.background
    border.width: Config.bar.borderWidth
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
