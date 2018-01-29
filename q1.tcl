
namespace eval viewBudget {
  variable frame
  variable project
  variable description

  chan puts $MAIN::chan [json::write object \
    query [json::write string describe] \
    module [json::write string viewBudget] \
  ]

  proc 'do'describe { resp } {
    upvar $resp response
    variable description
    array set description [list {*}$response(description)]
  }

  proc open { space id } {
    variable frame $space
    variable project $id
    set event [dict create \
      query {"select"} \
      module {"viewBudget"} \
      keynote [json::write string $id]
    ]

    pack [labelframe $frame.apu_id -text "Codigo"] -side left
    pack [labelframe $frame.apu_description -text "Descripcion"] -side left
    pack [labelframe $frame.qtakeoff_qop -text "Cantidad"] -side left
    pack [labelframe $frame.apu_duration -text "Duracion"] -side left
    pack [labelframe $frame.apu_cost -text "Costo Total"] -side left
    pack [labelframe $frame.apu_cost_material -text "Costo Material"] -side left
    pack [labelframe $frame.apu_cost_mdo -text "Costo Mano de Obra"] -side left
    pack [labelframe $frame.apu_cost_herramienta -text "Costo Herramienta"] -side left
    pack [labelframe $frame.apu_cost_equipo -text "Costo Equipo"] -side left
    pack [labelframe $frame.apu_cost_transporte -text "Costo Transporte"] -side left
    pack [labelframe $frame.apu_cost_subcontrato -text "Costo Subcontrato"] -side left
    chan puts $MAIN::chan [json::write object {*}$event]
  }

  proc 'do'update { resp } {
    variable frame
    variable description
    upvar $resp response
    array set row [deserialize $response(row)]

    set id [regsub -all {[.]} $row(APU_id) "_"]

    set param "apu_id"
    set fr $frame.$param.$id
    $fr.label configure -text $row(APU_id)

    set param "apu_description"
    set fr $frame.$param.$id
    array set conf [list \
      from viewBudget \
      module viewBudget \
      idkey APU_id \
      key APU_description \
      frame $fr \
      dollar false \
      currency false \
    ]
    labelentry::setup [array get conf] [array get row] [array get description]

    if { $row(APU_expand) == false } {
      set param "apu_cost"
      set fr $frame.$param.$id
      array set conf [list \
        from viewBudget \
        module viewBudget \
        idkey APU_id \
        key APU_cost \
        frame $fr \
        dollar true \
        currency true \
      ]
      labelentry::setup [array get conf] [array get row] [array get description]
    } else {
      set param "apu_cost"
      set fr $frame.$param.$id
      $fr.label configure -text "\$[format'currency $row(APU_cost)]"
   }

    set param "apu_cost_material"
    set fr $frame.$param.$id
    $fr.label configure -text "\$[format'currency $row(APU_cost_material)]"

    set param "apu_cost_mdo"
    set fr $frame.$param.$id
    $fr.label configure -text "\$[format'currency $row(APU_cost_mdo)]"

    set param "apu_cost_equipo"
    set fr $frame.$param.$id
    $fr.label configure -text "\$[format'currency $row(APU_cost_equipo)]"

    set param "apu_cost_herramienta"
    set fr $frame.$param.$id
    $fr.label configure -text "\$[format'currency $row(APU_cost_herramienta)]"

    set param "apu_cost_transporte"
    set fr $frame.$param.$id
    $fr.label configure -text "\$[format'currency $row(APU_cost_transporte)]"

    set param "apu_cost_subcontrato"
    set fr $frame.$param.$id
    $fr.label configure -text "\$[format'currency $row(APU_cost_subcontrato)]"

    if { $row(APU_expand) == false } {
      set param "apu_duration"
      set fr $frame.$param.$id
      array set conf [list \
        from viewBudget \
        module viewBudget \
        idkey APU_id \
        key APU_duration \
        frame $fr \
        dollar false \
        currency true \
      ]
      labelentry::setup [array get conf] [array get row] [array get description]
    } else {
      set param "apu_duration"
      set fr $frame.$param.$id
      $fr.label configure -text "$row(APU_duration)"
    }

    if { $row(APU_expand) == false } {
      set param "qtakeoff_qop"
      set fr $frame.$param.$id
      array set conf [list \
      from viewBudget \
      module viewBudget \
      idkey APU_id \
      key Qtakeoff_qop \
      frame $fr \
      dollar false \
      currency true \
      ]
      labelentry::setup [array get conf] [array get row] [array get description]
    } else {
      set param "qtakeoff_qop"
      set fr $frame.$param.$id
      $fr.label configure -text "$row(Qtakeoff_qop) $row(APU_unit)"
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
    variable description
    upvar $resp response
    array set row [deserialize $response(row)]

    set id [regsub -all {[.]} $row(APU_id) "_"]

    set param "apu_id"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text $row(APU_id)] -side left

    set param "apu_description"
    set fr $frame.$param.$id
    array set conf [list \
      from viewBudget \
      module viewBudget \
      idkey APU_id \
      key APU_description \
      frame [frame $fr] \
      dollar false \
      currency false \
    ]
    pack $conf(frame) -side top -fill x -expand true
    labelentry::setup [array get conf] [array get row] [array get description]

    if { $row(APU_expand) == false } {
      set param "apu_cost"
      set fr $frame.$param.$id
      array set conf [list \
        from viewBudget \
        module viewBudget \
        idkey APU_id \
        key APU_cost \
        frame [frame $fr] \
        dollar true \
        currency true \
      ]
      pack $conf(frame) -side top -fill x -expand true
      labelentry::setup [array get conf] [array get row] [array get description]
    } else {
      set param "apu_cost"
      set fr $frame.$param.$id
      pack [frame $fr] -fill x -expand true
      pack [label $fr.label -text "\$[format'currency $row(APU_cost)]"] \
        -side right
    }

    set param "apu_cost_material"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text "\$[format'currency $row(APU_cost_material)]"] \
      -side right

    set param "apu_cost_mdo"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text "\$[format'currency $row(APU_cost_mdo)]"] \
      -side right

    set param "apu_cost_equipo"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text "\$[format'currency $row(APU_cost_equipo)]"] \
      -side right

    set param "apu_cost_herramienta"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text "\$[format'currency $row(APU_cost_herramienta)]"] \
      -side right

    set param "apu_cost_transporte"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text "\$[format'currency $row(APU_cost_transporte)]"] \
      -side right

    set param "apu_cost_subcontrato"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text "\$[format'currency $row(APU_cost_subcontrato)]"] \
      -side right

    if { $row(APU_expand) == false } {
      puts "ok ok ok"
      set param "apu_duration"
      set fr $frame.$param.$id
      array set conf [list \
        from viewBudget \
        module viewBudget \
        idkey APU_id \
        key APU_duration \
        frame [frame $fr] \
        dollar false \
        currency true \
      ]
      pack $conf(frame) -side top -fill x -expand true
      labelentry::setup [array get conf] [array get row] [array get description]
    } else {
      set param "apu_duration"
      set fr $frame.$param.$id
      pack [frame $fr] -fill x -expand true
      pack [label $fr.label -text "$row(APU_duration)"] -side right
    }

    if { $row(APU_expand) == false } {
      set param "qtakeoff_qop"
      set fr $frame.$param.$id
      array set conf [list \
      from viewBudget \
      module viewBudget \
      idkey APU_id \
      key Qtakeoff_qop \
      frame [frame $fr] \
      dollar false \
      currency true \
      ]
      pack $conf(frame) -side top -fill x -expand true
      labelentry::setup [array get conf] [array get row] [array get description]
    } else {
      set param "qtakeoff_qop"
      set fr $frame.$param.$id
      pack [frame $fr] -fill x -expand true
      pack [label $fr.label -text "$row(Qtakeoff_qop) $row(APU_unit)"] -side right
    }

  }

}
