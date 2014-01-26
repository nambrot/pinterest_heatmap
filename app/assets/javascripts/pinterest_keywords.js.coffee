class @Pin extends Backbone.Model
class @PinterestKeyword extends Backbone.Collection
  model: Pin
  keyword: 'travel'
  fetch_pins: ->
    console.log "fetch more pins"
    url = '/pinterest_search.json'
    url += "?bookmark=#{@bookmark}" if @bookmark
    $.getJSON url, (resp) =>
      @bookmark = resp.bookmark
      $.each resp.data, (index, pin) =>
        if pin.locationData? and pin.locationData.locations.length > 0
          @add
            lat: (pin.locationData.locations[0].latitude)
            lon: (pin.locationData.locations[0].longitude)
            value: 1
      if @models.length < 2000
        @fetch_pins()
  get_location_of_pin: (pin) ->
    $.getJSON "http://api.geonames.org/searchJSON?q=#{escape(pin.description)}&maxRows=10&lang=es&username=nam&style=full&callback=?",

