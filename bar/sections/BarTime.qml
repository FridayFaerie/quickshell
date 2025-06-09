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



    MouseArea {
        anchors.centerIn: parent
        implicitHeight: timeText.implicitHeight
        implicitWidth: timeText.implicitWidth

        TextObject {
            id: timeText
            property int offset: 0
            property date displayDate: new Date(clock.date.getTime() + offset )
            color: Colors.foreground
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.formatDateTime(displayDate, "hh:mm · dd MMM, ddd")
        }

        acceptedButtons: Qt.LeftButton

        onClicked: {
            timeText.offset = 0;
        }
        onWheel: event => {
            if (event.angleDelta.y > 0) {
                timeText.offset += 60000;
            } else {
                timeText.offset -= 60000;
            }
        }
    }
}
