pragma Singleton
import QtQuick 2.15
import Quickshell

import "./."

Singleton {
    id: root
    readonly property int imageWidth: 64

    // default tos when on ground
    readonly property var groundTos: {
        "standing-left": 0,
        "standing-right": 0,
        "walking-left": 0,
        "walking-right": 0
    }

    // Qt6 still on ECMA7... can't do spread operator on objects... :(
    function newTos(defaultObject, overrides) {
        var result = {};
        for (var key in defaultObject) {
            result[key] = defaultObject[key]; // Copy default values
        }
        for (var key in overrides) {
            result[key] = overrides[key];
        }
        return result;
    }

    readonly property list<Sprite> slist: [
        BasicSprite {
            name: "standing-left"
            frameCount: 1
            frameX: root.imageWidth * 6
            frameY: root.imageWidth * 1
            to: root.newTos(root.groundTos, {
                "standing-left": 100,
                "standing-right": 50,
                "walking-left": 50
            })
        },
        BasicSprite {
            name: "standing-right"
            frameCount: 1
            frameX: root.imageWidth * 6
            frameY: root.imageWidth * 0
            to: root.newTos(root.groundTos, {
                "standing-right": 100,
                "standing-left": 50,
                "walking-right": 50
            })
        },
        BasicSprite {
            name: "walking-left"
            frameCount: 6
            reverse: true
            frameX: root.imageWidth * 0
            frameY: root.imageWidth * 1
            to: root.newTos(root.groundTos, {
                "standing-left": 50,
                "walking-left": 100
            })
        },
        BasicSprite {
            name: "walking-right"
            frameCount: 6
            frameX: root.imageWidth * 0
            frameY: root.imageWidth * 0
            to: root.newTos(root.groundTos, {
                "standing-right": 50,
                "walking-right": 100
            })
        },
        BasicSprite {
            name: "dying"
            frameCount: 3
            frameX: root.imageWidth * 0
            frameY: root.imageWidth * 2
            to: {
                "explosion1": 100
            }
            frameRate: 1
        },
        BasicSprite {
            name: "explosion1"
            frameCount: 8
            frameX: root.imageWidth * 0
            frameY: root.imageWidth * 3
            to: {
                "explosion2": 100
            }
            frameRate: 16
        },
        BasicSprite {
            name: "explosion2"
            frameCount: 8
            frameX: root.imageWidth * 0
            frameY: root.imageWidth * 4
            to: {
                "dead": 100
            }
            frameRate: 16
        },
        BasicSprite {
            name: "dead"
            frameCount: 1
            frameX: root.imageWidth * 0
            frameY: root.imageWidth * 5
            to: {
                "dead": 100
            }
            frameRate: 4
        }
    ]
}
