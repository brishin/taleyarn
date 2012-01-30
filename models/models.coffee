() ->
  server = false
  if (typeof exports != 'undefined')
    _ = require('underscore')._
    Backbone = require('backbone')
    models = exports
    server = true
  else
    models = this.models = {}
  
  # Models
  models.User = Backbone.model.extend({})

  models.Snippet = Backbone.model.extend
    defaults: ()->

  models.Story = Backbone.Collection.extend
    model: models.Snippet

  # Views
  models.StoryView = Backbone.View.extend
    tagName: 'li'
    template: