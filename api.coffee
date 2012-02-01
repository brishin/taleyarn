Story = mongoose.model('Story')

module.exports = (server) ->
  
  app.param 'id', (req, res, next, id) ->
    Story
      .findById(req.params.id)
      .run (err, story) ->
        if (err) 
          next(err)
        if (!story)
          next(new Error('Failed to load article ' + id))
        req.story = story
        next()

  server.get '/stories', (req, res) ->
    Story
      .find({})
      .desc('created_at')
      .run (err, stories) ->
        if (err)
          throw err
        res.send(stories)

  server.get '/stories/:id', (req, res) ->
    res.send(req.story)