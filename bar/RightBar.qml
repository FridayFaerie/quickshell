import QtQuick.Layouts
import "root:/config"
import "./sections"

RowLayout {
    spacing: Config.bar.sectionSpacing
    BarTray{}
    BarStats{}
    BarSettings{}
}
