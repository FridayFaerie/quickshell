import QtQuick
import QtQuick.Layouts
import "root:/config"
import "root:/io"

Rectangle {
    id: root
    property string usedCPU: External.usedCPU
    property string usedMEM: External.usedMEM
    property string usedSTO: External.usedSTO

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
            TextObjectIcons {
                text: ""
                color: Colors.accent1
            }
            TextObject {
                text: root.usedCPU + "%"
                color: Colors.accent1
            }
        }

        RowLayout {
            TextObjectIcons {
                text: ""
                color: Colors.accent2
            }
            TextObject {
                text: root.usedMEM + "%"
                color: Colors.accent2
            }
        }

        RowLayout {
            TextObjectIcons {
                text: "󰋊"
                color: Colors.accent3
            }
            TextObject {
                text: root.usedSTO + "%"
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
