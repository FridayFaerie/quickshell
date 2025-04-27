import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import "../config/"

MouseArea {
    id: root

    required property Notification notif
    readonly property real timeout: 10
    // readonly property real timeout: notif.expireTimeout > 0
    //   ? notif.expireTimeout
    //   : notif.urgency === NotificationUrgency.Critical
    //     ? Globals.conf.notifications.defaultCriticalTimeout
    //     : Globals.conf.notifications.defaultTimeout;
    property bool popup: false
    anchors.left: parent.left
    anchors.right: parent.right
    height: bg.height
    hoverEnabled: true
    property var timer

    Component.onCompleted: {
        if (!popup)
            return;
        root.timer = Utils.Timeout.setTimeout(() => {
            NotifServer.dismissed(notif.id);
        }, root.timeout);
    }

    onContainsMouseChanged: {
        if (!popup)
            return;
        if (containsMouse) {
            root.timer.restart();
            root.timer.stop();

            // progressController.stop();
            // progressBar.smoothing = true;
            // progressBar.value = 1;
            // progressBar.smoothing = false;
        } else {
            root.timer.start();
            // progressController.start();
        }
    }

    Rectangle {
        id: bg
        anchors {
            left: parent.left
            right: parent.right
        }

        height: content.height

        color: Colors.background
        radius: 10
        border {
            color: Colors.outline
            width: 2
            pixelAligned: false
        }

        ColumnLayout {
            id: content
            spacing: 10

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Item {}

            RowLayout {
              id: row
                spacing: 10
                Layout.fillWidth: true

                Item {}  // Padding

                ColumnLayout {
                    spacing: 5

                    Item {
                        height: summary.height
                        width: row.width

                        Text {
                          id: summary
                            text: root.notif.summary
                            color: Colors.foreground
                            font {
                                family: "JetBrainsMono Nerd Font Propo"
                                pixelSize: 16
                            }
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            Layout.fillWidth: true

                            anchors.left: parent.left
                        }

                        
                        Item {
                          anchors.right: parent.right
                          Text {
                              id: appName
                              text: root.notif.appName
                              color: Colors.foreground
                              font {
                                  family: "JetBrainsMono Nerd Font Propo"
                                  pixelSize: 12
                                  italic: true
                              }
                              elide: Text.ElideRight
                              maximumLineCount: 1
                              Layout.fillWidth: true
                          }

                          IconImage {
                            visible: !!root.notif.appIcon
                            source: !!root.notif.appIcon ? Quickshell.iconPath(root.notif.appIcon) : ""
                            implicitSize: appName.height
                          }
                      }
                    }


                    Text {
                        text: root.notif.body
                        color: Colors.foreground
                        font {
                            family: "JetBrainsMono Nerd Font Propo"
                            pixelSize: Globals.vars.mainFontSize
                        }
                        wrapMode: Text.WordWrap
                        maximumLineCount: 3
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    RowLayout {
                        id: actions
                        visible: root.popup && root.notif.actions.length > 0
                        Layout.fillWidth: true
                        // spacing: Globals.vars.spacingButtonGroup;

                        Repeater {
                            model: root.n?.actions

                            // delegate: Button {
                            //   required property NotificationAction modelData;
                            //   required property int index;
                            //
                            //   Layout.fillWidth: true;
                            //   autoHeight: true;
                            //
                            //   label: modelData.text;
                            //   onClicked: modelData.invoke();
                            //
                            //   tlRadius: index === 0;
                            //   blRadius: index === 0;
                            //   trRadius: index === root.notif.actions.length - 1;
                            //   brRadius: index === root.notif.actions.length - 1;
                            //   bg: Globals.colours.bgLight;
                            // }
                        }
                    }
                    Item {}
                }
            }

            // ProgressBar {
            //   id: progressBar
            //   value: 1;
            //   Layout.fillWidth: true;
            //   implicitHeight: 5;
            //   bg: "transparent";
            //   fg: notif.urgency === NotificationUrgency.Critical ? Globals.colours.red : Globals.colours.accent;
            //   radius: Globals.vars.br;
            //   smoothing: false;
            // }

            // FrameAnimation {
            //   id: progressController
            //   running: true;
            //   onTriggered: {
            //     if (progressBar.value <= 0) stop()
            //     else progressBar.value -= (progressBar.width / (root.timeout / 1000) * frameTime) / progressBar.width
            //     // Get how much the progress bar should recede then convert it into a decimal percentage
            //   }
            // }
        }

        // Close button - displays on top of everything
        // Button {
        //   anchors {
        //     right: parent.right;
        //     top: parent.top;
        //     rightMargin: Globals.vars.paddingNotif;
        //     topMargin: Globals.vars.paddingNotif;
        //   }
        //   implicitHeight: appName.height;
        //   implicitWidth: implicitHeight;
        //
        //   label: "close-symbolic";
        //   icon: true;
        //   opacity: root.containsMouse ? 1 : 0;
        //   Anims.NumberTransition on opacity {}
        //
        //   bg: Globals.colours.red;
        //   bgHover: Globals.colours.redHover;
        //   bgPress: Globals.colours.redHover;
        //   labelColour: Globals.colours.bg;
        //
        //   tlRadius: true; trRadius: true; blRadius: true; brRadius: true;
        //   padding: 0;
        //
        //   onClicked: root.notif.dismiss();
        // }

    }
}
