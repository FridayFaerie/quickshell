import Quickshell
import "./bar"
import "./config"

Scope {
    PanelWindow {
        id: panel
        height: 40
        width: screen.width
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
