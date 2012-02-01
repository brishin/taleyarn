mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

Story = new Schema
  author: ObjectId
  title:
    type: String
    required: true
  dateCreated:
    type: Date
    default: Date.now
  dateModified: Date
  smsCode: String
  snippets: [Snippets]

Snippets = new Schema
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