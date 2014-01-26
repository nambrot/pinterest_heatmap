#  This is a manifest file that'll be compiled into application.js, which will include all the files
#  listed below.
# 
#  Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
#  or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
# 
#  It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
#  compiled file.
# 
#  Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
#  about supported directives.
# 
# = require jquery
# = require jquery_ujs
# = require foundation
# = require turbolinks
# = require basic
# = require leaflet
# = require QuadTree
# = require heatmap
# = require underscore
# = require backbone
# = require heatmap-leaflet
# = require pinterest_keywords

$(document).on 'ready page:load', ->
  map = L.map('map').setView([51.505, -0.09], 2)
  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map)


  window.heatmapLayer = L.TileLayer.heatMap({
                      radius: 10,
                      opacity: 0.8,
                      gradient: {
                          0.45: "rgb(0,0,255)",
                          0.55: "rgb(0,255,255)",
                          0.65: "rgb(0,255,0)",
                          0.95: "yellow",
                          1.0: "rgb(255,0,0)"
                      }
                  })
  
  testData = {
              max: 46,
              data: [{lat: 33.5363, lon:-117.044, value: 1},{lat: 33.5608, lon:-117.24, value: 1}]
          };
  heatmapLayer.addData(testData.data);
  heatmapLayer.addTo(map)

  window.travel_keyword = new PinterestKeyword()
  travel_keyword.on 'add', (pin) ->
    heatmapLayer.addDataPoint pin.toJSON()
  travel_keyword.fetch_pins()
 
