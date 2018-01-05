//
// Global values
//

// dc value
var dc = 0;
var debugFlag = false;
var apiurl = null;

//
// functions
//

// range change or input
function rangeChange() {
    var value = document.getElementById('dc').value;
    logDebug("new value of dc, from range",value);
    uploadNewValueToSvr(value);
    getNewValueFromSvr(value);
    return;
}

// Into setting frame
function setting() {
    mainFrameVis(false);
    settingVis(true);
    return;
}

// Into fine tuning frame
function fineTuning() {
    mainFrameVis(false);
    fineTuningVis(true);
    return ;
}

// update new value
function updateNewValue() {
    var value = parseFloat(document.getElementById('newvalue').value);
    backToMainFrame();
    getNewValueFromSvr(value);
    uploadNewValueToSvr(value);
    return ;
}

// back to main frame
function backToMainFrame() {
    mainFrameVis(true);
    settingVis(false);
    fineTuningVis(false);
    return ;
}

// debug output
function logDebug(message, ...optionalParams) {
    if (debugFlag) return console.log(message,optionalParams);
}

function mainFrameVis(value) {
    return document.getElementById('mainFrame').style['visibility'] = value ? "" : "hidden";
}

function settingVis(value) {
    return document.getElementById('Setting').style['visibility'] = value ? "" : "hidden";
}

function fineTuningVis(value) {
    return document.getElementById('fineTuning').style['visibility'] = value ? "" : "hidden";
}

// function for main
function entryPoint() {
    debugFlag = isDebug();
    logDebug('Hi, Obj805 Debug mod!');
    // get remote url 
    var params = fetchGETParams();
    var apiurlP = params['url'];
    var apiurlC = getCookie("apiurl");
    if (apiurlP != null && apiurlP != "") 
        apiurl = apiurlP;
    else if (apiurlC != null && apiurlC != "")
        apiurl = apiurlC;
    else
        apiurl = document.domain + "/speed";
    setCookie("apiurl",apiurl,null);
    connWS();
    logDebug("Obj805 launched");
    fineTuningVis(false);
    settingVis(false);
    return ;
}

// connect WebSocket
function connWS() {
    var wspro = document.location.protocol == 'https:' ? 'wss' : 'ws';
    var pass = btoa(getCookie('userpass'));
    var socket = new WebSocket(wspro+ '://'+apiurl);
    socket.onopen    = function(event){
        logDebug("socket launched",event);
    };
    socket.onmessage = function(event){
        getNewValueFromSvr(event.data);
        logDebug('Client received a message',event.data);
    };
    socket.onclose   = function(event) {
        logDebug('Client notified socket has closed',event);
        window.setTimeout(function(){connWS()},20000);
    };
    socket.onerror   = function(event) {
        logDebug('get error', event);
    }
}

// read debug flag
function isDebug() {
    var rt = getCookie("debug_flag");
    return rt == "true";
}

// setting debug flag
function setDebug(value) {
    setCookie("debug_flag",value,null);
    return ;
}

// set cookie
function setCookie(c_name,value,expiredays) {
    var exdate = new Date();
    exdate.setDate(exdate.getDate()+expiredays);
    document.cookie=c_name+ "=" +escape(value)+((expiredays==null) ? "" : ";expires="+exdate.toGMTString());
}

// get cookie
function getCookie(c_name) {
    if (document.cookie.length>0) {
        c_start=document.cookie.indexOf(c_name + "=");
        if (c_start!=-1) { 
            c_start=c_start + c_name.length+1;
            c_end=document.cookie.indexOf(";",c_start);
            if (c_end==-1) c_end=document.cookie.length;
            return unescape(document.cookie.substring(c_start,c_end));
        } 
    }
    return null;
}

// fetch GET params
function fetchGETParams() {
    var url = location.search;
    var paramPairs = new Object();
    if (url.indexOf("?") != -1) {
        var str = url.substr(1);
        strs = str.split("&");
        for(var i = 0; i < strs.length; i ++)
            paramPairs[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);
    }
    return paramPairs;
}



// the onClick event
function uploadNewValueToSvr(value) {
    if (value <= 100 && value >= 0) {
        req = new XMLHttpRequest();
        req.open('POST','//'+apiurl,true);
        req.onreadystatechange = function() {
            if (req.readyState == 4) {
                if(req.status == 200) logDebug('update data',value);
                else alert('error' + req.responseText);
            }
        }
        req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.send("speed="+value);
    }
}

// update new value to DOM
function getNewValueFromSvr(value) {
    dc = value;
    document.getElementById('speedT').textContent = value;
    document.getElementById('dc').value = value;
    return ;
}

entryPoint();
