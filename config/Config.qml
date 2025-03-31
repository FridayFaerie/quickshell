pragma Singleton

import QtQuick
import Quickshell

Singleton {
  property QtObject bar

  property font infoFont: Qt.font({
    family: "JetBrainsMono NerdFont",
    pixelSize: 18
  })

  bar: QtObject {
    property int sectionHeight: 30
    property int barHeight: 40
    property int sectionSpacing: 8
    property int componentSpacing: 15
    property int sideMargin: 5
    property int topMargin: 7

  }
}
