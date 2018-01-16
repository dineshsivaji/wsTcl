# wsTcl
Pure - Standalone Tcl websocket Server-Client implementation without any additional web server.

This is intended for Tcl8.4, So I have altered the `websocket.tcl` file to make it backward compatible. 

It can still run on higher versions. 

# How to Run ? 
To start the server, 

  `tclsh wsServer.tcl` 
  
It will be started on the port 1617. (You can customize the port)


To start the Tcl client 

  `tclsh wsClient.tcl`
    
To check the same in web-browser, you can integrate the `wsClient.js` in a HTML file.

# History

Based on  :   https://wiki.tcl-lang.org/49314

# Credits

  Mr.Bezoar



