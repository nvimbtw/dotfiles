import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PopupWindow {
    id: wifiPopup

    property var colors: null
    property bool active: false

    visible: active
    width: 250
    height: 350

    color: "transparent"

    readonly property color colorBase: colors ? colors.base : "#191724"
    readonly property color colorSurface: colors ? colors.surface : "#1f1d2e"
    readonly property color colorIris: colors ? colors.iris : "#c4a7e7"
    readonly property color colorFoam: colors ? colors.foam : "#9ccfd8"
    readonly property color colorMuted: colors ? colors.muted : "#6e6a86"
    readonly property color colorLove: colors ? colors.love : "#eb6f92"

    property var wifiList: []
    property var selectedNetwork: null
    property bool showPasswordPrompt: false
    property string statusMessage: ""

    Process {
        id: wifiScanner
        command: ["nmcli", "-t", "-f", "SSID,SIGNAL,SECURITY,ACTIVE", "dev", "wifi", "list"]
        running: false

        stdout: StdioCollector {
            id: wifiOutput
            onStreamFinished: {
                let lines = wifiOutput.text.trim().split("\n");
                let list = [];
                for (let line of lines) {
                    if (!line)
                        continue;
                    let parts = line.split(":");
                    if (parts.length >= 4 && parts[0]) {
                        list.push({
                            ssid: parts[0],
                            signal: parseInt(parts[1]),
                            security: parts[2],
                            active: parts[3] === "yes"
                        });
                    }
                }
                if (list.length > 0) {
                    list.sort((a, b) => b.signal - a.signal);
                    wifiPopup.wifiList = list;
                }
            }
        }
    }

    Process {
        id: wifiConnector
        property string ssid: ""
        property string password: ""

        command: password ? ["nmcli", "device", "wifi", "connect", ssid, "password", password] : ["nmcli", "device", "wifi", "connect", ssid]
        running: false

        stdout: StdioCollector {
            id: connectOutput
            onStreamFinished: {
                const out = connectOutput.text.trim();
                if (out.includes("successfully activated")) {
                    wifiPopup.statusMessage = "Connected!";
                    wifiPopup.showPasswordPrompt = false;
                    wifiPopup.selectedNetwork = null;
                    wifiScanner.running = true;
                } else {
                    wifiPopup.statusMessage = "Failed to connect.";
                }
            }
        }
    }

    onActiveChanged: {
        if (active) {
            wifiScanner.running = true;
        } else {
            wifiPopup.wifiList = [];
            wifiPopup.showPasswordPrompt = false;
            wifiPopup.selectedNetwork = null;
            wifiPopup.statusMessage = "";
        }
    }

    Rectangle {
        anchors.fill: parent
        color: wifiPopup.colorBase
        border.color: wifiPopup.colorMuted
        border.width: 1
        radius: 8
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Header
            RowLayout {
                Layout.fillWidth: true

                MouseArea {
                    visible: wifiPopup.showPasswordPrompt
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        wifiPopup.showPasswordPrompt = false;
                        wifiPopup.selectedNetwork = null;
                        wifiPopup.statusMessage = "";
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "󰁍"
                        color: wifiPopup.colorFoam
                        font.pixelSize: 16
                    }
                }

                Text {
                    text: wifiPopup.showPasswordPrompt ? (wifiPopup.selectedNetwork ? wifiPopup.selectedNetwork.ssid : "") : "Available Networks"
                    color: wifiPopup.colorIris
                    font.pixelSize: 14
                    font.bold: true
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                MouseArea {
                    visible: !wifiPopup.showPasswordPrompt
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        wifiPopup.wifiList = [];
                        wifiPopup.statusMessage = "";
                        wifiScanner.running = true;
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "󰑐"
                        color: wifiPopup.colorFoam
                        font.pixelSize: 16
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: wifiPopup.colorMuted
                opacity: 0.3
            }

            // Status message
            Text {
                visible: wifiPopup.statusMessage !== ""
                Layout.fillWidth: true
                text: wifiPopup.statusMessage
                color: wifiPopup.statusMessage === "Connected!" ? wifiPopup.colorFoam : wifiPopup.colorLove
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
            }

            // Password prompt
            ColumnLayout {
                visible: wifiPopup.showPasswordPrompt
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "Password"
                    color: wifiPopup.colorMuted
                    font.pixelSize: 12
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 36
                    color: wifiPopup.colorSurface
                    border.color: passwordInput.activeFocus ? wifiPopup.colorIris : wifiPopup.colorMuted
                    border.width: 1
                    radius: 4

                    Behavior on border.color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    TextInput {
                        id: passwordInput
                        anchors.fill: parent
                        anchors.margins: 8
                        color: wifiPopup.colorFoam
                        font.pixelSize: 13
                        echoMode: TextInput.Password
                        verticalAlignment: TextInput.AlignVCenter
                        focus: wifiPopup.showPasswordPrompt

                        onAccepted: connectBtn.connect()
                    }
                }

                // Show/hide password toggle
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    MouseArea {
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        property bool showing: false
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            showing = !showing;
                            passwordInput.echoMode = showing ? TextInput.Normal : TextInput.Password;
                        }
                        Text {
                            anchors.centerIn: parent
                            text: parent.showing ? "󰛐" : "󰛑"
                            color: wifiPopup.colorMuted
                            font.pixelSize: 14
                        }
                    }
                    Text {
                        text: "Show password"
                        color: wifiPopup.colorMuted
                        font.pixelSize: 11
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                }

                Rectangle {
                    id: connectBtn
                    Layout.fillWidth: true
                    height: 34
                    color: connectBtnHover.containsMouse ? wifiPopup.colorIris : wifiPopup.colorSurface
                    border.color: wifiPopup.colorIris
                    border.width: 1
                    radius: 4

                    function connect() {
                        if (!wifiPopup.selectedNetwork)
                            return;
                        wifiPopup.statusMessage = "Connecting...";
                        wifiConnector.ssid = wifiPopup.selectedNetwork.ssid;
                        wifiConnector.password = passwordInput.text;
                        wifiConnector.running = true;
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    MouseArea {
                        id: connectBtnHover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: connectBtn.connect()
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Connect"
                        color: connectBtnHover.containsMouse ? wifiPopup.colorBase : wifiPopup.colorIris
                        font.pixelSize: 13
                        font.bold: true
                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }
                }
            }

            // Network list
            ListView {
                visible: !wifiPopup.showPasswordPrompt
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: wifiPopup.wifiList
                spacing: 5
                clip: true

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 45
                    color: modelData.active ? wifiPopup.colorSurface : "transparent"
                    radius: 4

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: if (!modelData.active)
                            parent.color = Qt.rgba(1, 1, 1, 0.03)
                        onExited: if (!modelData.active)
                            parent.color = "transparent"
                        onClicked: {
                            if (modelData.active)
                                return;
                            wifiPopup.selectedNetwork = modelData;
                            if (modelData.security && modelData.security !== "--") {
                                passwordInput.text = "";
                                wifiPopup.statusMessage = "";
                                wifiPopup.showPasswordPrompt = true;
                            } else {
                                wifiPopup.statusMessage = "Connecting...";
                                wifiConnector.ssid = modelData.ssid;
                                wifiConnector.password = "";
                                wifiConnector.running = true;
                            }
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 12

                        Text {
                            text: {
                                if (modelData.signal >= 75)
                                    return "󰤨";
                                if (modelData.signal >= 50)
                                    return "󰤥";
                                if (modelData.signal >= 25)
                                    return "󰤢";
                                return "󰤟";
                            }
                            color: modelData.active ? wifiPopup.colorIris : wifiPopup.colorFoam
                            font.pixelSize: 18
                        }

                        ColumnLayout {
                            spacing: 2
                            Layout.fillWidth: true
                            Text {
                                text: modelData.ssid
                                color: wifiPopup.colorFoam
                                font.pixelSize: 13
                                font.bold: modelData.active
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            Text {
                                text: modelData.security || "Open"
                                color: wifiPopup.colorMuted
                                font.pixelSize: 10
                            }
                        }

                        Text {
                            text: modelData.active ? "󰄬" : ""
                            color: wifiPopup.colorIris
                            font.pixelSize: 14
                        }
                    }
                }

                Text {
                    visible: wifiPopup.wifiList.length === 0
                    anchors.centerIn: parent
                    text: "Scanning..."
                    color: wifiPopup.colorMuted
                    font.italic: true
                }
            }
        }
    }
}
