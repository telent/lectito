class Lectito.Models.Book extends Backbone.Model
  paramRoot: 'book'

  defaults:
    book: null
    home_shelf_id: null
    current_shelf_id: null
    collection_id: null
    created_at: null
    borrower_id: null

class Lectito.Collections.BooksCollection extends Backbone.Collection
  model: Lectito.Models.Book
  url: '/books'
  limit: 20
  offset: 0
  tags: null
  collections: null
  shelves: null
  owners: null
  sort_order: 'created_at'
  sort_direction: 'ascending'
  url_paramstring: ->
    a=
      tags: @tags and @tags.map((tag) -> (tag.get('id'))).join()
      collections: @collections and @collections.map((x) -> (x.get('id'))).join()
      shelves: @shelves and @shelves.map((x) -> (x.get('id'))).join()
      limit: @limit
      sort: @sort_order
      direction: @sort_direction
      offset: @offset
    r = (m,v,k) -> ( m[k]=v if v; m )
    $.param(_.reduce(a,r,new Object))
  url: ->
    '/books/?'+this.url_paramstring()
  count_url: ->
    '/books/count?'+this.url_paramstring()
  fetch_count: ->
    that=this
    $.getJSON(this.count_url(),null,
	      (r) -> 
                that.total_count=r.count
                that.trigger('recount'))
  next_page: ->
    @offset+=@limit
    this.fetch()
  previous_page: ->
    @offset-=@limit
    if @offset<0
      @offset=0
    this.fetch()
  sort_by: (field,direction) ->
    @sort_order=field;
    @sort_direction=direction;
    @offset=0
    this.fetch()
