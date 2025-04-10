import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import "root:/io"

PanelWindow {
    id: window

    WlrLayershell.namespace: "notifications"
    exclusionMode: ExclusionMode.Normal
    color: "transparent"
    width: 500

    mask: Region {
        intersection: Intersection.Combine
        height: popups.contentHeight + popups.y
        width: window.width
    }

    anchors {
        right: true
        top: true
        bottom: true
    }

    visible: popups.children.length > 0

    // HyprlandWindow.visibleMask: Region {
    //     regions: display.stack.children.map(child => child.mask)
    // }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent

        ListView {
            id: popups
            anchors.margins: 30
            anchors.fill: parent
            focus: true
            spacing: 10

            model: ListModel {
                id: data
                Component.onCompleted: () => {
                    NotificationServer.incomingAdded.connect(n => {
                        data.insert(0, {
                            notif: n
                        });
                    });
                    NotificationServer.incomingRemoved.connect(n => {
                        for (let i = 0; i < data.count; i++) {
                            let elem = data.get(i);
                            if (elem.id == n) {
                                elem.visible = false;
                                return;
                            }
                        }
                    });
                }
            }
            addDisplaced: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 100
                }
            }
            add: Transition {
                NumberAnimation {
                    properties: "y"
                    from: -50
                    duration: 100
                }
            }
            remove: Transition {
                PropertyAction {
                    property: "ListView.delayRemove"
                    value: true
                }
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        to: 0
                        duration: 200
                    }
                    NumberAnimation {
                        properties: "y"
                        to: -100
                        duration: 200
                    }
                }
                PropertyAction {
                    property: "ListView.delayRemove"
                    value: true
                }
            }

            delegate: PopupNotif {
                id: toast

                property int totalCountdownTime: 5000
                countdownTime: totalCountdownTime

                required property int index

                width: ListView.view.width
                showTimeBar: true

                onEntered: () => {
                    countdownTime = totalCountdownTime;
                }

                Component.onCompleted: notif.closed.connect(() => {
                    close();
                })

                onClose: {
                    if (!toast || toast.index < 0)
                        return;

                    ListView.view.model.remove(toast.index, 1);
                }
            }
        }
    }
}
