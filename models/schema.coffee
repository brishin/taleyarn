mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

Story = new Schema
  author: ObjectId
  title: String
  dateCreated:
    type: Date
    default: Date.now
  dateModified: Date
  snippets: [Snippets]

Snippets = new Schema
  author: ObjectId
  title: String
  body: String
  dateCreated:
    type: Date
    default: Date.now
  dateModified: Date