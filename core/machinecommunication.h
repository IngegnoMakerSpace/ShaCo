#ifndef MACHINECOMMUNICATION_H
#define MACHINECOMMUNICATION_H

#include <memory>
#include <QList>
#include <QObject>
#include "portdiscovery.h"
#include "machineinfo.h"
#include "serialport.h"

class MachineCommunication : public QObject
{
    Q_OBJECT

public:
    MachineCommunication(unsigned int hardResetDelay);

    const MachineInfo* machineInfo() const; // returns nullptr before a machine is initialized

public slots:
    void portFound(MachineInfo* info, AbstractPortDiscovery* portDiscoverer);
    void writeData(QByteArray data);
    void writeLine(QByteArray data); // Like writeData but adds \n at the end of data
    void closePortWithError(QString reason);
    void closePort();
    void feedHold();
    void resumeFeedHold();
    void softReset(); // Be careful: after this the firmare will probably go alarm and require a hard reset
    void hardReset(); // Closes and re-open port. Emits machineInitialized
    void setCharacterSendDelayUs(unsigned long us);

signals:
    void dataSent(QByteArray data);
    // emitted whenever data is received
    void dataReceived(QByteArray data);
    // emitted when a complete message is received. The terminating "\r\n" is removed from the message
    void messageReceived(QByteArray message);
    void machineInitialized();
    void portClosedWithError(QString reason);
    void portClosed();

private slots:
    void readData();
    void errorOccurred();

private:
    QList<QByteArray> extractMessages();

    const unsigned int m_hardResetDelay;
    std::unique_ptr<SerialPortInterface> m_serialPort;
    QByteArray m_messageBuffer;
    const MachineInfo* m_machineInfo;
};

#endif // MACHINECOMMUNICATION_H
