
package require BWidget
source [file join [file dirname [info script]] "m3co/main.tcl"]

#
# MAIN - es para conectarse, definir chan y delegar los eventos
#
# Variables
#  chan - channel o canal de conexion TCP
#
#  leftPanel - el frame izquierdo
#  centerPanel - el frame del centro
#
# Procedimientos
#  handle'event
#

namespace eval MAIN {
  wm title . "Administrador de Cantidades"
  wm geometry . "800x600+100+10"

 #set chan [socket {x12.m3c.space} 12345]
  set chan [socket localhost       12345]

  chan configure $chan -encoding utf-8 -blocking 0 -buffering line
  chan event $chan readable "MAIN::handle'event"

  # Configure el Layout inicial
  set main [ScrolledWindow .scrolledwindow]
  pack $main -fill both -expand true
  $main setwidget [ScrollableFrame $main.scrollableframe]
  set frame [$main.scrollableframe getframe]
  update

  proc subscribe { } {
    variable chan
    array set event {
      module fnCostsByKeynote
      query subscribe
    }
    chan puts $chan [array get event]

    array set event {
      module Projects
      query subscribe
    }
    chan puts $chan [array get event]
  }
  subscribe
}

proc MAIN::handle'event { } {
  variable chan
  chan gets $chan data
  if { $data == "" } {
    return
  }
  array set response [deserialize $data]
  puts "\nresponse:"
  parray response
  $response(module)::'do'$response(query) response
}

source [file join [file dirname [info script]] projects.tcl]
source [file join [file dirname [info script]] q1.tcl]
