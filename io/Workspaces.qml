// Much from pgattic
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "root:config/"

RowLayout {
    id: root

    spacing: 0

    function getSortedWorkspaces() {
        var arr = Hyprland.workspaces.values.slice();
        arr.sort((a, b) => {
            return a.id - b.id;
        });
        return arr;
    }

    Repeater {
        model: getSortedWorkspaces()

        Rectangle {
            id: workspace
            required property HyprlandWorkspace modelData

            implicitWidth: 25
            implicitHeight: Config.bar.sectionHeight

            color: Hyprland.focusedMonitor?.activeWorkspace.id == modelData.id ? Colors.foreground : "transparent"

            Text {
                id: workspaceText
                anchors.centerIn: parent
                // Layout.alignment: Qt.AlignVCenter ????

                text: modelData.id == -98 ? "S" : modelData.name
                color: Hyprland.focusedMonitor?.activeWorkspace.id == modelData.id ? Colors.background : Colors.foreground
                font: Config.infoFont
            }

            // MouseArea {
            //     cursorShape: Qt.PointingHandCursor
            //     propagateComposedEvents: true
            //     acceptedButtons: Qt.LeftButton | Qt.RightButton
            //     anchors.fill: parent
            //     onClicked: mouse => {
            //         if (mouse.button == Qt.LeftButton) {
            //             toprect.modelData.activate();
            //         } else if (mouse.button == Qt.RightButton) {
            //             if (!menuOpener.anchor.window) {
            //                 menuOpener.anchor.window = toprect.QsWindow.window;
            //             }
            //             if (menuOpener.visible) {
            //                 menuOpener.close();
            //             } else {
            //                 menuOpener.open();
            //             }
            //         }
            //     }
            // }
        }
    }
}
