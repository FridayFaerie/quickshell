import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
    LockContext {
        id: lockcontext
        onUnlocked: {
             // Unlock the screen before exiting, or the compositor will display a
             // fallback lock you can't interact with.
             sessionlock.locked = false;

             Qt.quit()
         }
    }

    WlSessionLock {
        id: sessionlock
        locked: true

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockcontext
            }
        }
    }
}
