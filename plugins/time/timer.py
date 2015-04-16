#! /usr/bin/env python

from datetime import datetime
from time import sleep
from sys import stdout

start = datetime.now()
try:
    while True:
        print "\r{}    ".format(datetime.now() - start),
        stdout.flush()
        sleep(0.1)
except KeyboardInterrupt:
    exit(0)
except Exception as e:
    print e
    exit(1)
