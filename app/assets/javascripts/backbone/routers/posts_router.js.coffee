class Lectito.Routers.PostsRouter extends Backbone.Router
  initialize: (options) ->
    @posts = new Lectito.Collections.PostsCollection()
    @posts.reset options.posts

  routes:
    "/new"      : "newPost"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  newPost: ->
    @view = new Lectito.Views.Posts.NewView(collection: @posts)
    $("#posts").html(@view.render().el)

  index: ->
    @view = new Lectito.Views.Posts.IndexView(posts: @posts)
    $("#posts").html(@view.render().el)

  show: (id) ->
    post = @posts.get(id)

    @view = new Lectito.Views.Posts.ShowView(model: post)
    $("#posts").html(@view.render().el)

  edit: (id) ->
    post = @posts.get(id)

    @view = new Lectito.Views.Posts.EditView(model: post)
    $("#posts").html(@view.render().el)
