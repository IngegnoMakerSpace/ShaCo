import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "shacoutils.js" as ShaCoUtils

ColumnLayout{
    id: root

    property var selectedItem: (grid.currentItem !== null) ? theShape : null

    onVisibleChanged: {
        if (visible === true) {
            timer.stop()
        }

        detailsDialog.visible = false
    }

    QtObject {
        id: theShape

        property string name: ""
        property string image: ""
        property string gcode: ""
        property int duration: 0
        property string description: ""
        property double panelX: 0.0
        property double panelY: 0.0
        property string otherInfo: ""
    }

    GridView {
        id: grid
        Layout.fillHeight: true
        Layout.fillWidth: true
        cellHeight: cellSize
        cellWidth: width / Math.floor(width / cellSize)
        clip: true
        model: controller.localShapesModel
        currentIndex: -1

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
                source: "file:" + svgFilename
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

                onClicked: {
                    grid.currentIndex = index

                    theShape.name = name
                    theShape.image = "file:" + svgFilename
                    theShape.gcode = "file:" + gcodeFilename
                    theShape.duration = duration
                    theShape.description = "Generated by " + generatedBy + " on " + creationTime +
                            " for " + machineType
                    theShape.panelX = workpieceDimX
                    theShape.panelY = workpieceDimY
                    theShape.otherInfo = "Working time: " + ShaCoUtils.secondsToMMSS(duration) + "<br>Panel size: " +
                            ShaCoUtils.panelSize(workpieceDimX, workpieceDimY);
                }

                onPositionChanged: {
                    timer.restart()
                    detailsDialog.visible = false
                    detailsDialog.detailsX = parent.x + mouse.x
                    detailsDialog.detailsY = (parent.y - grid.visibleArea.yPosition * grid.contentHeight) + mouse.y

                    detailsDialog.imageSource = "file:" + svgFilename
                    detailsDialog.shapeName = "<b>" + name + "<\b>"
                    detailsDialog.shapeDescription = "Generated by " + generatedBy + " on " + creationTime +
                            " for " + machineType
                    detailsDialog.shapeOtherInfo = "Working time: " + ShaCoUtils.secondsToMMSS(duration) +
                            "<br>Panel size: " + ShaCoUtils.panelSize(workpieceDimX, workpieceDimY);
                }

                onExited: timer.stop()
            }
        }
    }

    Timer {
        id: timer
        interval: 1500
        running: false
        repeat: false

        onTriggered: detailsDialog.visible = true
    }

    Dialog {
        id: detailsDialog
        modal: false
        visible: false
        x: Math.min(detailsX, grid.width - width)
        y: header.height + Math.min(detailsY, grid.height - height)

        // These must be realtive to the grid frame of reference
        property real detailsX: 0
        property real detailsY: 0

        property string imageSource: ""
        property string shapeName: ""
        property string shapeDescription: ""
        property string shapeOtherInfo: ""

        onVisibleChanged:
            if (visible) {
                image.source = imageSource
                name.text = shapeName
                description.text = shapeDescription
                otherInfo.text = shapeOtherInfo
            }

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
