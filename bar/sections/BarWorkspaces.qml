import QtQuick
import QtQuick.Layouts
import "root:/config"
import "root:/io"

Rectangle {
  id: rect

    Layout.minimumWidth: 50
    Layout.preferredWidth: sysInfo.width + Config.bar.componentPadding
    color: Colors.background
    border.width: Config.bar.borderWidth
    border.color: Colors.outline

    height: Config.bar.sectionHeight
    radius: 10


    RowLayout {
        id: sysInfo
        spacing: 10
        anchors.centerIn: parent


        TextObjectIcons {
            // text: ""
            // text: "󰄚"
            text: ""
            color: Colors.foreground
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onClicked: {
                    External.drun();
                    // console.log(rect.width)
                }
            }
        }

        Workspaces {}
    }
}
