class @Pin extends Backbone.Model
class @PinterestKeyword extends Backbone.Collection
  model: Pin
  keyword: 'travel'
  page: 1
  fetch_pins: ->
    console.log "fetch more pins"
    url = '/pins.json?per_page=1000&page=' + @page
    $.getJSON url, (resp) =>
      @page += 1
      @bookmark = resp.bookmark
      $.each resp, (index, pin) =>
        if pin.locationData? and pin.locationData.length > 0 and pin.locationData[0].name != pin.locationData[0].countryName
          @add
            lat: (pin.locationData[0].latitude)
            lon: (pin.locationData[0].longitude)
            value: Math.log(pin.repin_count + 1)
            attributes: pin
      @trigger 'redraw'
      if resp.length > 0 and @models.length < 2000
        setTimeout((=>
                  @fetch_pins())
          , 100)
      # if @models.length < 2000
        # @fetch_pins()
  get_location_of_pin: (pin) ->
    $.getJSON "http://api.geonames.org/searchJSON?q=#{escape(pin.description)}&maxRows=10&lang=es&username=nam&style=full&callback=?",

