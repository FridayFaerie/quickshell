import QtQuick
import QtQuick.Layouts
import "../config"

Rectangle {
    //Usage info
    Layout.minimumWidth: 50
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
        anchors.bottom: parent.bottom

        RowLayout {
            Text {
                text: ""
                font: Config.infoFont
                color: Colors.foreground
            }
        }

        RowLayout {
            spacing: 30
            Text {
                text: "1"
                font: Config.infoFont
                color: Colors.foreground
            }

            Text {
                text: "2"
                font: Config.infoFont
                color: Colors.foreground
            }
            Text {
                text: "3"
                font: Config.infoFont
                color: Colors.foreground
            }
            Text {
                text: "4"
                font: Config.infoFont
                color: Colors.foreground
            }
        }
    }
}
