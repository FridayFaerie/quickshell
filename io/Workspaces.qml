// Much from pgattic
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "root:config/"
import "root:io/"

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

            color: "transparent"

            width: 25
            height: Config.bar.sectionHeight - 6

            border.color: Hyprland.focusedMonitor?.activeWorkspace.id == modelData.id ? Colors.foreground : "transparent"
            border.width: 2
            radius: 7

            TextObject {
                id: workspaceText
                anchors.centerIn: parent
                // Layout.alignment: Qt.AlignVCenter


                text: modelData.id == -98 ? "S" : modelData.name
                color: Hyprland.focusedMonitor?.activeWorkspace.id == modelData.id ? Colors.foreground : Colors.foreground
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
