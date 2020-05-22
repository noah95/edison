#!/usr/bin/env python

# -*- coding: utf-8 -*-
# @Author: Noah Huetter
# @Date:   2020-05-22 09:03:32
# @Last Modified by:   Noah Huetter
# @Last Modified time: 2020-05-22 10:09:46

import argparse
import sys

class Edison(object):

  def __init__(self):
    parser = argparse.ArgumentParser(
      description='Edison Keyword Spotting tools',
      usage='''edison <module> <command> [<args>]

The modules:
    mic       Test microphone, analyze bit depths
    mcu       Tools to communicate with microcontroller
    mfcc      Mel frequency cepstral coefficient tools
    acquire   Collect training data
    train     Train network
    kws       Experiment with the keyword spotting algorithm
    deploy    Deploy the algorithm to microcontroller code

Run edison <module> for commands for the selected module
''')
    parser.add_argument('module', help='Which module to select')
    args = parser.parse_args(sys.argv[1:2])

    if not hasattr(self, args.module):
      print ('Unrecognized module')
      parser.print_help()
      exit(1)
    
    # use dispatch pattern to invoke method with same name
    getattr(self, args.module)()

  def mic(self):
    parser = argparse.ArgumentParser(
      description='Edison Keyword Spotting tools',
      usage='''edison mic <command> [<args>]

Commands
    bit_depth_analyze   Analyze different bit depths
    fetch_mic_samples   Get some mic samples from MCU
''')
    parser.add_argument('command', help='Command to run')
    args = parser.parse_args(sys.argv[2:3])
    
    if not hasattr(self, args.command):
      print ('Unrecognized command')
      parser.print_help()
      exit(1)

  def mcu(self):
    parser = argparse.ArgumentParser(
      description='Edison Keyword Spotting tools',
      usage='''edison mcu <command> [<args>]

Commands
    hif_test    Test host interface
''')
    parser.add_argument('command', help='Command to run')
    args = parser.parse_args(sys.argv[2:3])
    
    if not hasattr(self, args.command):
      print ('Unrecognized command')
      parser.print_help()
      exit(1)

  def mfcc(self):
    parser = argparse.ArgumentParser(
      description='Edison Keyword Spotting tools',
      usage='''edison mfcc <command> [<args>]

Commands
    host    Run MFCC on host
    mcu     Run MFCC on MCU
''')
    parser.add_argument('command', help='Command to run')
    args = parser.parse_args(sys.argv[2:3])
    
    if args.command == 'host':
      self.mfcc_host()
    elif args.command == 'mcu':
      self.mfcc_mcu()
    else:
      print ('Unrecognized command')
      parser.print_help()
      exit(1)

  def acquire(self):
    parser = argparse.ArgumentParser(
      description='Edison Keyword Spotting tools',
      usage='''edison acquire <command> [<args>]

Commands
    acq    Acquire samples for training
''')
    parser.add_argument('command', help='Command to run')
    args = parser.parse_args(sys.argv[2:3])
    
    if args.command == 'acq':
      self.acquire_acq()
    else:
      print ('Unrecognized command')
      parser.print_help()
      exit(1)

  def train(self):
    parser = argparse.ArgumentParser(
      description='Edison Keyword Spotting tools',
      usage='''edison train <command> [<args>]

Commands
    keras    Train the keras model
    legacy   Train the legacy model
    nnom     Train for NNoM implementation
    torch    Train PyTorch model
''')
    parser.add_argument('command', help='Command to run')
    args = parser.parse_args(sys.argv[2:3])
    
    if args.command == 'keras':
      self.train_keras()
    elif args.command == 'legacy':
      self.train_legacy()
    elif args.command == 'nnom':
      self.train_nnom()
    elif args.command == 'torch':
      self.train_torch()
    else:
      print ('Unrecognized command')
      parser.print_help()
      exit(1)

  def kws(self):
    parser = argparse.ArgumentParser(
      description='Edison Keyword Spotting tools',
      usage='''edison kws <command> [<args>]

Commands
    live    Run KWS live on host or MCU
    mcu     KWS piecewise on MCU
''')
    parser.add_argument('command', help='Command to run')
    args = parser.parse_args(sys.argv[2:3])
    
    if args.command == 'live':
      self.kws_live()
    if args.command == 'mcu':
      self.kws_mcu()
    else:
      print ('Unrecognized command')
      parser.print_help()
      exit(1)

  def deploy(self):
    parser = argparse.ArgumentParser(
      description='Edison Keyword Spotting tools',
      usage='''edison deploy <command> [<args>]

Commands
    nnom    Run NNoM to implement model
''')
    parser.add_argument('command', help='Command to run')
    args = parser.parse_args(sys.argv[2:3])
    
    if args.command == 'nnom':
      self.deploy_nnom()
    else:
      print ('Unrecognized command')
      parser.print_help()
      exit(1)

  ######################################################
  # Final commands to run

  def bit_depth_analyze(self):
    pass

  def fetch_mic_samples(self):
    pass

  def hif_test(self):
    pass

  def mfcc_host(self):
    pass

  def mfcc_mcu(self):
    pass

  def acquire_acq(self):
    import edison.acquire.sample_acq

  def train_keras(self):
    pass

  def train_legacy(self):
    pass

  def train_nnom(self):
    pass

  def train_torch(self):
    pass

  def kws_live(self):
    pass

  def kws_mcu(self):
    pass

  def deploy_nnom(self):
    pass

if __name__ == '__main__':
  Edison()