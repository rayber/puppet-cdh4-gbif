#!/usr/bin/env python

import sys
from string import join

DEFAULT_RACK = '/default/rack0'

RACK_MAP = {
  '130.226.238.171': '/switch1/rack1',
  '130.226.238.172': '/switch1/rack1',
  '130.226.238.173': '/switch1/rack1',
  '130.226.238.174': '/switch1/rack1',
  '130.226.238.175': '/switch1/rack1',
  '130.226.238.176': '/switch1/rack1',
  '130.226.238.177': '/switch1/rack1',
  '130.226.238.178': '/switch1/rack1',
  '130.226.238.179': '/switch1/rack1',
  '130.226.238.180': '/switch1/rack1',

  '130.226.238.161': '/switch1/rack2',
  '130.226.238.162': '/switch1/rack2',
  '130.226.238.163': '/switch1/rack2'
}

if len(sys.argv) == 1:
  print DEFAULT_RACK
else:
  print join([RACK_MAP.get(i, DEFAULT_RACK) for i in sys.argv[1:]], " ")
