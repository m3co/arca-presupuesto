
namespace eval fnCostsByKeynote {
  variable rows
  variable frame
  variable project
  array set rows {}

  proc open { space id } {
    variable frame $space
    variable project $id
    array set event [list \
      query select \
      module fnCostsByKeynote \
      from fnCostsByKeynote \
      keynote $id
    ]

    pack [labelframe $frame.id -text "Codigo"] -side left
    pack [labelframe $frame.description -text "Descripcion"] -side left
    pack [labelframe $frame.quantity -text "Cantidad"] -side left
    pack [labelframe $frame.duration -text "Duracion"] -side left
    pack [labelframe $frame.cost_total -text "Costo Total"] -side left
    pack [labelframe $frame.cost_material -text "Costo Material"] -side left
    pack [labelframe $frame.cost_mdo -text "Costo Mano de Obra"] -side left
    pack [labelframe $frame.cost_herramienta -text "Costo Herramienta"] -side left
    pack [labelframe $frame.cost_equipo -text "Costo Equipo"] -side left
    pack [labelframe $frame.cost_transporte -text "Costo Transporte"] -side left
    pack [labelframe $frame.cost_subcontrato -text "Costo Subcontrato"] -side left
    chan puts $MAIN::chan [array get event]
  }

  proc 'do'update { resp } {
    variable frame
    variable project
    upvar $resp response
    array set row [deserialize $response(row)]
    variable rows
    array set rows [list $row(id) $response(row)]
    if { $row(project) != $project } {
      return
    }

    set id [regsub -all {[.]} $row(id) "_"]
    foreach param [list id description] {
      set fr $frame.$param.$id
      $fr.label configure -text $row($param)
    }
    set cost_total $row(cost_total)
    foreach param [list total material mdo herramienta equipo \
      transporte subcontrato] {
      set fr $frame.cost_$param.$id
      if { $cost_total == "" } {
        $fr.label configure -text " "
      } else {
        $fr.label configure -text "\$[format'currency $row(cost_$param)]"
      }
    }

    set param "duration"
    set fr $frame.$param.$id
    if { $cost_total == "" } {
      $fr.label configure -text " "
    } else {
      $fr.label configure -text "$row($param) días"
    }

    set param "quantity"
    set fr $frame.$param.$id
    if { $cost_total == "" } {
      $fr.label configure -text " "
    } else {
      $fr.label configure -text "$row($param) $row(unit)"
    }
  }

  proc 'do'insert { resp } {
    upvar $resp response
    array set row [deserialize $response(row)]

    if { $row(project) != $project } {
      return
    }
    'do'select response
  }

  proc 'do'select { resp } {
    variable frame
    upvar $resp response
    array set row [deserialize $response(row)]
    variable rows
    array set rows [list $row(id) $response(row)]

    set id [regsub -all {[.]} $row(id) "_"]
    foreach param [list id description] {
      set fr $frame.$param.$id
      pack [frame $fr] -fill x -expand true
      pack [label $fr.label -text $row($param)] -side left
    }
    set cost_total $row(cost_total)
    foreach param [list total material mdo herramienta equipo \
      transporte subcontrato] {
      set fr $frame.cost_$param.$id
      pack [frame $fr] -fill x -expand true
      if { $cost_total == "" } {
        pack [label $fr.label -text " "]
      } else {
        pack [label $fr.label -text "\$[format'currency $row(cost_$param)]"] \
          -side right
      }
    }

    set param "duration"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    if { $cost_total == "" } {
      pack [label $fr.label -text " "]
    } else {
      pack [label $fr.label -text "$row($param) días"] -side right
    }

    set param "quantity"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    if { $cost_total == "" } {
      pack [label $fr.label -text " "]
    } else {
      pack [label $fr.label -text "$row($param) $row(unit)"] -side right
    }
  }

}
