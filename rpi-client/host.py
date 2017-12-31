
#!env python3

from multiprocessing import Process, Queue
import os
import RPi.GPIO as GPIO
import websocket


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
HTTP_PREFIX = os.environ.get('HTTP_PREFEX','http')
# websocket
WS_PREFIX = os.environ.get('WS_PREFIX','ws')

def readSpeedFromWebSocket(q):
    print('speed web socket start')
    def on_message(ws, message):
        dc = int(message)
        q.put(dc)

    def on_error(ws, error):
        print(error)

    def on_close(ws):
        print('web socket close')

    def on_open(ws):
        print('web socket open')

  #  websocket.enableTrace(True)
    url = WS_PREFIX + '://' + API_URL
    print(url)
    webSock = websocket.WebSocketApp(url,
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

def transformSpeed(speed):
    if speed < 0:
        return 0
    elif speed > 100:
        return 100
    else:
        return speed

def writeSpeed(q):
    print('init GPIO')
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(ENABLE_PIN,GPIO.OUT)
    GPIO.setup(PWM_PIN,GPIO.OUT)
    print('start the GPIO')
    p = GPIO.PWM(PWM_PIN,PWM_FREQ)
    p.start(0)
    while 1:
        value = q.get(True)
        print(value)
        if value < -1000:
            break
        p.ChangeDutyCycle(transformSpeed(value))
    p.stop()
    GPIO.cleanup()

def main():
    q = Queue()
    pWebSocket = Process(target=readSpeedFromWebSocket,args=(q,))
    pStdin     = Process(target=readSpeedFromStdin,args=(q,))
    pSpeed     = Process(target=writeSpeed ,args=(q,))
    pSpeed.start()
    pWebSocket.start()
    pStdin.start()
    pSpeed.join()
    pStdin.terminate()
    pWebSocket.terminate()

if __name__ == '__main__':
    GPIO.cleanup()
    main()
