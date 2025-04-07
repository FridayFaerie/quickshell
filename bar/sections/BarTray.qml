import QtQuick
import QtQuick.Layouts
import "root:/config"
import "root:/io"

Rectangle { 
    color: Colors.background
    border.width: Config.bar.borderWidth
    border.color: Colors.outline
    height: Config.bar.sectionHeight
    radius: 10

    Layout.preferredWidth: trayRow.width + Config.bar.componentPadding

    SysTray {
      id: trayRow
      anchors.centerIn: parent
    }
}
