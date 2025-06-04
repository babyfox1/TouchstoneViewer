#include "measurementdata.h"
#include "dataprocessor.h"

QVector<MeasurementData> DataProcessor::processData(QVector<MeasurementData> data) {
    QVector<MeasurementData> result;
    for (auto &item : data) {
        double magnitude = std::sqrt(item.s11Real() * item.s11Real() + item.s11Imag() * item.s11Imag());
        item.setS11Logmag(20 * std::log10(magnitude));
        result.append(item);
    }
    return result;
}
