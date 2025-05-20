import Quickshell
import "./bar"
import "root:/config"

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panel
            property var modelData
            screen: modelData

            // TODO: what on earth is going on here
            // property var test: {
            //   console.log(Config.bar.barHeight)
            //   return Config.bar.barHeight
            // }
            // implicitHeight: 40
            implicitHeight: 40
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
        }
    }
}
