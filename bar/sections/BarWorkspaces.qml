import QtQuick
import QtQuick.Layouts
import "root:/config"
import "root:/io"

Rectangle {

    Layout.minimumWidth: 50
    Layout.preferredWidth: sysInfo.width + Config.bar.componentPadding
    color: Colors.background
    border.width: Config.bar.borderWidth
    border.color: Colors.outline

    height: Config.bar.sectionHeight
    radius: 10

    RowLayout {
        id: sysInfo
        spacing: 5
        anchors.centerIn: parent


        TextObject {
            text: ""
            color: Colors.foreground
            MouseArea {
              anchors.fill: parent
              acceptedButtons: QtLeftButton
              onClicked: {
                External.drun();
              }
            }
        }

        Workspaces {}
    }
}
