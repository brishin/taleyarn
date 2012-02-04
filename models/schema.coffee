mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

Story = new Schema
  author: ObjectId
  genre: String
  authorStyle: String
  title:
    type: String
    required: true
  dateCreated:
    type: Date
    default: Date.now
  dateModified: Date
  smsCode: String
  snippets: [Snippet]

Snippet = new Schema
  author: ObjectId
  title: 
    type: String
    required: true
  body:
    type: String
    required: true
  dateCreated:
    type: Date
    default: Date.now
  dateModified: Date

mongoose.model 'Story', Story
mongoose.model 'Snippet', Snippet