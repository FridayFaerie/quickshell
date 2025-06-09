import Quickshell
import QtQuick
import "./bar"
import "root:/config"
import "root:/io"

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panel


            property var modelData
            screen: modelData

            implicitHeight: Config.bar.barHeight
            implicitWidth: screen.width

            color: "transparent"
            anchors {
                top: true
                left: true
                right: true
            }
            LeftBar {
                anchors {
                    top: parent.top
                    topMargin: Config.bar.topMargin
                    left: parent.left
                    leftMargin: Config.bar.sideMargin
                }
            }
            MidBar {
                anchors {
                    top: parent.top
                    topMargin: Config.bar.topMargin
                    horizontalCenter: parent.horizontalCenter
                }
            }
            RightBar {
                anchors {
                    top: parent.top
                    topMargin: Config.bar.topMargin
                    right: parent.right
                    rightMargin: Config.bar.sideMargin
                }
            }

            // BorderImage {
            //   anchors { fill: parent; margins: 1 }
            //   border { left: 30; top: 30; right: 30; bottom: 30 }
            //   horizontalTileMode: BorderImage.Stretch
            //   verticalTileMode: BorderImage.Stretch
            //   source: "pics/borderimage.png"
            // }
        }
    }
}
