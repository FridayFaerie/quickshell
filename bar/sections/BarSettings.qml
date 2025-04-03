import QtQuick
import QtQuick.Layouts
import "root:/config"
import "root:/io"

Rectangle {
    id: root
    property string brightness: External.brightness
    property int volume: Audio.sink.audio.volume * 100
    property int sensitivity: Audio.source.audio.volume * 100
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
                text: "󰃟 " + root.brightness
                font: Config.infoFont
                color: Colors.accent1
            }
        }

        RowLayout {
            Text {
                text: " " + root.volume + "%"
                font: Config.infoFont
                color: Colors.accent2
            }
        }

        RowLayout {
            Text {
                text: " " + root.sensitivity + "%"
                font: Config.infoFont
                color: Colors.accent3
            }
        }
    }
}
