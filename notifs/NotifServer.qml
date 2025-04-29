pragma Singleton

import Quickshell;
import Quickshell.Services.Notifications;
import QtQuick;

Singleton {
  id: root

  property alias notifList: server.trackedNotifications;

  signal incoming(n: Notification)
  signal hide(id: int)

  NotificationServer {
    id: server

    actionIconsSupported: true;
    actionsSupported: true;
    imageSupported: true;

    onNotification: n => {
      n.tracked = true;
      root.incoming(n);

      n.closed.connect(() => {
        root.hide(n.id)
      })

    }
  }
}


