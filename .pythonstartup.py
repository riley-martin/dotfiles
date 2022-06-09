#!/usr/bin/env python3
import sys

red = "\001\033[31m\002"
green = "\001\033[32m\002"
blue = "\001\033[34m\002"
reset = "\001\033[m\002"
sys.ps1 = blue + ">>> " + reset
sys.ps2 = green + "... " + reset

