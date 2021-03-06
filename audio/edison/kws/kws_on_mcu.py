# -*- coding: utf-8 -*-
# @Author: Noah Huetter
# @Date:   2020-04-30 14:43:56
# @Last Modified by:   Noah Huetter
# @Last Modified time: 2020-05-28 15:32:51

import sys


import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile
from tqdm import tqdm
import simpleaudio as sa
import scipy.io.wavfile as wavfile

import keras
import tensorflow as tf
import edison.mfcc.mfcc_utils as mfu

# Settings
from config import *

model_file = cache_dir+'../../firmware/src/ai/cube/kws/kws_model.h5'
keywords = np.load(cache_dir+'kws_keras/keywords.npy')

from_file = 0

# define net type running on target (cube/nnom)
net_type = 'cube'

# Load trained model
model = keras.models.load_model(model_file)
model.summary()

input_shape = model.input.shape.as_list()[1:]
input_size = np.prod(input_shape)

cache_dir += '/kws_on_mcu/'
import pathlib
pathlib.Path(cache_dir).mkdir(parents=True, exist_ok=True)

######################################################################
# plottery
######################################################################

def plotTwoMfcc(mfcc_host, mfcc_mcu):
  frames = np.arange(mfcc_host.shape[0])
  melbin = np.arange(mfcc_host.shape[1])

  fig = plt.figure(constrained_layout=True)
  gs = fig.add_gridspec(1, 2)

  vmin = mfcc_host.min()
  vmax = mfcc_host.max()
  ax = fig.add_subplot(gs[0, 0])
  c = ax.pcolor(frames, melbin, mfcc_host.T, cmap='PuBu', vmin=vmin, vmax=vmax)
  ax.grid(True)
  ax.set_title('host MFCC')
  ax.set_xlabel('frame')
  ax.set_ylabel('Mel bin')
  fig.colorbar(c, ax=ax)

  vmin = mfcc_mcu.min()
  vmax = mfcc_mcu.max()
  ax = fig.add_subplot(gs[0, 1])
  c = ax.pcolor(frames, melbin, mfcc_mcu.T, cmap='PuBu', vmin=vmin, vmax=vmax)
  ax.grid(True)
  ax.set_title('MCU MFCC')
  ax.set_xlabel('frame')
  ax.set_ylabel('Mel bin')
  fig.colorbar(c, ax=ax)

  return fig

def plotAudioMfcc(audio, mfcc_host, mfcc_mcu):
  t = np.linspace(0, audio.shape[0]/fs, audio.shape[0])
  if mfcc_mcu is not None:
    frames = np.arange(mfcc_mcu.shape[0])
    melbin = np.arange(mfcc_mcu.shape[1])
  else:
    frames = np.arange(mfcc_host.shape[0])
    melbin = np.arange(mfcc_host.shape[1])

  fig = plt.figure(constrained_layout=True)
  gs = fig.add_gridspec(2, 2)

  ax = fig.add_subplot(gs[0, :])
  ax.plot(t, audio, label='audio')
  ax.grid(True)
  ax.set_title('microphone data')
  ax.set_xlabel('time [s]')
  ax.set_ylabel('amplitude')
  ax.legend()

  if mfcc_mcu is not None:
    vmin = mfcc_mcu.min()
    vmax = mfcc_mcu.max()
    ax = fig.add_subplot(gs[1, 1])
    c = ax.pcolor(frames, melbin, mfcc_mcu.T, cmap='PuBu', vmin=vmin, vmax=vmax)
    ax.grid(True)
    ax.set_title('MCU MFCC')
    ax.set_xlabel('frame')
    ax.set_ylabel('Mel bin')
    fig.colorbar(c, ax=ax)

  if mfcc_host is not None:
    vmin = mfcc_host.min()
    vmax = mfcc_host.max()
    ax = fig.add_subplot(gs[1, 0])
    c = ax.pcolor(frames, melbin, mfcc_host.T, cmap='PuBu', vmin=vmin, vmax=vmax)
    ax.grid(True)
    ax.set_title('host MFCC')
    ax.set_xlabel('frame')
    ax.set_ylabel('Mel bin')
    fig.colorbar(c, ax=ax)

  return fig

def plotManyMfcc(mfcc):
  frames = np.arange(mfcc.shape[1])
  melbin = np.arange(mfcc.shape[2])

  rows = int(np.ceil(np.sqrt(mfcc.shape[0])))
  cols = int(np.ceil(mfcc.shape[0] / rows))

  print('rows',rows,'cols',cols)

  fig = plt.figure(constrained_layout=True)
  gs = fig.add_gridspec(rows, cols)

  for i in range(mfcc.shape[0]):
    vmin = mfcc.min()
    vmax = mfcc.max()
    ax = fig.add_subplot(gs[i//cols, i%cols])
    c = ax.pcolor(frames, melbin, mfcc[i].T, cmap='PuBu', vmin=vmin, vmax=vmax)
    ax.grid(True)
    ax.set_title(str(i))
    ax.set_xlabel('frame')
    ax.set_ylabel('Mel bin')
    fig.colorbar(c, ax=ax)

  return fig

######################################################################
# helper
######################################################################
def report(host_pred, mcu_pred):
  rmserror = rmse(host_pred, mcu_pred)
  np.set_printoptions(precision=3, suppress=True)
  print('keywords:',keywords)
  print('host prediction:',host_pred,keywords[host_pred.argmax()])
  print('mcu prediction: ',mcu_pred,keywords[mcu_pred.argmax()])
  print('rmse:', rmserror)

def rmse(a, b):
  return np.sqrt(np.mean((a-b)**2))

def compare(data_a, data_b, name):
  deviaitons = 100.0 * (1.0 - (data_b.ravel()+1e-9) / (data_a.ravel()+1e-9) )

  print('_________________________________________________________________')
  print('Comparing: %s' % (name))
  print("Deviation: max %.3f%% min %.3f%% avg %.3f%% \nrmse %.3f" % (
    deviaitons.max(), deviaitons.min(), np.mean(deviaitons), rmse(data_b.ravel(), data_a.ravel())))
  print('scale %.3f=1/%.3f' % (data_b.max()/data_a.max(), data_a.max()/data_b.max()))
  print('correlation coeff %.3f' % (np.corrcoef(data_a.ravel(),data_b.ravel())[0,1]))
  print('_________________________________________________________________')

######################################################################
# functions
######################################################################
def infereOnMCU(net_input, progress=False):
  """
    Upload, process and download inference
  """
  import edison.mcu.mcu_util as mcu

  if mcu.sendCommand('kws_single_inference') < 0:
    exit()
  mcu.sendData(net_input.reshape(-1), 0, progress=progress)
  mcu_pred, tag = mcu.receiveData()
  print('Received %s type with tag 0x%x len %d' % (mcu_pred.dtype, tag, mcu_pred.shape[0]))
  return mcu_pred

def mfccAndInfereOnMCU(data, progress=False):
  """
    Upload, process and download inference of raw audio data
  """
  import edison.mcu.mcu_util as mcu

  if data.dtype == 'float32':
    data = ( (2**15-1)*data).astype('int16')

  if mcu.sendCommand('mfcc_kws_frame') < 0:
    exit()

  print('Sending %d frames' % (n_frames))
  for frame in tqdm(range(n_frames)):
    mcu.sendData(data[frame*frame_step:frame*frame_step+frame_length], 0, progress=False)
    if mcu.waitForMcuReady() < 0:
      print('Wait for MCU timed out')

  # MCU now runs inference, wait for complete
  if mcu.waitForMcuReady() < 0:
    print('Wait for MCU timed out')

  print('Inference complete')

  # MCU returns net input and output
  mcu_mfccs, tag = mcu.receiveData()
  print('Received %s type with tag 0x%x len %d' % (mcu_mfccs.dtype, tag, mcu_mfccs.shape[0]))
  mcu_pred, tag = mcu.receiveData()
  print('Received %s type with tag 0x%x len %d' % (mcu_pred.dtype, tag, mcu_pred.shape[0]))
  
  return mcu_mfccs, mcu_pred

def micAndAllOnMCU():
  """
    Records a sample from mic and processes it
  """
  import edison.mcu.mcu_util as mcu

  if mcu.sendCommand('kws_mic') < 0:
    exit()

  # MCU now runs, wait for complete
  if mcu.waitForMcuReady(timeout=5000) < 0:
    print('Wait for MCU timed out')

  # MCU returns mic data, mfcc and net output
  # mic_data = np.array([0], dtype='int16')
  mic_data, tag = mcu.receiveData()
  print('Received %s type with tag 0x%x len %d' % (mic_data.dtype, tag, mic_data.shape[0]))
  mcu_mfccs, tag = mcu.receiveData()
  print('Received %s type with tag 0x%x len %d' % (mcu_mfccs.dtype, tag, mcu_mfccs.shape[0]))
  mcu_pred, tag = mcu.receiveData()
  print('Received %s type with tag 0x%x len %d' % (mcu_pred.dtype, tag, mcu_pred.shape[0]))
  
  return mic_data, mcu_mfccs.reshape(31, 13), mcu_pred


def singleInference(repeat = 1):
  """
    Run a single inference on MCU
  """

  # generate some random data
  np.random.seed(20)

  host_preds = []
  mcu_preds = []
  for i in range(repeat):
    if net_type == 'cube':
      net_input = np.array(np.random.rand(input_size).reshape([1]+input_shape), dtype='float32')
    elif net_type == 'nnom':
      # net_input = np.array(np.random.randint(-128,128,input_size).reshape([1]+input_shape), dtype='int8')
      net_input = np.array(np.zeros(input_size).reshape([1]+input_shape), dtype='int8')

    # predict on CPU
    host_preds.append(model.predict(net_input)[0])

    # predict on MCU
    mcu_preds.append(infereOnMCU(net_input, progress=True))
    
    # report
    report(host_preds[-1], mcu_preds[-1])
    
  mcu_preds = np.array(mcu_preds)
  host_preds = np.array(host_preds)
  compare(host_preds, mcu_preds, 'predictions')

def fileInference(args):
  """
    Read file and comput MFCC, launch inference on host and MCU
  """
  host_preds = []
  mcu_preds = []

  in_fs, data = wavfile.read(args[0])

  if (in_fs != fs):
    print('Sample rate of file %d doesn\'t match %d' % (in_fs, fs))
    exit()

  # Cut/pad sample
  if data.shape[0] < sample_len:
    data = np.pad(data, (0, sample_len-data.shape[0]))
  else:
    data = data[:sample_len]

  # Calculate MFCC
  o_mfcc = mfu.mfcc_mcu(data, fs, nSamples, frame_len, frame_step, frame_count, fft_len, 
    num_mel_bins, lower_edge_hertz, upper_edge_hertz, mel_mtx_scale)
  data_mfcc = np.array([x['mfcc'][:num_mfcc] for x in o_mfcc])
  # make fit shape and dtype
  net_input = np.array(data_mfcc.reshape([1]+input_shape), dtype='float32')
  
  # predict on CPU and MCU
  host_preds.append(model.predict(net_input)[0])
  mcu_preds.append(infereOnMCU(net_input))

  report(host_preds[-1], mcu_preds[-1])

  mcu_preds = np.array(mcu_preds)
  host_preds = np.array(host_preds)
  compare(host_preds, mcu_preds, 'predictions')
  # print('host prediction: %f ' % (host_preds[-1]))

def frameInference(args):
  """
    Reads file, computes mfcc and kws on mcu and host
  """
  import edison.mcu.mcu_util as mcu

  host_preds = []
  mcu_preds = []
  mcu_mfccss = []

  in_fs, data = wavfile.read(args[0])
  
  if not from_file:

    if (in_fs != fs):
      print('Sample rate of file %d doesn\'t match %d' % (in_fs, fs))
      exit()

    if data.dtype == 'float32':
      data = ( (2**15-1)*data).astype('int16')
    # Cut/pad sample
    if data.shape[0] < nSamples:
      data = np.pad(data, (0, nSamples-data.shape[0]), mode='edge')
    else:
      data = data[:nSamples]
    
    # # Cut/pad sample
    # if data.shape[0] < sample_len:
    #   data = np.pad(data, (0, sample_len-data.shape[0]))
    # else:
    #   data = data[:sample_len]

    # Calculate MFCC and compute on host
    o_mfcc = mfu.mfcc_mcu(data, fs, nSamples, frame_len, frame_step, frame_count, fft_len, 
      num_mel_bins, lower_edge_hertz, upper_edge_hertz, mel_mtx_scale)
    data_mfcc = np.array([x['mfcc'][:num_mfcc] for x in o_mfcc])
    net_input = np.array(data_mfcc.reshape([1]+input_shape), dtype='float32') * net_input_scale
    net_input = np.clip(net_input, net_input_clip_min, net_input_clip_max)
    host_preds.append(model.predict(net_input)[0,:])

    # Calculate MFCC and compute on MCU
    mcu_mfccs, mcu_pred = mfccAndInfereOnMCU(data, progress=True)
    mcu_preds.append(mcu_pred)
    mcu_mfccss.append(mcu_mfccs)

    mcu_mfccss = np.array(mcu_mfccss)
    mcu_preds = np.array(mcu_preds)
    host_preds = np.array(host_preds)
    
    # fig = plt.figure()
    # ax = fig.add_subplot(111)
    # c = ax.pcolor(data_mfcc.T, cmap='viridis')
    # fig.colorbar(c, ax=ax)
    # plt.show()

    # store this valuable data!
    import pathlib
    pathlib.Path(cache_dir).mkdir(parents=True, exist_ok=True)
    np.save(cache_dir+'/frame_mcu_preds.npy', mcu_preds)
    np.save(cache_dir+'/frame_mcu_mfccss.npy', mcu_mfccss)
    np.save(cache_dir+'/frame_net_input.npy', net_input)
    np.save(cache_dir+'/frame_host_preds.npy', host_preds)

  else:
    mcu_preds = np.load(cache_dir+'/frame_mcu_preds.npy')
    mcu_mfccss = np.load(cache_dir+'/frame_mcu_mfccss.npy')
    net_input = np.load(cache_dir+'/frame_net_input.npy')
    host_preds = np.load(cache_dir+'/frame_host_preds.npy')

  # report
  report(host_preds[-1], mcu_preds[-1])

  # reshape data to make plottable
  mcu_mfcc = mcu_mfccss.reshape(n_frames,num_mfcc)
  host_mfcc = net_input.reshape(n_frames,num_mfcc)
  if not from_file:
    fig = plotAudioMfcc(data, host_mfcc, mcu_mfcc)
  else:
    fig = plotTwoMfcc(host_mfcc, mcu_mfcc)

  # summarize
  mcu_preds = np.array(mcu_preds)
  host_preds = np.array(host_preds)
  stats = mcu.getStats()
  mcuInferenceTime = stats['lastinferencetime']
  mcuMfccTime = stats['AudioLastProcessingTime']

  compare(host_preds, mcu_preds, 'predictions')
  compare(host_mfcc, mcu_mfcc, 'MFCC=net input')
  print('MCU Audio processing took %.2fms (%.2fms per frame)' % (n_frames*mcuMfccTime, mcuMfccTime))
  print('MCU inference took %.2fms' % (mcuInferenceTime))
  plt.show()

def micInference():
  """

  """

  # fetch data
  mic_data, mcu_mfccs, mcu_pred = micAndAllOnMCU()

  # Start playback
  fs = 16000
  play_obj = sa.play_buffer(mic_data, 1, 2, fs) # data, n channels, bytes per sample, fs
  play_obj.wait_done()
  wavfile.write(cache_dir+'/mic.wav', fs, mic_data)

  # pad/cut data
  if mic_data.shape[0] < sample_len:
    mic_data = np.pad(mic_data, (0, sample_len-mic_data.shape[0]), mode='edge')
  else:
    mic_data = mic_data[:sample_len]

  # Calculate MFCC
  nSamples = mic_data.shape[0]
  o_mfcc = mfu.mfcc_mcu(mic_data, fs, nSamples, frame_len, frame_step, frame_count, fft_len, 
    num_mel_bins, lower_edge_hertz, upper_edge_hertz, mel_mtx_scale)
  data_mfcc = np.array([x['mfcc'][:num_mfcc] for x in o_mfcc])
  # make fit shape and dtype
  net_input = np.array(data_mfcc.reshape([1]+input_shape), dtype='float32')
  
  # make host prediction
  host_pred = model.predict(net_input)[0]

  # report
  report(host_pred, mcu_pred)
  
  import edison.mcu.mcu_util as mcu
  stats = mcu.getStats()
  mcuInferenceTime = stats['lastinferencetime']
  mcuMfccTime = stats['AudioLastProcessingTime']
  print('MCU Audio processing took %.2fms (%.2fms per frame)' % (n_frames*mcuMfccTime, mcuMfccTime))
  print('MCU inference took %.2fms' % (mcuInferenceTime))

  # store this valuable data!
  import pathlib
  pathlib.Path(cache_dir).mkdir(parents=True, exist_ok=True)
  np.save(cache_dir+'/mcumic_mcu_pred.npy', mcu_pred)
  np.save(cache_dir+'/mcumic_mcu_mfccs.npy', mcu_mfccs)
  np.save(cache_dir+'/mcumic_net_input.npy', net_input)
  np.save(cache_dir+'/mcumic_host_pred.npy', host_pred)
  np.save(cache_dir+'/mcumic_mic_data.npy', mic_data)

  # plot
  mcu_mfcc = mcu_mfccs.reshape(n_frames,num_mfcc)
  host_mfcc = net_input.reshape(n_frames,num_mfcc)

  fig = plotAudioMfcc(mic_data, host_mfcc, mcu_mfcc)
  plt.show()

def hostMic():
  """
    Sample from host mic, use this data to do inference on host and mcu
  """
  import sounddevice as sd
  sd.default.samplerate = fs
  sd.default.channels = 1

  mic_data = np.array([], dtype='int16')

  if not from_file:

    with sd.Stream() as stream:
      print('Listening...')
      for frameCtr in tqdm(range(n_frames)):
        frame, overflowed = stream.read(frame_length)
        # print('read frame of size', len(frame), 'and type', type(frame), 'overflow', overflowed)
        frame = ((2**16/2-1)*frame[:,0]).astype('int16')
        # print(frame[:5])
        mic_data = np.append(mic_data, frame.astype('int16'))

    print('mic_data size', len(mic_data), 'type', type(mic_data), mic_data.dtype)

    o_mfcc = mfu.mfcc_mcu(mic_data, fs, nSamples, frame_len, frame_step, frame_count, fft_len, 
      num_mel_bins, lower_edge_hertz, upper_edge_hertz, mel_mtx_scale)
    data_mfcc = np.array([x['mfcc'][:num_mfcc] for x in o_mfcc])
    # make fit shape and dtype
    net_input = np.array(data_mfcc.reshape([1]+input_shape), dtype='float32')
    
    host_pred = model.predict(net_input)[0]

    # MCU
    mcu_mfccs, mcu_pred = mfccAndInfereOnMCU(mic_data, progress=True)

    # store this valuable data!
    import pathlib
    pathlib.Path(cache_dir).mkdir(parents=True, exist_ok=True)
    np.save(cache_dir+'/hostmic_mcu_pred.npy', mcu_pred)
    np.save(cache_dir+'/hostmic_mcu_mfccs.npy', mcu_mfccs)
    np.save(cache_dir+'/hostmic_net_input.npy', net_input)
    np.save(cache_dir+'/hostmic_host_pred.npy', host_pred)
    np.save(cache_dir+'/hostmic_mic_data.npy', mic_data)

  else:
    mcu_pred = np.load(cache_dir+'/hostmic_mcu_pred.npy')
    mcu_mfccs = np.load(cache_dir+'/hostmic_mcu_mfccs.npy')
    net_input = np.load(cache_dir+'/hostmic_net_input.npy')
    host_pred = np.load(cache_dir+'/hostmic_host_pred.npy')
    mic_data = np.load(cache_dir+'/hostmic_mic_data.npy')

  # report
  report(host_pred, mcu_pred)

  # plot
  mcu_mfcc = np.array(mcu_mfccs).reshape(n_frames,num_mfcc)
  host_mfcc = net_input.reshape(n_frames,num_mfcc)

  fig = plotAudioMfcc(mic_data, host_mfcc, mcu_mfcc)
  plt.show()

def hostMicContinuous():
  """
    Sample continuous from host mic
  """
  import sounddevice as sd

  fig = plt.figure()
  ax1 = fig.add_subplot(1,1,1)

  sd.default.samplerate = fs
  sd.default.channels = 1

  threshold = 0.8

  mic_data = np.array([], dtype='int16')
  net_input = np.array([], dtype='int16')
  init = 1
  frame_ctr = 0
  mfcc = np.array([])
  last_pred = 0

  with sd.Stream() as stream:
    print('Filling buffer...')
    while True:
      frame, overflowed = stream.read(frame_length)
      # print('read frame of size', len(frame), 'and type', type(frame), 'overflow', overflowed)
      frame = ((2**16/2-1)*frame[:,0]).astype('int16')
      frame_ctr += 1

      nSamples = frame_length
      o_mfcc = mfu.mfcc_mcu(frame, fs, nSamples, frame_len, frame_step, frame_count, fft_len, 
        num_mel_bins, lower_edge_hertz, upper_edge_hertz, mel_mtx_scale)
      data_mfcc = np.array([x['mfcc'][:num_mfcc] for x in o_mfcc])

      ax1.clear()
      ax1.plot(frame)
      plt.draw()

      if init == 1:
        net_input = np.append(net_input.ravel(), data_mfcc)
        if (frame_ctr >= n_frames):
          print('Live!')
          init = 0

      else:
        net_input = np.array(net_input.reshape([1]+input_shape), dtype='float32')
        host_pred = model.predict(net_input)[0]
        net_input = np.append(data_mfcc, net_input.ravel()[:-num_mfcc])
        # progress = int(100*host_pred)*'+' + (100-int(100*host_pred))*'-'
        # print('\rprediction: %.3f %s' %(host_pred, progress) , end=" ")
        # print('')
        if (host_pred.max() > threshold):
          spotted_kwd = keywords[np.argmax(host_pred)]
          print('Spotted', spotted_kwd)
        last_pred = host_pred


def hostMicSingle():
  """
    Sample continuous from host mic
  """
  import sounddevice as sd

  sd.default.samplerate = fs
  sd.default.channels = 1

  mic_data = np.array([], dtype='int16')
  net_input = np.array([], dtype='int16')
  init = 1
  frame_ctr = 0
  mfcc = np.array([])
  last_pred = 0

  print('keywords:',keywords)
  threshold = 0.5

  with sd.Stream() as stream:
    print('Filling buffer...')
    while True:
      frame, overflowed = stream.read(frame_length)
      # print('read frame of size', len(frame), 'and type', type(frame), 'overflow', overflowed)
      frame = ((2**16/2-1)*frame[:,0]).astype('int16')
      frame_ctr += 1

      nSamples = 1024
      o_mfcc = mfu.mfcc_mcu(frame, fs, nSamples, frame_len, frame_step, frame_count, fft_len, 
        num_mel_bins, lower_edge_hertz, upper_edge_hertz, mel_mtx_scale)
      data_mfcc = np.array([x['mfcc'][:num_mfcc] for x in o_mfcc])

      if init == 1:
        net_input = np.append(net_input.ravel(), data_mfcc)
        if (frame_ctr >= n_frames):
          print('Live!')
          init = 0

      else:
        net_input = np.array(net_input.reshape([1]+input_shape), dtype='float32')
        host_pred = model.predict(net_input)[0]
        net_input = np.append(data_mfcc, net_input.ravel()[:-num_mfcc])
        # progress = int(100*host_pred)*'+' + (100-int(100*host_pred))*'-'
        # print('\rprediction: %.3f %s' %(host_pred, progress) , end=" ")
        # print('')
        if (host_pred.max() > threshold):
          spotted_kwd = keywords[np.argmax(host_pred)]
          print('Spotted', spotted_kwd, 'with %.2f%% confidence' % (100.0*host_pred.max()))
        np.set_printoptions(suppress=True)
        print(host_pred)
        last_pred = host_pred
        host_mfcc = net_input.reshape(n_frames,num_mfcc)
        plotAudioMfcc(frame, host_mfcc, None)
        plt.show()
        return

def mcuMicCont():
  import edison.mcu.mcu_util as mcu

  if mcu.sendCommand('kws_mic_continuous') < 0:
    exit()

  mcu_net_inp, tag = mcu.receiveData(timeout=10000)
  print('Received %s type with tag 0x%x len %d' % (mcu_net_inp.dtype, tag, mcu_net_inp.shape[0]))

  mcu_net_inp = mcu_net_inp.reshape((-1,31,13))
  plotManyMfcc(mcu_net_inp[:,:,:])
  plt.show()


######################################################################
# main
######################################################################
def main(argv):

  if len(argv) < 2:
    print('Usage:')
    print('  kws_on_mcu.py <mode>')
    print('    Modes:')
    print('    single                   Single inference on random data')
    print('    fileinf <file>           Get file, run MFCC on host and inference on MCU')
    print('    file <file>              Get file, run MFCC and inference on host and on MCU')
    print('    mic                      Record sample from onboard mic and do stuffs')
    print('    host                     Record sample from host mic and do stuffs')
    print('    hostcont                 Test net on host only using host mic')
    print('    hostsingle               Test net on host only using host mic and single frame')
    print('    miccont                  Continuous sample on MCU with net input history')
    exit()
  mode = argv[1]
  args = argv[2:]

  print('Running mode', mode, 'with args', args)
  if mode == 'single':
    if len(args):
      singleInference(int(args[0]))
    else:
      singleInference(1)
  if mode == 'fileinf':
    fileInference(args)
  if mode == 'file':
    frameInference(args)
  if mode == 'mic':
    micInference()
  if mode == 'host':
    hostMic()
  if mode == 'hostcont':
    hostMicContinuous()
  if mode == 'hostsingle':
    hostMicSingle()
  if mode == 'miccont':
    mcuMicCont()

if __name__ == '__main__':
  main(sys.argv)



