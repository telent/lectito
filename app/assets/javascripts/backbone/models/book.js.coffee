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
  page: 1
  sort_order: 'created_at',
  fetch_selection: ->
    this.fetch({data: {page: @page, sort: @sort_order}})
  next_page: ->
    @page+=1
    this.fetch_selection()
  previous_page: ->
    if @page>1 
      @page-=1
      this.fetch_selection()
  sort_by: (field) ->
    @sort_order=field;
    @page=1
    this.fetch_selection()
