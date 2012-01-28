class Lectito.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:
    id: null
    nickname: null
    fullname: null

class Lectito.Collections.UsersCollection extends Backbone.Collection
  model: Lectito.Models.User
  url: '/users'
