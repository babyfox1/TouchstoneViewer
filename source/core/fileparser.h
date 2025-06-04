#pragma once

#include <QObject>
#include <QVector>
#include "measurementdata.h"
#include <fstream>

class FileParser : public QObject
{
    Q_OBJECT
public:
    explicit FileParser(QObject *parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE QVector<MeasurementData> parseFile(const QString &filePath);
    std::ifstream openFile(const QString &filePath);
};
