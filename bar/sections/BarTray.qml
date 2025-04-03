import QtQuick
import QtQuick.Layouts
import "root:/config"
import "root:/io"

Rectangle { //Tray icons
    id: trayIcons
    Layout.preferredWidth: trayRow.width + Config.bar.componentPadding
    color: Colors.background
    border.width: Config.bar.borderWidth
    border.color: Colors.outline

    height: Config.bar.sectionHeight
    radius: 10

    RowLayout {
        id: trayRow
        spacing: Config.bar.componentSpacing
        anchors.centerIn: parent

        SysTray {}
    }
}
