import RPi.GPIO as io
import threading
import requests
import string

isExit = False
io.setmode(io.BCM)
in1_pin = 4
io.setup(in1_pin,io.OUT)
io.output(in1_pin,False)
p = io.PWM(4,50)
dc = 100
p.start(dc)
while (not(isExit)):
        result = requests.get('http://192.168.66.84:3000/get-dc')
        dc = string.atof(result.text)
        if dc < -10:
            print "C"
            isExit = True
        if dc <0:
            p.ChangeDutyCycle(0)
            continue
        if dc >100:
            p.CnangeDutyCycle(100)
            continue
        dc = (6.0*dc/100.0+94.0)
        p.ChangeDutyCycle(dc)
io.cleanup()
