mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

StorySchema = new Schema
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

SnippetSchema = new Schema
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

mongoose.model 'Story', StorySchema
mongoose.model 'Snippet', SnippetSchema

Story = mongoose.model 'Story'
Snippet = mongoose.model 'Snippet'