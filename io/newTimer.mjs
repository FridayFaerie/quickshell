// from https://git.allpurposem.at/mat/Quickbar
// from https://github.com/nydragon/nysh

export function Timer(parent) {
  return Qt.createQmlObject("import QtQuick; Timer{}", parent);
}

export function after(delay, parent, callback) {
  const timer = new Timer(parent);
  timer.interval = delay;
  timer.triggered.connect(callback);
  timer.start();
}
