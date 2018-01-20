console.log("load the extensions");

var enable = false;

function timeoutRedo(func,value,step,delay) {
  func(value);
  logDebug("timeout redo",value)
  if (enable)
    setTimeout(function(){timeoutRedo(func,value+step,step,delay);},delay);
}

function disableTimeout() {
  enable = false;
}

function sinDelay(value,delay) {
  enable = true;
  timeoutRedo(function(v){uploadNewValueToSvr(50+50*Math.cos(v));},value,0.1,delay);
}

function DTFT(sca,coe,value,coe_,bias,delay) {
  enable = true;
  var len = Math.min(sca.length,coe.length);
  sinF = function (x) {
    var sum = 0;
    for (i=0;i<len;i++)
      sum += sca[i] * Math.cos(coe[i] * x);
    return sum;
  };
  timeoutRedo(function(v){uploadNewValueToSvr(100*(coe_ * sinF(v) + bias));},value,0.1,delay);
}

/**
 * Simulate function with func()
 */
function mkSim(sca,coe,func) {
  var len = Math.min(sca.length,coe.length);
  return function(x) {
    var sum = 0;
    for(i=0;i < len; i++)
    sum += sca[i] * func(coe[i] * x);
    return sum;
  }
}

/**
 * timeout delay 
 */

function timeoutNV(func,coe,bias,value,step,delay) {
  enable = true;
  timeoutRedo(function(v){
    uploadNewValueToSvr(coe * func(v) + bias);},
  value,step,delay);
}