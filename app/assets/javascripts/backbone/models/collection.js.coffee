class Lectito.Models.Collection extends Backbone.Model
  paramRoot: 'collection'

  defaults:
    id: null
    name: null

class Lectito.Collections.CollectionsCollection extends Backbone.Collection
  model: Lectito.Models.Collection
  url: '/collections'
