// Much help from pgattic's config
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "root:config/"

RowLayout {
    id: root

    spacing: 0

    Repeater {
        model: [...Hyprland.workspaces.values].sort((a, b) => { return a.id - b.id; })

        Rectangle {
            id: workspace
            required property HyprlandWorkspace modelData
            property bool active: Hyprland.focusedMonitor.activeWorkspace.id == modelData.id

            color: "transparent"

            width: 24
            height: Config.bar.sectionHeight - 6

            border.color: active ? Colors.foreground : "transparent"
            border.width: 2
            radius: 7

            TextObject {
                id: workspaceText
                anchors.centerIn: parent
                // Layout.alignment: Qt.AlignVCenter

                text: modelData.id == -98 ? "S" : modelData.name
                color: active ? Colors.foreground : Colors.foreground
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
