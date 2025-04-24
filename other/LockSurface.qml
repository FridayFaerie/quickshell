import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Wayland

Rectangle {
    id: root
    required property LockContext context

    property real fhdMultiplier: {
        let fhdMultiplierWidth = Math.round(Window.width * 10 / 1380);
        let fhdMultiplierHeight = Math.round(Window.height * 10 / 1080);
        let fhdMultiplier = Math.min(fhdMultiplierWidth, fhdMultiplierHeight) / 10;

        return fhdMultiplier < 0.1 ? 0.1 : fhdMultiplier > 2 ? 2 : fhdMultiplier.toFixed(1);
    }

    color: root.context.showFailure ? "#d7322d" : "#0078d7"
    Behavior on color {
        ColorAnimation {}
    }

    FontLoader {
        id: msfont
        source: "./font-light.ttf"
    }

    // Button {
    //     text: "Its not working, let me out"
    //     onClicked: context.unlocked();
    // }

    ColumnLayout {

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            topMargin: 100 * fhdMultiplier
            leftMargin: 205 * fhdMultiplier
        }

        width: 970 * fhdMultiplier

        RowLayout {
            Text {
                Layout.alignment: Qt.AlignLeft
                Layout.minimumWidth: 40

                color: "#ffffff"
                text: root.context.showFailure ? ">:(" : ":("

                font.family: msfont.font.family
                font.pixelSize: 210 * fhdMultiplier

                // The native font renderer tends to look nicer at large sizes.
                renderType: Text.NativeRendering

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        passwordBox.focus = true;
                    }
                }
            }

            RowLayout {
                id: surprise

                Layout.fillHeight: true
                visible: passwordBox.text.length > 0

                TextField {
                    id: passwordBox

                    implicitWidth: 800
                    Layout.leftMargin: 24 * fhdMultiplier

                    font.pixelSize: 64 * fhdMultiplier
                    background: Rectangle {
                        color: "transparent"
                    }

                    focus: true
                    enabled: !root.context.unlockInProgress
                    echoMode: TextInput.Password
                    inputMethodHints: Qt.ImhSensitiveData
                    color: "#ffffff"

                    onTextChanged: {
                        // Update the text in the context when the text in the box changes.
                        root.context.currentText = this.text;

                        this.implicitWidth = Math.max(implicitWidth, passwordMetrics.width + 20);
                    }

                    // Try to unlock when enter is pressed.
                    onAccepted: root.context.tryUnlock()

                    // Update the text in the box to match the text in the context.
                    // This makes sure multiple monitors have the same text.
                    Connections {
                        target: root.context

                        function onCurrentTextChanged() {
                            passwordBox.text = root.context.currentText;
                        }
                    }
                }

                TextMetrics {
                    id: passwordMetrics
                    font: passwordBox.font
                    text: "●".repeat(passwordBox.text.length + 1)
                }

                Text {
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 12 * fhdMultiplier

                    color: "#ffffff"
                    text: ")"

                    font.family: msfont.font.family
                    font.pixelSize: 210 * fhdMultiplier

                    // The native font renderer tends to look nicer at large sizes.
                    renderType: Text.NativeRendering
                }

                // appear animation
                opacity: visible ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                    }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 24 * fhdMultiplier
            Layout.topMargin: 10 * fhdMultiplier
            Layout.fillWidth: true

            color: "#ffffff"
            text: "Your device ran into a problem and has been locked.\nWe're just collecting some info, and then we'll sell it for you."
            wrapMode: Text.WordWrap

            font.family: msfont.font.family
            font.weight: 1
            font.pixelSize: 42 * fhdMultiplier
            font.letterSpacing: -0.2 * fhdMultiplier
            // TODO: lineHeight: 58 * fhdMultiplier
        }

        Text {
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 24 * fhdMultiplier
            Layout.topMargin: 35 * fhdMultiplier
            Layout.fillWidth: true

            color: "#ffffff"
            property int percentage: 0
            text: percentage + "% complete"
            wrapMode: Text.WordWrap
            font.pixelSize: 42 * fhdMultiplier
            font.letterSpacing: -0.2 * fhdMultiplier
            // TODO: lineHeight: 58 * fhdMultiplier

            NumberAnimation on percentage {
                to: 100
                duration: 90000
                easing.type: Easing.OutInExpo
            }
        }

        RowLayout {
            Layout.topMargin: 45 * fhdMultiplier
            Layout.leftMargin: 24 * fhdMultiplier
            width: parent.width

            Image {
                readonly property real preferredSize: stopcodeColumn.implicitHeight //100 * fhdMultiplier
                Layout.preferredHeight: preferredSize
                Layout.preferredWidth: preferredSize
                Layout.rightMargin: 28 * fhdMultiplier

                source: "./qr.png"
                smooth: false
            }

            ColumnLayout {
                id: stopcodeColumn

                Text {
                    Layout.bottomMargin: 36 * fhdMultiplier
                    Layout.topMargin: 6 * fhdMultiplier
                    Layout.fillWidth: true

                    wrapMode: Text.WordWrap
                    font.family: msfont.font.family
                    font.pixelSize: 19 * fhdMultiplier

                    color: "#ffffff"
                    text: "For more information about this issue and possible fixes, visit https://nixos.org"
                }

                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    font.family: msfont.font.family
                    font.pixelSize: 19 * fhdMultiplier

                    color: "#ffffff"
                    text: "If you call a support person, give them this info:\nStop code: LOCKED_SCREEN"
                }
            }
        }
    }
}
