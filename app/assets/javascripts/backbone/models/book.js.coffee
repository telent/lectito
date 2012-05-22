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
  sort_order: 'created_at'
  sort_direction: 'ascending'
  fetch_selection: ->
    this.fetch({data: {
                page: @page,
                sort: @sort_order,
                direction: @sort_direction
                }})
  next_page: ->
    @page+=1
    this.fetch_selection()
  previous_page: ->
    if @page>1
      @page-=1
      this.fetch_selection()
  sort_by: (field,direction) ->
    @sort_order=field;
    @sort_direction=direction;
    @page=1
    this.fetch_selection()
