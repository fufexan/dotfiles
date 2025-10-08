pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root
    property PwNode defaultSink: Pipewire.defaultAudioSink
    property PwNode defaultSource: Pipewire.defaultAudioSource

    PwObjectTracker {
        objects: [root.defaultSink, root.defaultSource]
    }

    function sinkIcon() {
      const audio = root.defaultSink?.audio;
      if (audio.muted)
        return "audio-volume-muted-symbolic";

      const vol = audio.volume * 100;
      const icon = [
        [101, "audio-volume-overamplified-symbolic"],
        [67, "audio-volume-high-symbolic"],
        [34, "audio-volume-medium-symbolic"],
        [1, "audio-volume-low-symbolic"],
        [0, "audio-volume-muted-symbolic"],
      ].find(([threshold]) => threshold <= vol)[1];

      return icon;
    }

    function sourceIcon() {
      const audio = root.defaultSource?.audio;
      if (audio.muted)
        return "microphone-sensitivity-muted-symbolic";

      const vol = audio.volume * 100;
      const icon = [
        [67, "microphone-sensitivity-high-symbolic"],
        [34, "microphone-sensitivity-medium-symbolic"],
        [1, "microphone-sensitivity-low-symbolic"],
        [0, "microphone-sensitivity-muted-symbolic"],
      ].find(([threshold]) => threshold <= vol)[1];

      return icon;
    }
}
