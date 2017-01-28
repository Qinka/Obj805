import RPi.GPIO as io
import websocket
import threading
import time
import string

def on_message(ws, message):
    print(message)
    dc = int(message)
    if dc < 0 :
        dc = 0
    if dc > 100 :
        dc = 100
    p.ChangeDutyCycle(dc)

def on_error(ws, error):
    print(error)

def on_close(ws):
    print('### closed ###')

def on_open(ws):
    print('open')

def set(property, value):
    try:
        f = open("/sys/class/rpi-pwm/pwm0/"+property,'w')
        f.write(value)
        f.close()
    except:
        print("Error writing to: " + property + " value: " + value)


if __name__ == "__main__":
    ## for gpio
    io.setmode(io.BCM)
    in1_pin = 4
    io.setup(in1_pin, io.OUT)
    io.output(in1_pin, False)
    p = io.PWM(4,10000)
    dc = 0
    p.start(dc)
    websocket.enableTrace(True)
    ws = websocket.WebSocketApp("ws://192.168.66.86:3000/get",
                              on_message = on_message,
                              on_error = on_error,
                              on_close = on_close)
    ws.on_open = on_open
    ws.run_forever()

    print("Exit")
    io.cleanup()
