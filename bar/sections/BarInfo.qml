import QtQuick
import QtQuick.Layouts
import "root:/config"
import "root:/io"

Rectangle {
    id: root
    property string usedCPU: External.usedCPU
    property string usedRAM: External.usedRAM
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
            Text {
                text: " " + root.usedCPU + "%"
                font: Config.infoFont
                color: Colors.accent1
            }
        }

        RowLayout {
            Text {
                text: " " + root.usedRAM + "%"
                font: Config.infoFont
                color: Colors.accent2
            }
        }

        RowLayout {
            Text {
                text: "󰋊 " + root.usedSTO + "%"
                font: Config.infoFont
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
