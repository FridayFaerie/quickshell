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
        id: workspaces
        model: [...Hyprland.workspaces.values].sort((a, b) => {
            return a.id - b.id;
        })

        Rectangle {
            id: workspace
            required property HyprlandWorkspace modelData
            property bool active: Hyprland.focusedMonitor?.activeWorkspace.id == modelData.id

            color: "transparent"

            // width: 24
            width: workspaceText.width + 14
            height: Config.bar.sectionHeight - 2

            border.color: active ? Colors.foreground : "transparent"
            border.width: 2
            radius: 7

            TextObject {
                id: workspaceText
                anchors.centerIn: parent

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
