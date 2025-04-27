// pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.namespace: "notifications"
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Normal
    // exclusiveZone: 0

    visible: true
    width: 400
    // color: "transparent"
    color: "#09ff00ff"

    anchors {
        top: true
        right: true
        bottom: true
    }

    mask: Region {
        // intersection: Intersection.Combine
        height: list.contentHeight + list.y
        width: list.width
    }

    margins {
        top: 20
        right: 20
        bottom: 20
    }

    // ListView or ColumnLayout
    ListView {
        id: list
        anchors.fill: parent
        spacing: 10
        model: ListModel {
            id: data
            Component.onCompleted: () => {
                NotifServer.incoming.connect(n => {
                  data.insert(0,{notif:n})
                    // // TODO: sound
                    // if (Globals.conf.notifications.sounds) {
                    //     const sound = n.urgency === NotificationUrgency.Critical ? Globals.conf.notifications.criticalSound : Globals.conf.notifications.normalSound;
                    //     Utils.Command.run(["sh", "-c", `play ${sound}`]);
                    // }
                    // console.log(JSON.stringify(data.get(n)))
                });

                NotifServer.dismissed.connect(id => {
                    for (let i = 0; i < data.count; i++) {
                        const e = data.get(i);
                        if (e.n.id === id) {
                            data.remove(i);
                            return;
                        }
                    }
                });
            }
        }

        delegate: Toast {
            popup: true
        }

        // displaced: Transition {
        //   Anims.NumberAnim { property: "y"; duration: Globals.vars.animLen }
        // }
        // add: Transition {
        //   ParallelAnimation {
        //     Anims.NumberAnim {
        //       property: "anchors.rightMargin";
        //       from: -popups.width; to: 0;
        //       duration: Globals.vars.animLen;
        //       easing.type: Easing.OutExpo;
        //     }
        //     Anims.NumberAnim {
        //       property: "anchors.leftMargin";
        //       from: popups.width; to: 0;
        //       duration: Globals.vars.animLen;
        //       easing.type: Easing.OutExpo;
        //     }
        //   }
        // }
        // remove: Transition {
        //   ParallelAnimation {
        //     Anims.NumberAnim {
        //       property: "anchors.rightMargin";
        //       from: 0; to: -popups.width;
        //       duration: Globals.vars.animLen;
        //       easing.type: Easing.InExpo;
        //     }
        //     Anims.NumberAnim {
        //       property: "anchors.leftMargin";
        //       from: 0; to: popups.width;
        //       duration: Globals.vars.animLen;
        //       easing.type: Easing.InExpo;
        //     }
        //   }
        // }

    }
}
