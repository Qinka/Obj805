
#!env python3

from multiprocessing import Process, Queue
import os
import RPi.GPIO as GPIO


# Configurations
# PWM Frequency
PWM_FREQ = 100
# enable pin
ENABLE_PIN = 7
# PWM output pin
PWM_PIN = 35


def readSpeedFromWebSocket(q):
    pass

def readSpeedFromStdin(q):
    pass

def transformSpeed(speed):
    return speed

def writeSpeed(q):
    print('init GPIO')
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(ENABLE_PIN,GPIO.OUT)
    GPIO.setup(PWM_PIN,GPIO.OUT)
    print('start the GPIO')
    p = GPIO.PWM(PWM_PIN,PWM_FREQ)
    p.start(0)
    try:
        while 1:
            value = q.get(True)
            if value < -1000:
                break
            p.ChangeDutyCycle(transformSpeed(value))
    p.stop()
    GPIO.cleanup()

def main():
    q = Queue()
    pWebSocket = Process(target=write,args=(q,))
    pStdin     = Process(target=write,args=(q,))
    pSpeed     = Process(target=read ,args=(q,))
    pSpeed.start()
    pWebSocket.start()
    pStdin.start()
    pSpeed.join()
    pStdin.terminate()
    pWebSocket.terminate()

if __name__ == '__main__':
    main()
