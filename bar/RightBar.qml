import QtQuick.Layouts
import "../config"
import "./sections"

RowLayout {
    spacing: Config.bar.sectionSpacing
    BarTray{}
    BarStats{}
    BarSettings{}
}
