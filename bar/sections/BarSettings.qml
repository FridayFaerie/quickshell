// w/ much help from AlephNought0/Faeryshell
import QtQuick
import QtQuick.Layouts
import "root:/config"
import "root:/io"

Rectangle {
    id: root

    property string brightness: Brightness.brightness
    property int volume: Audio.sink?.audio.volume * 100
    property int sensitivity: Audio.source?.audio.volume * 100

    property string sinkIcon: Audio.sink == null ? "?" : (Audio.sink.audio.muted ? "󰖁" : "󰕾")
    property string sourceIcon: Audio.source == null ? "?" : (Audio.source.audio.muted ? "󰍭" : "󰍬")

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
                text: "󰃟"
                color: Colors.accent1
            }
            TextObject {
                text: root.brightness
                color: Colors.accent1
            }
            MouseArea {
              // WARN: anchor that is managed by layout, undefined behavior
              // but I don't know how to do the MouseArea things otherwise
                anchors.fill: parent

                onWheel: event => {
                    if (event.angleDelta.y > 0) {
                        // NOTE: might need user groups video for brightnessctl :(
                        Brightness.value = 1;
                    } else {
                        Brightness.value = -1;
                    }
                }
            }
        }

        RowLayout {
            TextObject {
                text: root.sinkIcon
                color: Colors.accent2
            }
            TextObject {
                text: root.volume + "%"
                color: Colors.accent2
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton

                onClicked: {
                    Audio.sink.audio.muted = !Audio.sink.audio.muted;
                }
                onWheel: event => {
                    if (event.angleDelta.y > 0) {
                        Audio.sink.audio.volume += 0.01;
                    } else {
                        Audio.sink.audio.volume -= 0.01;
                    }
                }
            }
        }

        RowLayout {
            TextObject {
                text: root.sourceIcon
                color: Colors.accent3
            }
            TextObject {
                text: root.sensitivity + "%"
                color: Colors.accent3
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton

                onClicked: {
                    Audio.source.audio.muted = !Audio.source.audio.muted;
                }
                onWheel: event => {
                    if (event.angleDelta.y > 0) {
                        Audio.source.audio.volume += 0.01;
                    } else {
                        Audio.source.audio.volume -= 0.01;
                    }
                }
            }
        }
    }
}
