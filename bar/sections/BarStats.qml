import QtQuick
import QtQuick.Layouts
import "../../config"
import "../../io"

Rectangle {
    id: root
    property string bat: Power.bat
    property string temp: SystemSessionIO.temp

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
                text: " " + root.temp + "°C"
                font: Config.infoFont
                color: Colors.accent1
            }

        }

        RowLayout {
            Text {
                text: "󰁹 " + root.bat + "%"
                font: Config.infoFont
                color: Colors.accent3
            }
        }
    }
}
