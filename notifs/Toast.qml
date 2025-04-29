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
    implicitHeight: box.implicitHeight - badge.anchors.horizontalCenterOffset + 5

    Rectangle {
        id: box
        // color: notif.urgency == NotificationUrgency.Critical ? "#30ff2030" : "#30c0ffff"
        color: Colors.background
        radius: 5
        border.width: 2
        border.color: Colors.outline
        implicitWidth: 400
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
                    color: Colors.foreground
                    elide: Text.ElideRight
                    Layout.maximumWidth: box.implicitWidth - 80
                    font {
                        family: "JetBrainsMono Nerd Font Propo"
                        pixelSize: 18
                        weight: 600
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
                    family: "JetBrainsMono Nerd Font Propo"
                    pixelSize: 12
                }

                width: box.implicitWidth - 20
                text: notif.body
                color: Colors.foreground
                wrapMode: Text.Wrap
            }
        }
    }

    // TODO: factorise out the code to make images circular
    Rectangle {
        id: badge
        anchors.horizontalCenter: box.right
        anchors.verticalCenter: box.top
        anchors.horizontalCenterOffset: -12
        anchors.verticalCenterOffset: 8

        color: Colors.background
        border.width: 2
        border.color: Colors.outline
        radius: 9999
        visible: notif.image != ""

        width: notifImage.width + 8
        height: notifImage.height + 8

        Image {
            id: sourceImage
            readonly property int size: notifImage.visible ? 40 : 0
            visible: false
            source: notif.image
            fillMode: Image.PreserveAspectFit
            cache: false
            antialiasing: true

            anchors.centerIn: parent
            // TODO: do I need width? or sourceSize.width? try later
            width: size
            height: size
            sourceSize.width: size
            sourceSize.height: size
        }

        // https://forum.qt.io/topic/145956/rounded-image-in-qt6/6
        MultiEffect {
            id: notifImage
            visible: notif.image != ""
            source: sourceImage
            width: sourceImage.width
            height: sourceImage.height
            anchors.fill: sourceImage
            maskEnabled: true
            maskSource: mask

            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        Item {
            id: mask
            width: sourceImage.width
            height: sourceImage.height
            layer.enabled: true
            layer.smooth: true
            visible: false
            Rectangle {
                width: sourceImage.width
                height: sourceImage.height
                radius: width / 2
                color: "black"
            }
        }
    }

    Rectangle {
        id: minibadge
        anchors.horizontalCenter: box.right
        anchors.verticalCenter: box.top
        anchors.horizontalCenterOffset: 0
        anchors.verticalCenterOffset: 32

        color: Colors.background
        border.width: 2
        border.color: Colors.outline
        radius: 9999
        visible: notif.appIcon != ""

        width: mininotifImage.width + 8
        height: mininotifImage.height + 8

        Image {
            id: minisourceImage
            readonly property int size: mininotifImage.visible ? 18 : 0
            visible: false
            source: notif.appIcon ? Quickshell.iconPath(notif.appIcon) : ""
            fillMode: Image.PreserveAspectFit
            cache: false
            antialiasing: true

            anchors.centerIn: parent
            // TODO: do I need width? or sourceSize.width? try later
            width: size
            height: size
            sourceSize.width: size
            sourceSize.height: size
        }

        // https://forum.qt.io/topic/145956/rounded-image-in-qt6/6
        MultiEffect {
            id: mininotifImage
            visible: notif.appIcon != ""
            source: minisourceImage
            width: minisourceImage.width
            height: minisourceImage.height
            anchors.fill: minisourceImage
            maskEnabled: true
            maskSource: mask
        }

        Item {
            id: minimask
            width: minisourceImage.width
            height: minisourceImage.height
            layer.enabled: true
            visible: false
            Rectangle {
                width: minisourceImage.width
                height: minisourceImage.height
                radius: width / 2
                color: "black"
            }
        }
    }

    // app icon, notif summary, close button, notif image, notif body, row of buttons
}
