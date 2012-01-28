class Lectito.Models.Post extends Backbone.Model
  paramRoot: 'post'

  defaults:
    title: null
    content: null

class Lectito.Collections.PostsCollection extends Backbone.Collection
  model: Lectito.Models.Post
  url: '/posts'
