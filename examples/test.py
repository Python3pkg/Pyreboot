import os
import sys
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import argparse

try:
    from Pyreboot import *
except ImportError:
    raise RuntimeError("install pyreboot")


DESCRIPTION = 'simple example program, that will show you how to use pyreboot'
USAGE = 'python main.py [-d|-g|-n]'
PROG = 'pyreboot example'


def _default(rebooter):
    print(rebooter)

    print('starting rebooter')
    rebooter.start()

    if rebooter.failed:
        print('rebooter failed')
        rebooter.reset()

def _dummy():
    rebooter = DummyRebooter(DummyRebooter.RebootCodes.power_off)
    _default(rebooter)

def _notify():
    title = 'Rebooting'
    msg = 'this is an example'
    rebooter = NotifyRebooter(NotifyRebooter.RebootCodes.power_off, title, msg, force=True)
    _default(rebooter)

def _gtk():
    msg = 'Rebooting'
    rebooter = GtkDialogRebooter(GtkDialogRebooter.RebootCodes.power_off, msg, force=True)
    _default(rebooter)

def test():
    parser = argparse.ArgumentParser(prog=PROG, description=DESCRIPTION, usage=USAGE)
    parser.add_argument('-d', dest='dummy', help='allows you to execute dummy example',  action='store_true', default=False)
    parser.add_argument('-g', dest='gtk', help='allows you to execute gtk example', action='store_true', default=False)
    parser.add_argument('-n', dest='notify', help='allows you to execute notify example', action='store_true', default=False)

    args = parser.parse_args()
    if args.dummy:
        return _dummy()

    if args.gtk:
        return _gtk()

    if args.notify:
        return _notify()

    parser.print_help()

test()