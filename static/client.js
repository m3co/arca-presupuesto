'use strict';
((io) => {
  var client = io();
  client.on('connect', () => {
    console.log('connection');

    client.emit('data', {
      query: 'subscribe',
      module: 'viewBudget'
    });

    client.emit('data', {
      query: 'select',
      module: 'viewBudget',
      keynote: '8'
    });
  });

  client.on('response', (data) => {
    var query = data.query;
    var row = data.row;
    var action;
    if (row) {
      if (data.module == 'viewBudget') {
        action = budget[`do${query}`];
        if (action) { action(row); }
        else {
          console.log('sin procesar viewBudget');
        }
      } else {
        console.log('sin procesar', data);
      }
    }
  });
  window.client = client;
})(io);
