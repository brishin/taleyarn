() ->
  server = false
  if (typeof exports != 'undefined')
    _ = require('underscore')._
    Backbone = require('backbone')
    models = exports;
    server = true;
  else
    models = this.models = {}