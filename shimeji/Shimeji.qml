import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "./sprites"
import "root:/config"

Item {
    id: root
    required property Notification notif

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
            width: sprite.width
            height: sprite.height
            radius: width
            x: display.width - 100
            y: display.height - 150
            color: "transparent"
            // border.color: "cyan"
            // border.width: 2

            // NOTE: this elide behavior is from allpurposemat's Quickbar
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.top
                width: bodyBox.width + 10
                height: bodyBox.height + 10
                radius: 3
                color: "#c01f1f1f"

                Rectangle {
                    id: bodyBox

                    width: 250
                    height: 30
                    property int maxHeight: 0

                    anchors.centerIn: parent

                    color: "transparent"

                    states: State {
                        name: "expand"
                        when: rect.held
                        PropertyChanges {
                            target: bodyBox
                            height: bodyBox.maxHeight
                        }
                    }

                    transitions: Transition {
                        NumberAnimation {
                            properties: "height"
                            duration: 80
                        }
                    }

                    Text {
                        id: text

                        width: parent.width
                        height: parent.height

                        onImplicitHeightChanged: {
                            if (text.implicitHeight < bodyBox.height) {
                                bodyBox.height = text.implicitHeight;
                            }
                            if (text.implicitWidth < bodyBox.width) {
                                bodyBox.width = text.implicitWidth;
                            }
                        }

                        Component.onCompleted: () => {
                            bodyBox.maxHeight = Qt.binding(() => text.implicitHeight);
                        }

                        text: root.notif.body
                        color: "white"
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignJustify
                        elide: Text.ElideRight
                        font {
                            family: "Caslonia"
                            pixelSize: 19
                        }
                        wrapMode: Text.Wrap
                    }
                }
            }

            property bool held: false

            // AnimatedSprite {
            //   id: sprite
            //   frameWidth: 80
            //   frameHeight: 80
            //   frameCount: 8
            //   interpolate: false
            //   source: "./sprites/image.png"
            // }

            SpriteSequence {
                id: sprite
                width: 64
                height: 64
                // Argh why is there bleedthrough when smooth: true :(((
                // smooth: false
                interpolate: false
                running: true
                sprites: SpriteList.slist
                // transform: Rotation{origin.x: 40; origin.y: 40; angle: physics.x}

                // onCurrentSpriteChanged: {
                //   console.log(currentSprite)
                // }

            }
            Timer {
                id: physics
                interval: 40 // milliseconds
                running: true
                repeat: true
                readonly property real dt: interval / 1000
                // property real g: 0
                // property real r: 1
                // property real f: 1
                property real g: 1000
                property real r: 0.8
                property real f: 0.90
                property real x: parent.x
                property real y: parent.y
                property real vx: -200 // in pixels per second
                property real vy: -100
                property real lastx: 0
                property real lasty: 0
                property real lastt: 0

                property int die: 0
                property bool dying: false
                property bool onGround: false
                readonly property int walkSpeed: 60

                onTriggered: {
                    if (sprite.currentSprite == "dead") {
                        root.notif.dismiss();
                    }

                    if (parent.held) {
                        physics.lastx = x;
                        physics.lasty = y;
                        physics.x = mouseArea.mouseX - rect.width / 2;
                        physics.y = mouseArea.mouseY - rect.height / 2;
                        die = 0;
                    } else if (die * die == 1) {
                        physics.onGround = false;
                        physics.f = 0.5;
                        physics.r = 0.5;
                        physics.vx = 500 * die;
                        physics.vy = -300;
                        die = 0;
                        dying = true;
                        sprite.jumpTo("dying");
                    } else if (onGround) {
                        if (sprite.currentSprite == "walking-right") {
                            x += walkSpeed * dt;
                            if (x + parent.width > display.width) {
                                sprite.jumpTo("walking-left");
                            }
                        } else if (sprite.currentSprite == "walking-left") {
                            x -= walkSpeed * dt;
                            if (x < 0) {
                                sprite.jumpTo("walking-right");
                            }
                        }
                    } else {
                        vy += g * dt;

                        x += vx * dt;
                        y += vy * dt;

                        if (y < 0) {
                            y = 0;
                            vy = -vy * r;
                            vx *= f;
                        } else if (y + parent.height > display.height) {
                            if (vy < g * dt) {
                                vy = 0;
                                if (!dying) {
                                    onGround = true;
                                }
                            }
                            y = display.height - parent.height;
                            vy = -vy * r;
                            vx *= f;
                        }
                        if (x < 0) {
                            x = 0;
                            vx = -vx * r;
                            vy *= f;
                            if (!dying) {
                                sprite.jumpTo("walking-right");
                            }
                        } else if (x + parent.width > display.width) {
                            x = display.width - parent.width;
                            vx = -vx * r;
                            vy *= f;
                            if (!dying) {
                                sprite.jumpTo("walking-left");
                            }
                        }
                    }
                    parent.x = x;
                    parent.y = y;
                }
            }

            Behavior on x {
                NumberAnimation {
                    duration: physics.interval
                    easing.type: Easing.Linear
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: physics.interval
                    easing.type: Easing.Linear
                }
            }
        }
        MouseArea {
            id: mouseArea
            property int oldMouseX

            anchors.fill: parent
            hoverEnabled: true
            onContainsMouseChanged: {
                if (containsMouse) {
                    oldMouseX = mouseArea.mouseX;
                } else {
                    if (mouseArea.mouseX - oldMouseX >= 50 && mouseArea.mouseY >= 0.8 * display.height) {
                        physics.die = 1;
                    } else if (oldMouseX - mouseArea.mouseX >= 50 && mouseArea.mouseY >= 0.8 * display.height) {
                        console.log(mouseArea.mouseY);
                        physics.die = -1;
                    }
                    oldMouseX = 0;
                }
            }
            onPressed: {
                rect.held = true;
                physics.vx = 0;
                physics.vy = 0;
            }
            onReleased: {
                rect.held = false;
                physics.onGround = false;
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
}
