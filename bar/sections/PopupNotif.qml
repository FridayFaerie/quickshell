pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import Quickshell.Wayland

import "root:/config"

MouseArea {
    id: toast

    required property Notification notif

    property int actionHeight: 30
    property int expansionSpeed: 100
    property int countdownTime: 1000
    property bool showTimeBar: false

    property string body
    property string appName
    property string summary
    property string appIcon

    Component.onCompleted: {
        body = notif?.body ?? "";
        appName = notif?.appName ?? "";
        summary = notif?.summary ?? "";
        appIcon = notif?.appIcon ?? "";
    }

    height: box.height
    hoverEnabled: true

    signal close

    // for copying
    TextEdit {
        id: textEdit
        visible: false
    }

    Rectangle {
        id: box
        width: parent.width
        height: header.height + actions.implicitHeight + bodyBox.height + (5 * 3)

        clip: true

        color: Colors.background
        radius: 10

        border.color: Colors.outline
        border.width: 2

        Item {
            id: inner
            anchors.margins: 5
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.fill: parent

            GridLayout {
                id: header
                columns: 4
                width: parent.width
                height: 40

                IconImage {
                    source: toast.appIcon ? Quickshell.iconPath(toast.appIcon) : ""
                    height: parent.height
                    width: height
                    visible: toast.appIcon ?? false
                }

                TextObject {
                    text: `${toast.appIcon ? "" : `${toast.appName}:`} ${toast.summary}`
                    Layout.fillWidth: true
                    color: Colors.accent1
                }

                MouseArea {
                    onClicked: () => {
                        textEdit.text = toast.body;
                        textEdit.selectAll();
                        textEdit.copy();
                    }
                    height: 30
                    width: 30

                    TextObject {
                      text: "󰆏"
                      color: Colors.outline
                    }
                }

                MouseArea {
                    onClicked: toast.close()
                    height: 30
                    width: 30
                    TextObject {
                      text: "󰅖"
                      color: Colors.outline
                    }
                }
            }

            Rectangle {
                id: bodyBox
                width: parent.width
                anchors.top: header.bottom
                height: 60
                clip: true
                property int maxHeight: 0
                color: "transparent"

                TextObject {
                    id: text
                    text: toast.body ?? ""
                    width: parent.width
                    height: parent.height
                    wrapMode: Text.Wrap
                    
                    color: Colors.foreground

                    onImplicitHeightChanged: {
                        if (text.implicitHeight < bodyBox.height) {
                            bodyBox.height = text.implicitHeight;
                        }
                    }

                    Component.onCompleted: () => {
                        bodyBox.maxHeight = Qt.binding(() => text.implicitHeight);
                    }
                }

                states: State {
                    name: "expand"
                    when: toast.containsMouse
                    PropertyChanges {
                        target: bodyBox
                        height: bodyBox.maxHeight
                    }
                }

                transitions: Transition {
                    NumberAnimation {
                        properties: "height"
                        duration: toast.expansionSpeed
                    }
                }
            }

            GridLayout {
                id: actions
                width: parent.width
                anchors.top: bodyBox.bottom
                anchors.topMargin: 5
                anchors.bottomMargin: 5
                columns: toast.notif?.actions.length < 6 ? toast.notif?.actions.length : 4
                Repeater {
                    id: rep
                    model: toast.notif?.actions

                    delegate: PopupNotifAction {
                        required property var modelData
                        notifAction: modelData
                        hasIcons: toast.notif?.hasActionIcons ?? false
                        height: toast.actionHeight
                        Layout.fillWidth: true
                    }
                }
                visible: toast.notif?.actions.length ?? false
            }
        }

        NumberAnimation on width {
            duration: toast.expansionSpeed
        }

        Rectangle {
            id: timeBar
            visible: toast.showTimeBar
            anchors.margins: 2
            anchors.rightMargin: 4
            anchors.bottom: box.bottom
            anchors.right: box.right
            width: box.width - box.border.width - anchors.margins - Theme.rounding * 2
            height: 4

            bottomLeftRadius: box.radius
            bottomRightRadius: box.radius

            color: {
                switch (toast.notif?.urgency) {
                case NotificationUrgency.Critical:
                    return Theme.catppuccinColors.red;
                    break;
                case NotificationUrgency.Normal:
                    return Theme.catppuccinColors.green.darker();
                    break;
                default:
                    return Theme.catppuccinColors.text;
                }
            }

            clip: true

            NumberAnimation on width {
                id: anim
                from: timeBar.width
                to: 0
                duration: toast.countdownTime
                paused: toast.containsMouse && timeBar.visible
                running: timeBar.visible

                onFinished: () => { toast.close() }
            }
            
            Connections {
                target: toast
                function onEntered() {
                    timeBar.width = box.width - box.border.width - timeBar.anchors.margins;
                    anim.restart();
                    anim.pause();
                }
            }
        }
    }
}

