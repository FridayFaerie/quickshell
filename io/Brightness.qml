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
      console.log(value)
      // if (value > 0) {
      //   incBRI.running = true;
      //   root.value = 0;
      // } else if (value < 0) {
      //   decBRI.running = true;
      //   root.value = 0;
      // } 
      //
      setBRI.running = true;
      getBRIinfo.running = true;
      console.log(root.value + "%")
    }


    Process {
        id: setBRI
        command: ["brightnessctl", "set", root.value + "%"]
        running: false
        onExited: {
            running = false;
        }
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
        running: false
        onExited: {
            running = false;
        }
    }
    Process {
        id: incBRI
        command: ["brightnessctl", "set", "1%+"]
        running: false
        onExited: {
            running = false;
        }
    }
}
