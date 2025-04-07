import QtQuick.Layouts
import "root:/config"
import "./sections"

RowLayout {
    spacing: Config.bar.sectionSpacing
    BarWorkspaces {}
    BarInfo {}
    BarTray{}
}
