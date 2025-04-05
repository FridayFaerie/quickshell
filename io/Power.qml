pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
  id: root

  property var battery: UPower.displayDevice
  property int bat: Math.floor(battery.percentage * 100)

}

