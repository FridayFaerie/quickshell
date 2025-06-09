import Quickshell
import QtQuick
import Quickshell.Wayland

PanelWindow {
    id: display
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    height: screen.height
    width: screen.width
    color: "transparent"

    mask: Region {
        item: rect
    }

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    Rectangle {
        id: rect
        width: 50
        height: 50
        radius: 25
        x: 400
        y: 400
        color: "transparent"
        border.color: "pink"
        border.width: 2

        property bool held: false

        Timer {
            id: physics
            interval: 90 // milliseconds
            running: true
            repeat: true
            readonly property real dt: interval / 1000
            property real g: 0
            property real r: 1
            property real f: 1
            // property real g: 1000
            // property real r: 0.8
            // property real f: 0.90
            property real x: parent.x
            property real y: parent.y
            property real vx: 300 // in pixels per second
            property real vy: 300
            property real lastx: 0
            property real lasty: 0
            property real lastt: 0
            onTriggered: {
                if (parent.held) {
                    physics.lastx = x;
                    physics.lasty = y;
                    physics.x = mouseArea.mouseX - rect.width / 2;
                    physics.y = mouseArea.mouseY - rect.height / 2;
                } else {
                    vy += g * dt;

                    x += vx * dt;
                    y += vy * dt;

                    if (y < 0) {
                        y = 0;
                        vy = -vy * r;
                        vx *= f;
                    } else if (y + parent.height > display.height) {
                        y = display.height - parent.height;
                        vy = -vy * r;
                        vx *= f;
                    }
                    if (x < 0) {
                        x = 0;
                        vx = -vx * r;
                        vy *= f;
                    } else if (x + parent.width > display.width) {
                        x = display.width - parent.width;
                        vx = -vx * r;
                        vy *= f;
                    }
                }
                parent.x = x;
                parent.y = y;
            }
        }

        Behavior on x {
            NumberAnimation {
                duration: physics.interval
                easing.type: Easing.Bezier
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: physics.interval
                easing.type: Easing.Bezier
            }
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: {
            rect.held = true;
            physics.vx = 0;
            physics.vy = 0;
        }
        onReleased: {
            rect.held = false;
            physics.vx = (physics.x - physics.lastx) / physics.dt;
            physics.vy = (physics.y - physics.lasty) / physics.dt;
        }
        onWheel: event => {
            if (event.angleDelta.y > 0) {
                physics.running = false;
            } else {
                physics.vx = 0;
                physics.vy = 0;
                physics.running = true;
            }
        }
    }
}
