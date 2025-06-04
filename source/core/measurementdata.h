#pragma once
#include <QObject>


class MeasurementData
{
    Q_GADGET
    Q_PROPERTY(double frequency READ frequency WRITE setFrequency)
    Q_PROPERTY(double s11Real READ s11Real WRITE setS11Real)
    Q_PROPERTY(double s11Imag READ s11Imag WRITE setS11Imag)
    Q_PROPERTY(double s11Logmag READ s11Logmag WRITE setS11Logmag)
public:

    double frequency() const { return m_frequency; }
    void setFrequency(double frequency) { m_frequency = frequency; }

    double s11Real() const { return m_s11_real; }
    void setS11Real(double real) { m_s11_real = real; }

    double s11Imag() const { return m_s11_imag; }
    void setS11Imag(double imag) { m_s11_imag = imag; }

    double s11Logmag() const { return m_s11_logmag; }
    void setS11Logmag(double logmag) { m_s11_logmag = logmag; }

private:
    double m_frequency = 0.0;
    double m_s11_real = 0.0;
    double m_s11_imag = 0.0;
    double m_s11_logmag = 0.0;
};
Q_DECLARE_METATYPE(MeasurementData)



