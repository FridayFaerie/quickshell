import QtQuick
import QtQuick.Layouts
import "../../config"

Rectangle {
    //Usage info
    Layout.preferredWidth: sysInfo.width + 30
    height: Config.bar.sectionHeight
    radius: 10
    color: Colors.background
    border.width: 1.5
    border.color: Colors.outline

    RowLayout {
        id: sysInfo
        spacing: Config.bar.componentSpacing
        anchors.centerIn: parent

        RowLayout {
            Text {
                text: "󰃟"
                font: Config.infoFont
                color: Colors.accent1
            }

            Text {
                text: "bri"
                font: Config.infoFont
                color: Colors.accent1
            }
        }

        RowLayout {
            Text {
                text: ""
                font: Config.infoFont
                color: Colors.accent2
            }

            Text {
                text: "vol"
                font: Config.infoFont
                color: Colors.accent2
            }
        }

        RowLayout {
            Text {
                text: ""
                font: Config.infoFont
                color: Colors.accent3
            }

            Text {
                text: "sen"
                font: Config.infoFont
                color: Colors.accent3
            }
        }
    }
}
