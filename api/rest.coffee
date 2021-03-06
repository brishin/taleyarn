conf = require '../conf'

module.exports = (server, mongoose) ->
  mongoose.connect conf.db.host, conf.db.name, conf.db.port
  Story = mongoose.model 'Story'

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
          throw errs
        res.send(stories)

  server.post '/stories', (req, res) ->
    story = new Story(req.body.story)
    story.author = req.sesion.auth.userId
    story.save (err) ->
      if (err)
        utils.mongooseErrorHandler(err, req)
      else
        res.send(story)

  server.get '/stories/:id', (req, res) ->
    res.send(req.story)