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
  userList: ObjectId
  sizeUserList: Number
  nextUser: ObjectId
  currentNumUsers:
    type: Number
    default: 0
  maxUsers: Number

UserList = new Schema
  user:
    type: ObjectId
    unique: true
  listIndex:
    type: Number
    unique: true

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