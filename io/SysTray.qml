// much from Xanazf
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "root:config/"

RowLayout {
    id: root
    spacing: Config.bar.componentSpacing
    Repeater {
        model: SystemTray.items
        Rectangle {
            id: toprect
            required property SystemTrayItem modelData
            color: "transparent"
            implicitWidth: trayIcon.width
            implicitHeight: trayIcon.height
            MouseArea {
                cursorShape: Qt.PointingHandCursor
                propagateComposedEvents: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent
                IconImage {
                    id: trayIcon
                    source: toprect.modelData.icon
                    height: Config.bar.sectionHeight - 6
                    width: Config.bar.sectionHeight - 6
                    anchors.centerIn: parent
                }
                onClicked: mouse => {
                    if (mouse.button == Qt.LeftButton) {
                        toprect.modelData.activate();
                    } else if (mouse.button == Qt.RightButton) {
                        if (!menuOpener.anchor.window) {
                            menuOpener.anchor.window = toprect.QsWindow.window;
                        }
                        if (menuOpener.visible) {
                            menuOpener.close();
                        } else {
                            menuOpener.open();
                        }
                    }
                }
            }
            QsMenuAnchor {
                id: menuOpener
                menu: toprect.modelData.menu
                anchor {
                    rect.x: 0
                    rect.y: 0
                    onAnchoring: {
                        if (anchor.window) {
                            let coords = anchor.window.contentItem.mapFromItem(toprect, 0, 0);
                            anchor.rect.x = coords.x;
                            anchor.rect.y = coords.y + 6;
                        }
                    }
                    rect.width: trayIcon.width
                    rect.height: trayIcon.height
                    gravity: Edges.Bottom
                    edges: Edges.Bottom
                    adjustment: PopupAdjustment.SlideY
                }
            }
        }
    }
}
