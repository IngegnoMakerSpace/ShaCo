import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

ColumnLayout {
    id: root

    signal back

    RowLayout {
        id: row
        Layout.fillHeight: false
        Layout.preferredHeight: 80
        Layout.fillWidth: true

        Button {
            id: button
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.margins: 3
            text: qsTr("Reload")
        }

        Text {
            id: item3
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.margins: 3
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Hourglass")
        }

        Item {
            Layout.fillWidth: true
        }

        FilterControl {
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.margins: 3
        }

        SortControl {
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.margins: 3
        }
    }

    GridView {
        id: gridView
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.margins: 3
        cellHeight: 70
        clip: true

        model: ListModel {
            ListElement {
                name: "Grey"
                colorCode: "grey"
            }

            ListElement {
                name: "Red"
                colorCode: "red"
            }

            ListElement {
                name: "Blue"
                colorCode: "blue"
            }

            ListElement {
                name: "Green"
                colorCode: "green"
            }
        }
        delegate: Item {
            x: 5
            height: 50
            Column {
                spacing: 5
                Rectangle {
                    width: 40
                    height: 40
                    color: colorCode
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    x: 5
                    text: name
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
        cellWidth: 70
    }

    RowLayout {
        id: row1
        Layout.fillHeight: false
        Layout.preferredHeight: 80
        Layout.fillWidth: true

        Button {
            id: button1
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.margins: 3
            text: qsTr("Back")

            onClicked: root.back()
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            id: button2
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.margins: 3
            text: qsTr("Download")
        }
    }
}
