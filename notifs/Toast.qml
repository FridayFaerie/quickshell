// TODO: do I need all these imports?
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications
import "../config/"

Item {
    id: root
    required property Notification notif

    property bool popup: false

    //timeout things
    function setTimeout(callback, delay: int) {
        if (typeof callback !== "function")
            return;
        const timer = Qt.createQmlObject("import QtQuick; Timer {}", root);
        timer.interval = delay;
        timer.repeat = false;
        timer.triggered.connect(() => {
            timer.destroy();
            callback();
        });
        timer.start();
        return timer;
    }

    property var timer
    property real timeout: 1000 * 3
    Component.onCompleted: {
        if (!popup) {
            return;
        }

        root.timer = setTimeout(() => {
            // root.notif.dismiss();
            NotifServer.hide(root.notif.id);
        }, root.timeout);
    }

    implicitWidth: 400
    implicitHeight: box.implicitHeight - badge.anchors.horizontalCenterOffset + badge.borderwidth

    Rectangle {
        id: box
        // color: notif.urgency == NotificationUrgency.Critical ? "#30ff2030" : "#30c0ffff"
        // color: Colors.background
        color: "#ba1e1e1e"
        radius: 5
        border.width: 2
        border.color: Colors.outline
        implicitWidth: parent.implicitWidth - badge.width / 2 - badge.anchors.horizontalCenterOffset
        implicitHeight: c.implicitHeight
        anchors.bottom: parent.bottom

        ColumnLayout {
            id: c
            spacing: 0
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            RowLayout {
                Layout.topMargin: 10
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.bottomMargin: 4
                Text {
                    visible: text != ""
                    text: notif.summary
                    color: Colors.accent2
                    elide: Text.ElideRight
                    Layout.maximumWidth: box.implicitWidth - 80
                    font {
                        family: "Caslonia"
                        pixelSize: 25
                        weight: 10000
                    }
                }
            }

            Text {
                id: bodytext
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.bottomMargin: 10
                Layout.maximumWidth: box.implicitWidth - 20
                font {
                    family: "Caslonia"
                    pixelSize: 19
                }

                width: box.implicitWidth - 20
                text: notif.body
                color: Colors.foreground
                wrapMode: Text.Wrap
            }
        }
    }

    // done: appicon, notifsummary, notifimage, notifbody,
    // not done: hide, dismiss, show-all, row of buttons in show-all?
}
