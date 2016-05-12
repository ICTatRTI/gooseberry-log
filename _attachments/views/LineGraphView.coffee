$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$  = $
_ = require 'underscore'
Chartist = require 'chartist'
PouchDB = require 'pouchdb'
global.moment = require 'moment'

database = new PouchDB('http://gooseberry.tangerinecentral.org:5984/gooseberry-log')

class LineGraphView extends Backbone.View
  el: '#content'



  render: =>
    @groupLevels = {
      Year: 2
      Month: 3
      Day: 4
      Hour: 5
      Minute: 6
    }

    @$el.html "
      <h1>Messages per 
        <select>
          <option>Year</option>
          <option>Month</option>
          <option>Day</option>
          <option>Hour</option>
          <option>Minute</option>
        </select>
        For past 14 days
      </h1>
      Total: <span id='total'></span>
      <div id='chart'></div>
    "
    @groupLevel = @groupLevel or 4
    $("select").val(_.invert(@groupLevels)[@groupLevel])

    startTime = moment().subtract(14,"days")
    startYear = startTime.format("YYYY")
    startMonth = startTime.format("MM")
    startDay = startTime.format("DD")

    endTime = moment()
    endYear = endTime.format("YYYY")
    endMonth = endTime.format("MM")
    endDay = endTime.format("DD")

    database.query "message_type_by_time",
      startkey: ["incoming", startYear, startMonth, startDay]
      endkey: ["incoming", endYear, endMonth, endDay, {}]
      reduce: true
      group_level: @groupLevel

    .catch (error) -> console.error error
    .then (result) ->
      $('#total').html(_(result.rows).reduce ((memo, row) -> memo + row.value ), 0)

      labels = _(result.rows).map (row) -> row.key[1..].join("-")
      numberOfLabelsToShow = 10
      showEveryXLabels = Math.floor(labels.length/numberOfLabelsToShow)

      new Chartist.Line '#chart',
        labels: labels
        series: [_(result.rows).map (row) -> row.value]
      ,
        width: "100%",
        height: 240
        showPoint: false
        axisX:
          labelInterpolationFnc: (value,index) ->
            if index % showEveryXLabels is 0 then value else null
      
  
  events:
    "change select" : "select"

  select: =>
    @groupLevel = switch $("select").val()
      when "Year" then 2
      when "Month" then 3
      when "Day" then 4
      when "Hour" then 5
      when "Minute" then 6
    @render()

module.exports = LineGraphView
