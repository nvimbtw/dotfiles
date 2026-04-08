import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Scope {
    id: root

    // Rose-pine Palette
    readonly property color colorBase: "#191724"
    readonly property color colorSurface: "#1f1d2e"
    readonly property color colorOverlay: "#26233a"
    readonly property color colorFoam: "#9ccfd8"
    readonly property color colorPine: "#31748f"
    readonly property color colorIris: "#c4a7e7"
    readonly property color colorGold: "#f6c177"
    readonly property color colorLove: "#eb6f92"
    readonly property color colorText: "#e0def4"
    readonly property color colorMuted: "#6e6a86"

    property string currentTime: ""
    property string currentDate: ""
    property var workspaces: []
    property var battery: ({
            capacity: 0,
            icon: "󰂎",
            status: "Unknown",
            time_left: "",
            class: "battery-normal",
            display: "󰂎 0%"
        })
    property string network: ""
    property string volume: ""
    property bool wifiMenuActive: false

    // Clock Logic
    function updateTime() {
        const now = new Date();
        const clockIcons = ["󱑋", "󱑌", "󱑍", "󱑎", "󱑏", "󱑐", "󱑑", "󱑒", "󱑓", "󱑔", "󱑕", "󱑖"];
        let hour = now.getHours() % 12;
        if (hour === 0)
            hour = 12;
        const icon = clockIcons[hour - 1];
        currentTime = icon + " " + Qt.formatDateTime(now, "hh:mm");
        currentDate = Qt.formatDateTime(now, "ddd, MMM d");
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.updateTime()
    }

    // Data Collectors
    Process {
        command: ["nu", "/home/x_x/.config/eww/scripts/workspaces.sh"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.workspaces = JSON.parse(data);
                } catch (e) {
                    console.error("Failed to parse workspaces:", e);
                }
            }
        }
    }

    Process {
        command: ["nu", "/home/x_x/.config/eww/scripts/battery.sh"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.battery = JSON.parse(data);
                } catch (e) {
                    console.error("Failed to parse battery:", e);
                }
            }
        }
    }

    Process {
        command: ["bash", "/home/x_x/.config/eww/scripts/network.sh"]
        running: true
        stdout: SplitParser {
            onRead: data => root.network = data.trim()
        }
    }

    Process {
        command: ["bash", "/home/x_x/.config/eww/scripts/volume.nu"]
        running: true
        stdout: SplitParser {
            onRead: data => root.volume = data.trim()
        }
    }

    Variants {
        model: Quickshell.screens

        Scope {
            required property var modelData

            PanelWindow {
                id: window
                screen: modelData

                WifiMenu {
                    id: wifiMenu
                    active: root.wifiMenuActive
                    anchor.window: window
                    anchor.item: networkArea
                    anchor.edges: Edges.Bottom
                    anchor.gravity: Edges.Bottom

                    // Center the popup (250px) under the network area
                    anchor.rect.x: (networkArea.width / 2) - (250 / 2)

                    colors: ({
                            base: root.colorBase,
                            surface: root.colorSurface,
                            iris: root.colorIris,
                            foam: root.colorFoam,
                            muted: root.colorMuted,
                            love: root.colorLove
                        })
                }

                anchors {
                    top: true
                    left: true
                    right: true
                }

                height: 30
                color: root.colorBase

                // Custom border bottom
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: root.colorMuted
                    opacity: 0.3
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    // LEFT SECTION
                    RowLayout {
                        Layout.alignment: Qt.AlignLeft
                        spacing: 0

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.preferredWidth: leftContent.implicitWidth + 30
                            color: root.colorSurface

                            RowLayout {
                                id: leftContent
                                anchors.centerIn: parent
                                spacing: 15

                                Text {
                                    text: root.currentDate
                                    color: root.colorFoam
                                    font.pixelSize: 13
                                    font.bold: true
                                }

                                Text {
                                    text: "󰇝"
                                    color: root.colorMuted
                                    font.pixelSize: 14
                                }

                                Text {
                                    text: root.currentTime
                                    color: root.colorFoam
                                    font.pixelSize: 13
                                    font.bold: true
                                }
                            }
                        }

                        Text {
                            text: ""
                            color: root.colorSurface
                            font.pixelSize: 22
                            Layout.alignment: Qt.AlignVCenter
                        }

                        // Workspaces
                        RowLayout {
                            id: workspaceRow
                            Layout.leftMargin: 15
                            Layout.rightMargin: 15
                            spacing: 15

                            Text {
                                text: " "
                                color: root.colorIris
                                font.pixelSize: 16
                            }

                            Repeater {
                                model: root.workspaces
                                delegate: Item {
                                    Layout.preferredWidth: wsText.implicitWidth
                                    Layout.preferredHeight: 20

                                    Text {
                                        id: wsText
                                        anchors.centerIn: parent
                                        text: modelData.id
                                        color: modelData.active ? root.colorIris : root.colorMuted
                                        font.pixelSize: 13
                                        font.bold: true

                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 300
                                            }
                                        }
                                    }

                                    Rectangle {
                                        anchors.bottom: wsText.bottom
                                        anchors.bottomMargin: -4
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: modelData.active ? parent.width : 0
                                        height: 2
                                        color: root.colorIris
                                        radius: 1

                                        Behavior on width {
                                            NumberAnimation {
                                                duration: 300
                                                easing.type: Easing.OutQuint
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // SPACER
                    Item {
                        Layout.fillWidth: true
                    }

                    // RIGHT SECTION
                    RowLayout {
                        Layout.alignment: Qt.AlignRight
                        spacing: 0

                        // Network info with subtle animation
                        MouseArea {
                            id: networkArea
                            Layout.preferredWidth: networkText.implicitWidth + 20
                            Layout.fillHeight: true
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: root.wifiMenuActive = !root.wifiMenuActive

                            Text {
                                id: networkText
                                anchors.centerIn: parent
                                text: root.network
                                color: parent.containsMouse || root.wifiMenuActive ? root.colorFoam : root.colorIris
                                font.pixelSize: 13
                                opacity: root.network ? 1 : 0
                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 500
                                    }
                                }
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                            }
                        }

                        Text {
                            text: ""
                            color: root.colorSurface
                            font.pixelSize: 26 // Larger to ensure full height coverage
                            Layout.alignment: Qt.AlignVCenter
                            Layout.rightMargin: -4 // Deeper overlap to hide font padding
                        }

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.preferredWidth: rightContent.implicitWidth + 30
                            color: root.colorSurface

                            RowLayout {
                                id: rightContent
                                anchors.centerIn: parent
                                spacing: 15

                                // Search Button
                                MouseArea {
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    cursorShape: Qt.PointingHandCursor
                                    hoverEnabled: true
                                    onClicked: {
                                        const proc = Quickshell.createProcess(["eww", "open", "--toggle", "console"]);
                                        proc.start();
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: " "
                                        color: parent.containsMouse ? root.colorIris : root.colorFoam
                                        font.pixelSize: 13
                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 200
                                            }
                                        }
                                    }
                                }

                                // Battery
                                Text {
                                    id: batteryText
                                    text: root.battery.display || ""
                                    color: root.battery.class === "battery-low" ? root.colorLove : root.colorFoam
                                    font.pixelSize: 13
                                    font.bold: true

                                    ToolTip.visible: batteryHover.containsMouse
                                    ToolTip.text: root.battery.time_left || ""
                                    ToolTip.delay: 500

                                    MouseArea {
                                        id: batteryHover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                    }

                                    // Subtle pulse for low battery
                                    SequentialAnimation on opacity {
                                        running: root.battery.class === "battery-low"
                                        loops: Animation.Infinite
                                        NumberAnimation {
                                            to: 0.6
                                            duration: 1000
                                            easing.type: Easing.InOutSine
                                        }
                                        NumberAnimation {
                                            to: 1.0
                                            duration: 1000
                                            easing.type: Easing.InOutSine
                                        }
                                    }
                                }

                                Text {
                                    text: "󰇝"
                                    color: root.colorMuted
                                    font.pixelSize: 14
                                }

                                // Volume with fallback icons
                                RowLayout {
                                    spacing: 4
                                    property int volLevel: {
                                        const v = root.volume || "";
                                        const match = v.match(/(\d+)/);
                                        return match ? parseInt(match[1]) : 0;
                                    }

                                    Text {
                                        text: {
                                            const v = root.volume || "";
                                            if (v.includes("󰋋"))
                                                return "󰋋";
                                            if (v.includes("󰝟") || parent.volLevel === 0)
                                                return "󰝟";
                                            if (parent.volLevel <= 30)
                                                return "󰕿";
                                            if (parent.volLevel <= 70)
                                                return "󰖀";
                                            return "󰕾";
                                        }
                                        color: root.colorFoam
                                        font.pixelSize: 14
                                    }

                                    Text {
                                        text: (parent.volLevel || 0) + "%"
                                        color: root.colorFoam
                                        font.pixelSize: 13
                                        font.bold: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
