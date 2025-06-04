#include "fileparser.h"
#include <fstream>
#include <QDebug>

std::ifstream FileParser::openFile(const QString &filePath) {
    std::ifstream file(filePath.toStdString());
    if (!file.is_open()) {
        return {};
    }
    return file;
}

QVector<MeasurementData> FileParser::parseFile(const QString &filePath) {
    std::ifstream file = openFile(filePath);
    if (!file.is_open()) {
        return {};
    }

    file.seekg(0, std::ios_base::end);
    std::streampos end_pos = file.tellg();

    const size_t stringSize = 56;
    size_t estimatedLines = end_pos / stringSize;

    QVector<MeasurementData> result;
    result.reserve(estimatedLines);

    file.seekg(0);

    std::string line;
    while (std::getline(file, line)) {
        if (line.empty() || line[0] == '#' || line[0] == '!') {
            continue;
        }

        const char* ptr = line.c_str();
        char* end;

        double freq = std::strtod(ptr, &end);
        if (ptr == end) continue;
        ptr = end;

        double real = std::strtod(ptr, &end);
        if (ptr == end) continue;
        ptr = end;

        double imag = std::strtod(ptr, &end);
        if (ptr == end) continue;

        MeasurementData data;
        data.setFrequency(freq);
        data.setS11Real(real);
        data.setS11Imag(imag);
        result.append(data);
    }

    qDebug() << result.size();
    return result;
}
