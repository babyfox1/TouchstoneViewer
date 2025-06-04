#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuickControls2/QQuickStyle>
#include <measurementdata.h>
#include <dataprocessor.h>
#include <fileparser.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qRegisterMetaType<QVector<MeasurementData>>();
    qmlRegisterType<FileParser>("com.example", 1, 0, "FileParser");
    qmlRegisterType<DataProcessor>("com.example", 1, 0, "DataProcessor");

    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    engine.loadFromModule("touchviewer", "Main");

    return app.exec();
}
