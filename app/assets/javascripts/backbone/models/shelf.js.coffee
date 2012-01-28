class Lectito.Models.Shelf extends Backbone.Model
  paramRoot: 'shelf'

  defaults:
    id: null
    name: null

class Lectito.Collections.ShelvesCollection extends Backbone.Collection
  model: Lectito.Models.Shelf
  url: '/shelves'
