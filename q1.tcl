
namespace eval viewBudget {
  variable frame
  variable project

  proc open { space id } {
    variable frame $space
    variable project $id
    array set event [list \
      query select \
      module viewBudget \
      from viewBudget \
      keynote $id
    ]

    pack [labelframe $frame.keynotes_id -text "Codigo"] -side left
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
    chan puts $MAIN::chan [array get event]
  }

  proc 'do'update { resp } {
    variable frame
    variable project
    upvar $resp response
    array set row [deserialize $response(row)]
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

    set id [regsub -all {[.]} $row(Keynotes_id) "_"]

    set param "keynotes_id"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text $row(Keynotes_id)] -side left

    set param "apu_description"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text $row(APU_description)] -side left

    set param "apu_cost"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text "\$[format'currency $row(APU_cost)]"] \
      -side right

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

    set param "apu_duration"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text "$row(APU_duration) días"] -side right

    set param "qtakeoff_qop"
    set fr $frame.$param.$id
    pack [frame $fr] -fill x -expand true
    pack [label $fr.label -text "$row(Qtakeoff_qop) $row(APU_unit)"] -side right
  }

}
