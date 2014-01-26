class Pin < ActiveRecord::Base
  validates :uid, :uniqueness => true
  def self.fetch_pins
    response = JSON.parse(HTTParty.get("https://api.pinterest.com/v3/feeds/travel/?access_token=MTQzNTc4Mjo1NDEyNzY1ODYzNzMwMzg3NjU6MnwxMzkwNjgwNTAzOjAtLWRkYTBiNjc5ZGU5ZjEyNzkwMDQ0MmMwNDkwOTUzNjNlNjcxZGJkYmY=#{Bookmark.first ? '&bookmark=' + Bookmark.first.bookmark : ''}&page_size=200").body)
    if Bookmark.first
      Bookmark.first.update_attribute :bookmark, response['bookmark']
    else
      Bookmark.create({:bookmark => response['bookmark']})
    end

    pins = Pin.create response['data'].map { |pin| {:uid => pin['id'], :data => pin.to_json, :location_check => false} }
    pins.each {|pin| pin.delay(:queue => 'location_check').check_location}

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
    response = JSON.parse(HTTParty.post('http://23.96.48.232:9000', :body => "in " + parsed_data['description'], :headers => {"Content-type" => "text/plain"}  ).body)
    if response['locations'].length > 0
      self.location_check = true
      parsed_data['locationData'] = response['locations']
      self.data =  parsed_data.to_json
      self.save
    else
      self.destroy
    end
  end
end
