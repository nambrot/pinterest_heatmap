require 'eventmachine'
require 'em-http'

class PinterestSearchController < ApplicationController
  respond_to :json

  def search
    respond_with Pin.limit(25)
    # response = JSON.parse(HTTParty.get("https://api.pinterest.com/v3/feeds/travel/?access_token=MTQzNTc4Mjo1NDEyNzY1ODYzNzMwMzg3NjU6MnwxMzkwNjgwNTAzOjAtLWRkYTBiNjc5ZGU5ZjEyNzkwMDQ0MmMwNDkwOTUzNjNlNjcxZGJkYmY=#{params[:bookmark] ? '&bookmark=' + params[:bookmark] : ''}&page_count=100").body)
    # @return_val = []
    # EventMachine.run do

    #   EM::Iterator.new(response['data'], 10).each(
    #     proc { |pin, iter|
    #       http = EventMachine::HttpRequest.new('http://23.96.48.232:9000').post(:body => "in " + pin['description'], :head => {"Content-type" => "text/plain"} ) 
    #       http.callback do |response| 
    #         pin['locationData'] = JSON.parse(response.response)
    #         Pin.create :uid => pin['id'], :data => pin.to_json
    #         @return_val << pin
    #         iter.next
    #       end
    #       http.errback do
    #         iter.next
    #       end
    #     }, 
    #     proc { 
    #       p 'All done!'
    #       EM.stop 
    #     })
    # end
    # respond_with({
    #       :l => @return_val.length,
    #       :bookmark => response['bookmark'],
    #       :data => @return_val
    #     })
  end

end
