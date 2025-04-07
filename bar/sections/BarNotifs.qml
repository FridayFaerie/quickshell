import QtQuick
import QtQuick.Layouts
import "root:/config"
import "root:/io"

Rectangle {
    id: root
    height: Config.bar.sectionHeight
    radius: 10
    color: Colors.background
    border.width: Config.bar.borderWidth
    border.color: Colors.outline

    Layout.preferredWidth: notifIcon.width + Config.bar.componentPadding

// 
// 
// 
// 
    TextObject {
        id: notifIcon
        anchors.centerIn: parent
        text: ""
        color: Colors.accent2
        MouseArea {
            anchors.fill: parent
            onClicked: {
              console.log(" TODO: THIS")
            }
        }
    }
}
