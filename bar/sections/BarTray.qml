import QtQuick
import QtQuick.Layouts
import "../../config"

Rectangle { //Tray icons
    id: trayIcons
    Layout.minimumWidth: 40
    Layout.preferredWidth: trayRow.width + 20
    color: Colors.background
    border.width: 1.5
    border.color: Colors.outline

    height: Config.bar.sectionHeight
    radius: 10
    clip: true

    property var selectedMenu: null
    // property int allItems: SystemTray.items.values.length

    RowLayout {
        id: trayRow
        height: 35
        layoutDirection: Qt.RightToLeft

        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
    }
}
