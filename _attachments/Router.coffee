$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$  = $
_ = require 'underscore'
moment = require 'moment'

LineGraphView = require './views/LineGraphView.coffee'

class Router extends Backbone.Router
  routes:
    "": "lineGraphView"
    "lineGraphView": "lineGraphView"

  lineGraphView: (name) ->
    @LineGraphView = new LineGraphView() unless @LineGraphView
    @LineGraphView.render()


router = new Router()
Backbone.history.start()

module.exports = Router
