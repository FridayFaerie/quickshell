import QtQuick
import QtQuick.Layouts
import "root:/config"
import "root:/io"

Rectangle {
    id: root
    property string bat: Power.bat
    property string temp: External.temp

    Layout.preferredWidth: sysInfo.width + Config.bar.componentPadding
    height: Config.bar.sectionHeight
    radius: 10
    color: Colors.background
    border.width: Config.bar.borderWidth
    border.color: Colors.outline

    RowLayout {
        id: sysInfo
        spacing: Config.bar.componentSpacing
        anchors.centerIn: parent

        RowLayout {
            TextObject {
                text: ""
                color: Colors.accent1
            }
            TextObject {
                text: root.temp + "°C"
                color: Colors.accent1
            }
        }

        RowLayout {
            TextObject {
                text: "󰁹"
                color: Colors.accent3
            }
            TextObject {
                text: root.bat + "%"
                color: Colors.accent3
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            External.btop();
        }
    }
}
