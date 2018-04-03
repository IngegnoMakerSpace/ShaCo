import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

RowLayout {
    id: row

    Text {
        id: text1
        Layout.fillHeight: true
        Layout.preferredHeight: 80
        Layout.fillWidth: false
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("Temperature")

        font.pixelSize: 12
    }

    Slider {
        id: slider
        Layout.fillHeight: true
        Layout.preferredHeight: 80
        Layout.fillWidth: true

        value: 0.5
    }
}
