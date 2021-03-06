class Pin < ActiveRecord::Base
  validates :uid, :uniqueness => true
  def self.fetch_pins(feed = "travel")
    response = JSON.parse(HTTParty.get("https://api.pinterest.com/v3/feeds/#{feed}/?access_token=MTQzNTc4Mjo1NDEyNzY1ODYzNzMwMzg3NjU6MnwxMzkwNjgwNTAzOjAtLWRkYTBiNjc5ZGU5ZjEyNzkwMDQ0MmMwNDkwOTUzNjNlNjcxZGJkYmY=#{Bookmark.first ? '&bookmark=' + Bookmark.first.bookmark : ''}&page_size=100").body)
    if b = Bookmark.first
      b.previous_bookmark = b.bookmark
      b.bookmark = response['bookmark']
      b.save
    else
      Bookmark.create({:bookmark => response['bookmark']})
    end
    pins = Pin.create response['data'].map { |pin| {:uid => pin['id'], :data => pin.to_json, :location_check => false} }
    pins.each {|pin| pin.delay(:queue => 'location_check').check_location if pin.persisted?}

    # EventMachine.run do

    #   EM::Iterator.new(response['data'], 10).each(
    #     proc { |pin, iter|
    #       http = EventMachine::HttpRequest.new('http://23.96.48.232:9000').post(:body => "in " + pin['description'], :head => {"Content-type" => "text/plain"} ) 
    #       http.callback do |response| 
    #         pin['locationData'] = JSON.parse(response.response)
    #         Pin.create :uid => pin['id'], :data => pin.to_json
    #         iter.next
    #       end
    #       http.errback do
    #         iter.next
    #       end
    #     }, 
    #     proc { 
    #       EM.stop 
    #     })
    # end
  end

  def check_location
    parsed_data = JSON.parse self.data
    ip = ['http://191.234.38.200:9000', 'http://137.117.82.167:9000', 'http://168.61.32.99:9000' ][self.id % 3]
    puts ip
    response = JSON.parse(HTTParty.post(ip, :body => "in " + parsed_data['description'], :headers => {"Content-type" => "text/plain"}  ).body)
    if response['locations'].length > 0
      self.location_check = true
      parsed_data['locationData'] = response['locations']
      self.data =  parsed_data.to_json
      self.save
    else
      self.destroy
    end
  end

  def get_pins_of_related_boards
    boards = JSON.parse(HTTParty.get("https://api.pinterest.com/v3/pins/#{self.uid}/related/board/?access_token=MTQzNTc4Mjo1NDEyNzY1ODYzNzMwMzg3NjU6MnwxMzkwNjgwNTAzOjAtLWRkYTBiNjc5ZGU5ZjEyNzkwMDQ0MmMwNDkwOTUzNjNlNjcxZGJkYmY=").body)['data']
    for board in boards
      pins = JSON.parse(HTTParty.get("https://api.pinterest.com/v3/boards/#{board['id']}/pins/?access_token=MTQzNTc4Mjo1NDEyNzY1ODYzNzMwMzg3NjU6MnwxMzkwNjgwNTAzOjAtLWRkYTBiNjc5ZGU5ZjEyNzkwMDQ0MmMwNDkwOTUzNjNlNjcxZGJkYmY=").body)['data']
      pins = Pin.create pins.map { |pin| {:uid => pin['id'], :data => pin.to_json, :location_check => false} }
      pins.each {|pin| pin.delay(:queue => 'location_check').check_location if pin.persisted?}
    end
  end
end
