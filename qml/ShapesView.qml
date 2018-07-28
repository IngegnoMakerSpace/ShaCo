import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ColumnLayout{
    id: root

    property var hoveredComponent
    // These must be realtive to the grid frame of reference
    property real detailsX: 0
    property real detailsY: 0

    function selectedItem() {
        return grid.model.get(grid.currentIndex)
    }

    function showDialog() {
        if (root.selectedShapeItem !== null) {
            image.source = root.hoveredComponent.image
            name.text = "<b>" + root.hoveredComponent.name + "</b>"
            description.text = root.hoveredComponent.description
            category.text = "Category: <i>" + root.hoveredComponent.category + "</i>"
            otherInfo.text = "Working time: " + root.hoveredComponent.workingTime + "<br>" +
                    "Panel size: " + root.hoveredComponent.originalSize
            detailsDialog.visible = true
        }
    }

    onVisibleChanged: {
        if (visible === true) {
            timer.stop()
        } else {
            detailsDialog.visible = false
        }
    }

    GridView {
        id: grid
        Layout.fillHeight: true
        Layout.fillWidth: true
        cellHeight: cellSize
        cellWidth: width / Math.floor(width / cellSize)
        clip: true

        property real cellSize: 170
        property real borderWidth: 5

        highlight: Rectangle {
            color: "#00000000"
            border.width: grid.borderWidth
            border.color: "#d06804"
            radius: 3
        }

        delegate: Item {
            x: 0
            y: 0
            width: grid.cellSize
            height: grid.cellSize

            property real internalSize: grid.cellSize - 2 * grid.borderWidth

            Image {
                id: itemImage
                x: grid.borderWidth
                y: grid.borderWidth
                width: parent.internalSize
                height: parent.internalSize / 7 * 6
                source: image
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
            }

            Text {
                x: grid.borderWidth
                y: grid.borderWidth + itemImage.height
                width: parent.internalSize
                height: parent.height - itemImage.height
                text: name
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent

                onClicked: grid.currentIndex = index

                onPositionChanged: {
                    root.hoveredComponent = grid.model.get(index)
                    timer.restart()
                    detailsDialog.visible = false
                    root.detailsX = parent.x + mouse.x
                    root.detailsY = (parent.y - grid.visibleArea.yPosition * grid.contentHeight) + mouse.y
                }

                onExited: timer.stop()
            }
        }
    }

    Timer {
        id: timer
        interval: 1500
        running: false
        repeat:false

        onTriggered: root.showDialog()
    }

    Dialog {
        id: detailsDialog
        modal: false
        visible: false
        x: Math.min(root.detailsX, grid.width - width)
        y: header.height + Math.min(root.detailsY, grid.height - height)

        ColumnLayout {
            anchors.fill: parent

            Image {
                id: image
                Layout.fillHeight: false
                Layout.fillWidth: false
                Layout.preferredHeight: 240
                Layout.preferredWidth: 240
                fillMode: Image.PreserveAspectFit
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                id: name
                textFormat: Text.StyledText
                Layout.fillHeight: false
                Layout.fillWidth: false
                Layout.preferredWidth: 240
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: description
                textFormat: Text.StyledText
                wrapMode: Text.WordWrap
                Layout.fillHeight: false
                Layout.fillWidth: false
                Layout.preferredWidth: 240
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: category
                textFormat: Text.StyledText
                wrapMode: Text.WordWrap
                Layout.fillHeight: false
                Layout.fillWidth: false
                Layout.preferredWidth: 240
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: otherInfo
                textFormat: Text.StyledText
                Layout.fillHeight: false
                Layout.fillWidth: false
                Layout.preferredWidth: 240
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
