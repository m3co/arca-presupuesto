'use strict';
(() => {

  const fields = [
    'AAU_id',
    'AAU_description',
    'AAU_cost',
    'AAU_duration',
    'Qtakeoff_qop',
    'AAU_unit'
  ];

  const header = ['', 'Descripcion', 'Costo', 'Duracion', 'Cantidad', 'Unidad'];

  window.budget = setupTable({
    module: 'viewBudget',
    header: header,
    fields: fields,
    actions: [],
    idkey: 'id',
  });

})();
