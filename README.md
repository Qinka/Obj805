# Obj805


## "Funny"

So the "Funny" is an Easter egg.
There provides some function to control the dc value of fan in specific function.

The most import function provided is `DTFT`, and with given coefficients and scalers,
we can output most common signal of dc.

The first thing to do is to enter the "funny" mode.
You need to launch the console of browser and then run `runFunny`.
All the command run in funny's input text box can be executed in console.

Secondly, you need to load the `library/extension.js` script.
You should run the `loadScript('library/extension.js')` in input text box or console.

Thirdly, run the `DTFT()`. `DTFT` is defined with parameters:
```javascript
function DTFT(sca,coe,value,coe_,bias,delay) {...}
```
`sca` and `coe` are the scalar and frequency of DTFT.
`value` is the begining value of loop, and it is usually `0`.
`coe_` and `bias` is the transformation parameter of hold function.
`delay` is the update delay(microsecond).

### Example (old version with DTFT)

```javascript
sca = [1,0.5,0.25,0.125,0.0625,0.0313,0.0156,0.0078];
coe = [0,1,2,3,4,5,6,7];
DTFT(sca,coe,0,0.7531,-0.5003,100);
```

### Example (new version with mkSim)

To make a square wave:
```javascript
sca=[1,1/3,1/5,1/7];
coe=[1,3,5,7];
sq=mkSim(sca,coe,Math.sin);
timeoutNV(sq,50,50,0,0.1,300);
```