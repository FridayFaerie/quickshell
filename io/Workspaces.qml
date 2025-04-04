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

            color: Hyprland.focusedMonitor?.activeWorkspace.id == modelData.id ? Colors.accent3 : "transparent"

            Text {
                id: workspaceText
                anchors.centerIn: parent
                // Layout.alignment: Qt.AlignVCenter ????

                text: modelData.id == -98 ? "S" : modelData.name
                color: Hyprland.focusedMonitor?.activeWorkspace.id == modelData.id ? Colors.background : Colors.foreground
                font: Config.infoFont
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (modelData.id == -98) {
                        Hyprland.dispatch("togglespecialworkspace magic");
                    } else {
                        Hyprland.dispatch(`workspace ${modelData.id}`);
                    }
                }
            }
        }
    }
}
