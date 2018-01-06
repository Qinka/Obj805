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

function sinNDelay(coe,value,delay) {
  enable = true;
  sinF = function (x) {
    var sum = 0;
    for (i=0;i<coe.length-1;i++)
      sum += Math.sin(coe[i]*x);
    return sum/coe.length;
  };
  timeoutRedo(function(v){uploadNewValueToSvr(50+50*sinF(v));},value,0.1,delay);
}