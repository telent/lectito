class Lectito.Models.Tagname extends Backbone.Model
  paramRoot: 'tagname'

  defaults:
    id: null
    mycount: null
    allcount: null

class Lectito.Collections.TagnamesCollection extends Backbone.Collection
  model: Lectito.Models.Tagname
  url: '/tagnames'
