import QtQuick.Layouts
import "../config"

RowLayout {
    spacing: Config.bar.sectionSpacing
    BarTray{}
    BarStats{}
    BarSettings{}
}
