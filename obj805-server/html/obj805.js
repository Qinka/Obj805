
socket;
console.log('hi');
req = new XMLHttpRequest();
req.open('GET','http://localhost:3000/get',true);
req.onreadystatechange = function()
{
  if (req.readyState == 4) if(req.status == 200)
  {
//    var jsonData = eval(req.responseText);
    document.getElementById('speed').innerHTML = req.responseText;
  }
}
req.send(null);

// for websockets
var socket = new WebSocket('ws://localhost:3000/get')
socket.onopen = function(event){
  console.log('asdf');
  socket.onmessage = function(event){
    document.getElementById('speed').innerHTML = event.data;
    console.log('Client received a message',event.data);
  };
  socket.onclose = function(event) { 
    console.log('Client notified socket has closed',event); 
  }; 
}