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
