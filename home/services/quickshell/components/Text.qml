import QtQuick
import QtQuick.Effects
import qs.utils

Item {
    id: root

    property alias text: textItem.text
    property alias font: textItem.font
    property alias color: textItem.color
    property alias renderType: textItem.renderType
    property alias wrapMode: textItem.wrapMode
    property alias elide: textItem.elide
    property alias maximumLineCount: textItem.maximumLineCount
    property alias horizontalAlignment: textItem.horizontalAlignment
    property alias verticalAlignment: textItem.verticalAlignment

    property bool shadowEnabled: true

    implicitWidth: textItem.implicitWidth
    implicitHeight: textItem.implicitHeight

    MultiEffect {
        source: textItem
        anchors.fill: textItem
        shadowEnabled: root.shadowEnabled
        shadowVerticalOffset: Config.shadowVerticalOffset
        blurMax: Config.blurMax
        opacity: Config.shadowOpacity
    }

    Text {
        id: textItem

        anchors.fill: parent
        renderType: Text.NativeRendering
        color: Colors.foreground
    }
}
