//much from SirEthanator
pragma Singleton

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    signal incoming(n: Notification)
    signal dismissed(id: int)

    NotificationServer {
        id: server

        actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        persistenceSupported: true
        // extraHints: ["",""]

        keepOnReload: false

        onNotification: n => {
          console.log(JSON.stringify(n))
            n.tracked = true;
            root.incoming(n);

            n.closed.connect(() => {
                root.dismissed(n.id);
            });
        }
    }
}
