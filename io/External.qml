// please let me know if I can improve this in any way... no clue what I'm doing.....
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import "root:/bar/sections"

Singleton {
    id: root

    // property string debugValue:

    function drun() {
        drun.running = true;
    }
    function btop() {
        btop.running = true;
    }
    function shutdown() {
        shutdown.running = true;
    }
    function swaync() {
        swaync.running = true;
    }
    function lockscreen() {
        lockscreen.running = true;
    }

    property string workingDirectory: "/home/friday/.config/quickshell/"

    property int temp

    // A lot of things here are from Xanazf & pterror

    // // host info
    // property string uptime
    // property string host
    // property string kernel

    property real totalMEM
    property real freeMEM
    property real usedMEM: Math.round(100 * (root.totalMEM - root.freeMEM) / root.totalMEM)

    property real idleSecCPU
    property real totalSecCPU
    property real idleCPU
    property real totalCPU
    property real usedCPU: Math.round(100 * (root.totalSecCPU - root.idleSecCPU) / root.totalSecCPU)

    property real usedSTO

    // universal minute timer
    Timer {
        interval: 1000 * 60
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            // getUptime.running = true;
            getMEMinfo.reload();
            getDiskinfo.running = true;
            pid.running = true;
        }
    }

    // 1s timer
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            getTEMPinfo.reload();
            // printDebug.running = true;
            getCPUinfo.reload();
        }
    }

    // once
    // Process {
    //   id: getHost
    //   command: ["sh", "-c", "uname -n"]
    //   running: true
    //   stdout: SplitParser {
    //     onRead: data => {
    //       root.host = data;
    //     }
    //   }
    //   onExited: {
    //     running = false;
    //   }
    // }
    // Process {
    //   id: getKernel
    //   command: ["sh", "-c", "uname -r"]
    //   running: true
    //   stdout: SplitParser {
    //     onRead: data => {
    //       root.kernel = data;
    //     }
    //   }
    //   onExited: {
    //     running = false;
    //   }
    // }

    // on a timer
    // Process {
    //   id: getUptime
    //   command: ["sh", "-c", "uptime -p"]
    //   running: true
    //   stdout: SplitParser {
    //     onRead: data => {
    //       root.uptime = data;
    //     }
    //   }
    //   onExited: {
    //     running = false;
    //   }
    // }
    FileView {
        id: getMEMinfo
        path: "/proc/meminfo"
        onLoaded: {
            const text = getMEMinfo.text();
            if (!text) {
                return;
            }

            root.totalMEM = Number(text.match(/MemTotal: *(\d+)/)[1] ?? 1);
            root.freeMEM = Number(text.match(/MemAvailable: *(\d+)/)[1] ?? 0);
        }
    }
    FileView {
        // copied wholesale from pterror
        id: getCPUinfo
        path: "/proc/stat"
        onLoaded: {
            const text = getCPUinfo.text();
            if (!text) {
                return;
            }
            const cpuAll = text.match(/^.+/)[0];
            const [user, nice, system, newIdle, iowait, irq, softirq, steal, guest, guestNice] = cpuAll.match(/\d+/g).map(Number);
            const newTotal = user + nice + system + newIdle + iowait + irq + softirq + steal + guest + guestNice;
            root.idleSecCPU = newIdle - root.idleCPU;
            root.totalSecCPU = newTotal - root.totalCPU;
            root.idleCPU = newIdle;
            root.totalCPU = newTotal;
        }
    }
    FileView {
        id: getTEMPinfo
        path: "/sys/class/thermal/thermal_zone5/temp"
        onLoaded: {
            const text = getTEMPinfo.text();
            root.temp = text / 1000;
        }
    }

    Process { // this is from Xanazf - but very stripped
        id: getDiskinfo
        command: ["sh", "-c", "lsblk -fnJA"]
        running: true
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                const parsed = JSON.parse(data);
                const blockdevices = parsed.blockdevices;
                for (const device of blockdevices) {
                    let usedPercent;
                    for (const child of device.children) {
                        if (!child.fsavail) {
                            continue;
                        }
                        usedPercent = Number(child["fsuse%"].slice(0, -1));
                    }
                    root.usedSTO = usedPercent;
                }
            }
        }
        onExited: {
            running = false;
        }
    }
    Process {
        id: drun
        command: ["sh", "-c", "rofi -show drun -show-icons"]
        running: false
    }
    Process {
        id: btop
        command: ["sh", "-c", "kitty --start-as=fullscreen sh -c 'btop'"]
        running: false
    }
    Process {
        id: lockscreen
        command: ["sh", "-c", "~/.config/scripts/lock.sh"]
        running: false
        onExited: {
            running = false;
        }
    }
    Process {
        id: shutdown
        command: ["sh", "-c", "hyprctl dispatch exit"]
        running: false
    }
    Process {
        id: swaync
        command: ["sh", "-c", "swaync-client -t"]
        running: false
    }
    Process {
        id: printDebug
        command: ["sh", "-c", "echo 'Printing debug!'"]
        stdout: SplitParser {
            onRead: data => {
                console.log(root.debugValue);
            }
        }
    }
    Process {
        id: pid
        command: ["sh", "-c", "echo ${PPID}"]
        stdout: SplitParser {
            onRead: data => {
                console.log(data)
            }
        }
    }
}
