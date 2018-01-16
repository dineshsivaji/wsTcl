#!/usr/bin/tclsh
proc main {} {
	global serverSocket
	set serverSocket [socket -server srvAccept 1617]
	puts "I'm waiting... on the port [lindex [fconfigure $serverSocket -sockname] end]"
	::websocket::server $serverSocket
	::websocket::live $serverSocket /sample  wsHandler
	vwait events
}
proc srvAccept {sock addr port} {
	puts "Accepted $sock from $addr on port $port"
	fconfigure $sock -buffering line
	fileevent $sock readable [list readFromSock $sock]
}

proc wsHandler {sock type msg args} {
	puts "[info level 0]"
	puts "sock : ->$sock<-"	
	puts "type : ->$type<-"	
	puts "msg : ->$msg<-"	
	puts "args : ->$args<-"
	switch -regexp -- $type {
		"^[cC][oO].*" {
			puts "Connected on $sock"
		}
		"^[tT][eE].*" {
			puts "RECEIVED: $msg"
			::websocket::send $sock $type  "Server says : ->$msg<-"
		}
		"^[cC][lL].*" -
		"^[dD][iI][sS].*" -
		"^[eE][rR].*" {
			puts "Closed $sock"
			catch { close $sock }
		}
		default {
			puts "$type"
		}
	}
}
proc readFromSock {sock} {

	##### Websocket Client Request Header Format #####
	# GET /sample HTTP/1.1
	# Host: IP_ADDRESS:OPTIONAL_PORT_NUMBER 
	# Connection: Upgrade
	# Pragma: no-cache
	# Cache-Control: no-cache
	# Upgrade: websocket
	# Origin: http://manpages.ubuntu.com
	# Sec-WebSocket-Version: 13
	# User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36
	# Accept-Encoding: gzip, deflate
	# Accept-Language: en-US,en;q=0.9
	# Sec-WebSocket-Key: FxGCZQ32NfWy2du4ONyE9g==
	# Sec-WebSocket-Extensions: permessage-deflate; client_max_window_bits
	##################################################
	puts [info level 0]
	global serverSocket
	set noOfCharsRead -1 
	set line {}
	array set data {}
	array set http_header {} 
	set type request
	set count 0 
	if {[eof $sock] || [catch {
		while {[gets $sock line]>0} {
			puts $line
			set line [string trim $line]
			if {$line eq {}} {
				continue
			}
			if {$count>0} {
				set type headers
			}
			append data($type) "$line\n"
			incr count
		}
	} errorMsg]} {
		close $sock
		puts "Closed $sock connection"
	}
	set req_info [split $data(request)]
	set method [lindex $req_info 0] 
	set wsPath [lindex $req_info 1] 
	set protocol [lindex $req_info 2] 
	puts "method : $method, wsPath : $wsPath, protocol : $protocol"
	foreach line [split $data(headers) "\n"] {
		set idx [string first ":" $line ]
		if { $idx == -1 } {
			continue
		}
		set key [string range $line 0 [expr $idx-1]]
		set value [string trim [string range $line [expr $idx+1] end]]
		set http_header($key) $value
	}
	
	if {$wsPath eq "/sample"} {
		puts "got a websocket request : $wsPath"
		puts "header: [array get http_header]"
		set wtest [::websocket::test $serverSocket $sock /sample [array get http_header]]
		if { $wtest } {
			::websocket::upgrade $sock
			::websocket::takeover $sock wsHandler 1
			puts "[::websocket::conninfo $sock type] from [::websocket::conninfo $sock sockname] to [::websocket::conninfo $sock peername]"
			fileevent $sock readable
			lappend ::openSockets $sock
		} else {
			puts "did not get a valid  web socket request: wsPath : $wsPath"
			set reply "$protocol 404 Not Found\r\nContentType: text/html\r\n\r\n<html><head><head><p>Not a web server!</p><body</body></html>"
			puts $sock $reply
			catch { close $sock}
		}
	} else {
		puts "did not get a web socket request: wsPath : $wsPath"
		set reply "$protocol 404 Not Found\r\nContentType: text/html\r\n<html><head><head><p>Not a web server!</p><body</body></html>"
		puts $sock $reply
		catch { close $sock}
	}
}

##### Main starts here #####
set curDir [file dirname [file normalize [info script]]]
lappend auto_path $curDir/lib
package require websocket


if {[catch {main} errorMsg]} {
	puts "Error : $errorMsg"
}