// from https://git.allpurposem.at/mat/Quickbar
// from https://github.com/nydragon/nysh
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "./newTimer.mjs" as NewTimer

Singleton {
    id: notif

    property var _: NotificationServer {
        id: server
        //supported features here
        actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: false
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            n.tracked = true;

            notif.incomingAdded(n);

            NewTimer.after(1000, notif, () => {
                notif.incomingRemoved(n.id);
            });
        }

        property alias list: server.trackedNotifications

        function clearAll() {
            const len = server.trackedNotifications.values.length;
            for (let i = 0; i < len; i++) {
                // TODO: check/change this
                server.trackedNotifications.values[0].dismiss();
            }
        }
    }

    signal incomingRemoved(id: int)
    signal incomingAdded(id: Notification)

    function init() {
    }
}
