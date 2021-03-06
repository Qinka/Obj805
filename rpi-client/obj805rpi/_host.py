
#!env python3

from multiprocessing import Process, Queue
import os
import RPi.GPIO as GPIO
import websocket
from ._extension import *
import time

# Configurations
# PWM Frequency
PWM_FREQ = int(os.environ.get('PWM_FREQ', '100'))
# enable pin
ENABLE_PIN = int(os.environ.get('ENABLE_PIN', '7'))
# PWM output pin
PWM_PIN = int(os.environ.get('PWM_PIN', '35'))
# API url
API_URL = os.environ.get('API_URL','localhost:3000/speed')
# HTTP
HTTP_PREFIX = os.environ.get('HTTP_PREFIX','http')
# websocket
WS_PREFIX = os.environ.get('WS_PREFIX','ws')
# DEBUG FLAG
DEBUG = os.environ.get('DEBUG','false')
# WSRT TIME
WS_RT_WAIT = os.environ.get('WS_RT_WAIT','120')
# Auth
AUTHB64 = os.environ.get('AUTHB64')
# activation function name
AF_NAME = os.environ.get('AF_NAME','ReLU')
activationFunction = eval(AF_NAME)

wsRetryCount = 0

def readSpeedFromWebSocket(q):
    print('speed web socket start')
    def on_message(ws, message):
        dc = float(message)
        q.put(dc)

    def on_error(ws, error):
        print(error)

    def on_close(ws):
        print('web socket close')
        time.sleep(int(WS_RT_WAIT))
        readSpeedFromWebSocket(q)

    def on_open(ws):
        print('web socket open')
        #wsRetryCount += 1

  #  websocket.enableTrace(True)
    url = WS_PREFIX + '://' + API_URL
    print(url)
    websocket.enableTrace(DEBUG != 'false' and DEBUG != '' )
    webSock = websocket.WebSocketApp(url, header = ['Authorization: Basic '+AUTHB64],
                                     on_message = on_message,
                                     on_error = on_error,
                                     on_close = on_close)
    webSock.on_open = on_open
    webSock.run_forever()
        

def readSpeedFromStdin(q):
    print('speed stdin start')
    while 1:
        dc = input('Input new speed(0 ~ 100):')
        q.put(dc)


def writeSpeed(q):
    print('init GPIO')
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(ENABLE_PIN,GPIO.OUT)
    GPIO.setup(PWM_PIN,GPIO.OUT)
    GPIO.output(ENABLE_PIN, GPIO.HIGH) 
    print('start the GPIO')
    p = GPIO.PWM(PWM_PIN,PWM_FREQ)
    p.start(0)
    while 1:
        value = q.get(True)
        print(value)
        if value < -1000:
            break
        p.ChangeDutyCycle(activationFunction(value))
    p.stop()
    GPIO.cleanup()

def main():
    print('start client')
    q = Queue()
    pWebSocket = Process(target=readSpeedFromWebSocket,args=(q,))
    pStdin     = Process(target=readSpeedFromStdin,args=(q,))
    pSpeed     = Process(target=writeSpeed ,args=(q,))
    pSpeed.start()
    pWebSocket.start()
    #pStdin.start()
    pSpeed.join()
    #pStdin.terminate()
    pWebSocket.terminate()

if __name__ == '__main__':
    GPIO.cleanup()
    main()
