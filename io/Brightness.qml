pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string brightness
    property int value: 0
    function refresh() {
        getBRIinfo.running = true;
    }

    onValueChanged: () => {
        if (value > 0) {
            incBRI.running = true;
            root.value = 0;
        } else if (value < 0) {
            decBRI.running = true;
            root.value = 0;
        }

        getBRIinfo.running = true;
    }

    Process {
        id: getBRIinfo
        command: ["sh", "-c", "brightnessctl -m i | cut -d, -f4"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.brightness = data;
            }
        }
    }
    Process {
        id: decBRI
        command: ["brightnessctl", "set", "1%-"]
    }
    Process {
        id: incBRI
        command: ["brightnessctl", "set", "1%+"]
    }
}
