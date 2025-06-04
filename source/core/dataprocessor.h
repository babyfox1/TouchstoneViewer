#pragma once

#include <QObject>
#include <QVector>
#include "measurementdata.h"

class DataProcessor : public QObject {
    Q_OBJECT
public:
    explicit DataProcessor(QObject *parent = nullptr) : QObject(parent){}
    Q_INVOKABLE QVector<MeasurementData> processData(QVector<MeasurementData> data);
};
