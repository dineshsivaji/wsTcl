# wsTcl
Pure - Standalone Tcl websocket Server-Client implementation without any additional web server like [tclhttpd](https://www.tcl.tk/software/tclhttpd/)

This is intended for Tcl8.4, So I have altered the `websocket.tcl` file to make it backward compatible. 

It can still run on higher versions. 

# How to Run ? 
To start the server, 

  `tclsh wsServer.tcl` 
  
It will be started on the port 1617. (You can customize the port)


To start the Tcl client 

  `tclsh wsClient.tcl`
    
It is a simple echo client-server model. Once the client connected to the server, whatever the client sends to server, will be echoed back to the client. 


To check the same in web-browser, you can integrate the `wsClient.js` in a HTML file.

# History

It is a minimalized version of [tclhttpd-websocket](https://github.com/dineshsivaji/tclhttpd-websocket)

Based on  :   https://wiki.tcl-lang.org/49314

# Credits

  Mr.Bezoar
  
  Mr.Jeff Smith
  
  Mr.Donal Fellows



