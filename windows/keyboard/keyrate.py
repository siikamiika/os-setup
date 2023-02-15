#!/usr/bin/env python3

import argparse
import ctypes
from ctypes import wintypes

# https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-systemparametersinfoa
# https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-filterkeys

SPI_SETFILTERKEYS = 0x0033

FKF_FILTERKEYSON = 0x00000001
FKF_AVAILABLE = 0x00000002

class FILTERKEYS(ctypes.Structure):
    _fields_ = [
        ('cbSize', wintypes.UINT),
        ('dwFlags', wintypes.DWORD),
        ('iWaitMsec', wintypes.DWORD),
        ('iDelayMsec', wintypes.DWORD),
        ('iRepeatMsec', wintypes.DWORD),
        ('iBounceMsec', wintypes.DWORD),
    ]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('delay', type=int)
    parser.add_argument('rate', type=int)
    args = parser.parse_args()

    filterKeys = FILTERKEYS(ctypes.sizeof(FILTERKEYS))
    filterKeys.dwFlags = FKF_AVAILABLE | FKF_FILTERKEYSON
    filterKeys.iDelayMsec = args.delay
    filterKeys.iRepeatMsec = args.rate

    ctypes.windll.user32.SystemParametersInfoA(SPI_SETFILTERKEYS, 0, ctypes.byref(filterKeys), 0)

if __name__ == '__main__':
    main()
