pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland

import "root:/shimeji"

PanelWindow {
    id: root
    signal testSignal(id: int)
    onTestSignal: () => {
        console.log("testing testing");
    }

    WlrLayershell.namespace: "notifications"
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Normal
    // exclusiveZone: 0

    visible: true
    implicitWidth: 400
    color: "transparent"
    // color: "#1fff00ff"

    anchors {
        top: true
        right: true
        bottom: true
    }

    mask: Region {
        // intersection: Intersection.Combine
        // height: list.contentHeight + list.y
        // width: root.width
    }

    margins {
        top: 20
        right: 20
        bottom: 20
    }

    ListView {
        id: list
        anchors.fill: parent
        spacing: 10

        focus: true

        model: ListModel {
            id: data
            Component.onCompleted: () => {
                NotifServer.incoming.connect(n => {
                    data.insert(0, {
                        notif: n
                    });
                    // // TODO: sound
                    // if (Globals.conf.notifications.sounds) {
                    //     const sound = n.urgency === NotificationUrgency.Critical ? Globals.conf.notifications.criticalSound : Globals.conf.notifications.normalSound;
                    //     Utils.Command.run(["sh", "-c", `play ${sound}`]);
                    // }
                });

                NotifServer.hide.connect(id => {
                    for (let i = 0; i < data.count; i++) {
                        const e = data.get(i);
                        if (e.notif.id === id) {
                            data.remove(i);
                            return;
                        }
                    }
                });
            }
        }

        delegate: Shimeji {
        }



        addDisplaced: Transition {
          NumberAnimation {
            properties: "y"
            duration: 100
          }
        }
        add: Transition {
            NumberAnimation {
                properties: "y"
                from: -height
                duration: 100
            }
        }
        remove: Transition {
          // TODO: what does propertyaction do?
            // PropertyAction {
            //     property: "ListView.delayRemove"
            //     value: true
            // }
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    to: 0
                    duration: 200
                }
                NumberAnimation {
                    properties: "x"
                    to: 100
                    duration: 200
                }
            }
            // PropertyAction {
            //     property: "ListView.delayRemove"
            //     value: true
            // }
        }


    }
}
