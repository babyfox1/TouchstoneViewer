#include "gtest/gtest.h"
#include "dataprocessor.h"
#include "fileparser.h"
#include <QFile>
#include <QTextStream>
#include <QTemporaryFile>

TEST(FileParserTest, ParsesCorrectly) {
    QTemporaryFile tempFile;
    ASSERT_TRUE(tempFile.open());

    QTextStream out(&tempFile);
    out << "1.0 3.0 4.0\n";
    out.flush();
    tempFile.close();

    FileParser parser;
    QVector<MeasurementData> data = parser.parseFile(tempFile.fileName());

    EXPECT_DOUBLE_EQ(data[0].frequency(), 1.0);
    EXPECT_DOUBLE_EQ(data[0].s11Real(), 3.0);
    EXPECT_DOUBLE_EQ(data[0].s11Imag(), 4.0);
}


TEST(DataProcessorTest, ProcessesCorrectly) {
    QVector<MeasurementData> data;
    MeasurementData m;
    m.setFrequency(1.0);
    m.setS11Real(3.0);
    m.setS11Imag(4.0);
    data.append(m);

    DataProcessor processor;
    QVector<MeasurementData> processedData = processor.processData(data);

    double expectedMagnitude = std::sqrt(3.0 * 3.0 + 4.0 * 4.0);
    double expectedLogmag = 20 * std::log10(expectedMagnitude);

    EXPECT_NEAR(processedData[0].s11Logmag(), expectedLogmag, 1e-6);
}
