# Check if the config file exists
!include(../common.pri) {
    error("Couldn't find the common.pri file!")
}

TEMPLATE = lib
TARGET = core
CONFIG += staticlib
QT += serialport
QT -= gui

HEADERS += \
    portdiscovery.h \
    serialport.h \
    machineinfo.h \
    machinecommunication.h \
    gcodesender.h \
    wirecontroller.h \
    machinestate.h \
    machinestatusmonitor.h \
    commandsender.h \
    immediatecommands.h \
    localshapesfinder.h \
    shapeinfo.h
SOURCES += \
    serialport.cpp \
    machineinfo.cpp \
    machinecommunication.cpp \
    gcodesender.cpp \
    wirecontroller.cpp \
    machinestate.cpp \
    machinestatusmonitor.cpp \
    commandsender.cpp \
    localshapesfinder.cpp \
    shapeinfo.cpp
