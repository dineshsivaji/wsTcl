#!/usr/bin/tclsh
set curDir [file dirname [file normalize [info script]]]
lappend auto_path /repo/dsivaji/atc/cm8/auto/Automation/Library/TclLib-Linux/tcl8.4/lib/tcllib1.9
lappend auto_path $curDir/lib
package require websocket

 ::websocket::loglevel debug
 proc handler { sock type msg } {
         switch -regexp -- $type {
                 "^[cC][oO].*" {
                         puts "Connected on $sock"
                 }
                 "^[tT][eE].*" {
                         puts "RECEIVED: $msg"
                 }
                 "^[cC][lL].*" -
                 "^[dD][iI][sS].*" -
                 "^[eE][rR].*" {
                         puts " $type"
                         catch { close $sock }
                         exit 0
                 }
                 default {
                         puts "$type"
                 }

     }
         puts  -nonewline stdout ">"
         flush stdout
 }
 proc readline { fd handler } {
         set line [ gets $fd ]
         if { $line eq "q" } { exit 0  ; # harsh but this is an example after all }
         if { [eof $fd ] } {
                 catch { close $fd }
         }
         uplevel #0 $handler \"$line\"
 }
 proc test { sock line } {
     ::websocket::send $sock text $line
 }
 proc closeapp { sock } {
         ::websocket::close $sock 1000 "normal close"
         after  1000 {
                 exit 0
         }
 }
 fconfigure stdin -blocking 0 -buffering line
 set sock [::websocket::open http://localhost:1617/sample handler -protocol s ]
 fileevent stdin read [list readline stdin [list test $sock ] ]
 puts "[::websocket::conninfo $sock type] from [::websocket::conninfo $sock sockname] to [::websocket::conninfo $sock peername]"
 puts  -nonewline stdout ">"
 flush stdout
 vwait forever