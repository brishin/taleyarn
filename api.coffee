Schema = require('./models/schema.js')

exports.storyList = (req, res) ->
	Schema.Story.find (err, threads) ->
		res.send(threads)

exports.storyShow = (req, res) ->
	Schema.Story.findOne title: req.params.id, (err, thread) ->
		res.send(thread)