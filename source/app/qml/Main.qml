import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import com.example 1.0

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("S1P File Analyzer")

    property string fileName: "No file selected"
    property var measurementData: []
    property real minFreq: 0
    property real maxFreq: 1
    property real minLogMag: -100
    property real maxLogMag: 0

    FileParser {
        id: fileParser
    }

    DataProcessor {
        id: dataProcessor
    }

    FileDialog {
        id: fileDialog
        title: "Please choose an S1P file"
        nameFilters: ["S1P files (*.s1p)", "All files (*)"]
        onAccepted: {
            fileName = selectedFile.toString().replace("file://", "")
            var rawData = fileParser.parseFile(fileName)
            if (rawData.length > 0) {
                measurementData = dataProcessor.processData(rawData)
                calculateBounds()
                canvas.requestPaint()
            } else {
                errorDialog.text = "Failed to parse the file. Invalid format or empty."
                errorDialog.open()
            }
        }
    }

    function calculateBounds() {
        if (measurementData.length === 0) return
        minFreq = measurementData[0].frequency

        maxFreq = measurementData[0].frequency
        minLogMag = measurementData[0].s11Logmag
        maxLogMag = measurementData[0].s11Logmag

        for (var i = 1; i < measurementData.length; i++) {
            var point = measurementData[i]
            minFreq = Math.min(minFreq, point.frequency)
            maxFreq = Math.max(maxFreq, point.frequency)
            minLogMag = Math.min(minLogMag, point.s11Logmag)
            maxLogMag = Math.max(maxLogMag, point.s11Logmag)
        }

        // Добавляем небольшие отступы по краям
        var freqRange = maxFreq - minFreq
        minFreq -= freqRange * 0.05
        maxFreq += freqRange * 0.05

        var magRange = maxLogMag - minLogMag
        minLogMag -= magRange * 0.1
        maxLogMag += magRange * 0.1
    }

    MessageDialog {
        id: errorDialog
        title: "Error"
        buttons: MessageDialog.Ok
    }

    Column {
        anchors.fill: parent
        spacing: 10
        padding: 10

        Row {
            spacing: 20
            Button {
                text: "Load S1P File"
                onClicked: fileDialog.open()
            }
            Text {
                text: "Selected file: " + fileName
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
                height: parent.height
            }
        }

        Rectangle {
            id: graphContainer
            width: parent.width - 20
            height: parent.height - 100
            border.color: "gray"
            border.width: 1
            color: "white"

            Canvas {
                id: canvas
                anchors.fill: parent
                anchors.margins: 10

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    // Очищаем canvas
                    ctx.fillStyle = "white"
                    ctx.fillRect(0, 0, width, height)

                    // Рисуем оси
                    ctx.strokeStyle = "black"
                    ctx.lineWidth = 2
                    ctx.beginPath()

                    // Ось Y (LogMag)
                    ctx.moveTo(50, 20)
                    ctx.lineTo(50, height - 30)

                    // Ось X (Frequency)
                    ctx.moveTo(50, height - 30)
                    ctx.lineTo(width - 20, height - 30)
                    ctx.stroke()

                    // Подписи осей
                    ctx.font = "14px Arial"
                    ctx.fillStyle = "black"
                    ctx.fillText("Frequency (Hz)", width/2 - 50, height - 5)
                    ctx.save()
                    ctx.translate(20, height/2)
                    ctx.rotate(-Math.PI/2)
                    ctx.fillText("S11 (LogMag dB)", 0, 0)
                    ctx.restore()

                    // Разметка осей
                    ctx.font = "10px Arial"
                    ctx.strokeStyle = "lightgray"
                    ctx.lineWidth = 0.5

                    // Горизонтальные линии (LogMag)
                    var logMagSteps = 10
                    for (var i = 0; i <= logMagSteps; i++) {
                        var y = 20 + (height - 50) * i / logMagSteps
                        ctx.beginPath()
                        ctx.moveTo(50, y)
                        ctx.lineTo(width - 20, y)
                        ctx.stroke()

                        var logMagValue = maxLogMag - (maxLogMag - minLogMag) * i / logMagSteps
                        ctx.fillText(logMagValue.toFixed(1), 30, y + 3)
                    }

                    // Вертикальные линии (Frequency)
                    var freqSteps = 10
                    for (var j = 0; j <= freqSteps; j++) {
                        var x = 50 + (width - 70) * j / freqSteps
                        ctx.beginPath()
                        ctx.moveTo(x, 20)
                        ctx.lineTo(x, height - 30)
                        ctx.stroke()

                        var freqValue = minFreq + (maxFreq - minFreq) * j / freqSteps
                        ctx.fillText((freqValue/1e6).toFixed(2) + "M", x - 20, height - 20)
                    }

                    // Рисуем график
                    if (measurementData.length === 0) return

                    ctx.strokeStyle = "blue"
                    ctx.lineWidth = 2
                    ctx.beginPath()

                    var firstPoint = measurementData[0]
                    var x = 50 + (width - 70) * (firstPoint.frequency - minFreq) / (maxFreq - minFreq)
                    var y = 20 + (height - 50) * (maxLogMag - firstPoint.s11Logmag) / (maxLogMag - minLogMag)
                    ctx.moveTo(x, y)

                    for (var k = 1; k < measurementData.length; k++) {
                        var point = measurementData[k]
                        x = 50 + (width - 70) * (point.frequency - minFreq) / (maxFreq - minFreq)
                        y = 20 + (height - 50) * (maxLogMag - point.s11Logmag) / (maxLogMag - minLogMag)
                        ctx.lineTo(x, y)
                    }

                    ctx.stroke()
                }
            }
        }
    }
}
