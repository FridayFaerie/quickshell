import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications
import "../config/"

    Rectangle {
        id: badge

        required property string imagesource
        required property int size
        property int borderwidth: 2


        color: Colors.background
        border.width: borderwidth
        border.color: Colors.outline
        radius: 9999
        visible: imagesource != "" ? true : false
        width: size + border.width * 2
        height: size + border.width * 2


        Image {
            id: sourceImage
            visible: false
            source: badge.imagesource ? badge.imagesource : ""
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
            visible: badge.imagesource != ""
            source: sourceImage
            width: sourceImage.width
            height: sourceImage.height
            anchors.fill: sourceImage
            maskEnabled: true
            maskSource: mask
        }

        Item {
            id: mask
            width: sourceImage.width
            height: sourceImage.height
            layer.enabled: true
            visible: false
            Rectangle {
                width: sourceImage.width
                height: sourceImage.height
                radius: width / 2
                color: "black"
            }
        }
    }
