var dc = 0;
socket;
console.log('hi');

function GetRequest() {
   var url = location.search;
   var theRequest = new Object();
   if (url.indexOf("?") != -1) {
      var str = url.substr(1);
      strs = str.split("&");
      for(var i = 0; i < strs.length; i ++) {
         theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);
      }
   }
   return theRequest;
}

request = GetRequest();
apiurl = request['url'];
if (apiurl == null) apiurl = 'localhost:3000/speed';
if (apiurl.length == 0) apiurl = 'localhost:3000/speed';

var socket = new WebSocket('ws://'+apiurl);
socket.onopen = function(event){
  console.log('asdf');
  socket.onmessage = function(event){
    document.getElementById('speed').innerHTML = event.data;
    dc = eval(event.data)
    console.log('Client received a message',event.data);
  };
  socket.onclose = function(event) { 
    console.log('Client notified socket has closed',event); 
  }; 
}


// the onClick event
function onClick_update(delta)
{
  var oldValue = parseInt(document.getElementById('speed').textContent);
  var newValue = delta + oldValue;
  if (newValue <= 100 && newValue >= 0) {
    req = new XMLHttpRequest();
    req.open('POST','http://'+apiurl,true);
    req.onreadystatechange = function() {
      if (req.readyState == 4) {
        if(req.status == 200) {
          console.log('update data');
          return;
        }
        else {
          alert('error' + req.responseText);
        }
      }
    }
    req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    req.send("speed="+newValue);
  }
}