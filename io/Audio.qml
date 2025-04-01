pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root
  PwObjectTracker{
    objects: [
      Pipewire.defaultAudioSink,
      Pipewire.defaultAudioSource
    ]
  }

  property var sink: Pipewire.defaultAudioSink
  property var source: Pipewire.defaultAudioSource

}

