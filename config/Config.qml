pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property QtObject bar
    property QtObject notifs

    bar: QtObject {
        property int sectionHeight: 30
        property int barHeight: 40
        property int sectionSpacing: 8
        property int componentSpacing: 15
        property int componentPadding: 20
        property int workspaceSpacing: 10
        property int sideMargin: 5
        property int topMargin: 7
        property real borderWidth: 0
    }

    notifs: QtObject {
        property int gaps: 5
    }
}
