require 'eventmachine'
require 'em-http'

class PinterestSearchController < ApplicationController
  respond_to :json

  def search
    response = JSON.parse(HTTParty.get("https://api.pinterest.com/v3/search/pins/?query=&restrict=travel&access_token=MTQzNTc4Mjo1NDEyNzY1ODYzNzMwMzg3NjU6MnwxMzkwNjgwNTAzOjAtLWRkYTBiNjc5ZGU5ZjEyNzkwMDQ0MmMwNDkwOTUzNjNlNjcxZGJkYmY=#{params[:bookmark] ? '&bookmark=' + params[:bookmark] : ''}").body)
    puts response['data'].first
    @return_val = nil
    EventMachine.run do
      multi = EventMachine::MultiRequest.new

      response['data'].map {|pin| puts multi.add(pin['id'] ,EventMachine::HttpRequest.new('http://23.96.48.232:9000').post(:body => "in " + pin['description'], :head => {"Content-type" => "text/plain"} )) }

      multi.callback {
        response['data'].keep_if{|pin| multi.responses[:callback].keys.include? pin['id']}
        @return_val = response['data'].map{|pin| pin['locationData'] = JSON.parse(multi.responses[:callback][pin['id']].response); pin}
        EM.stop
      }

    end
    respond_with({
          :bookmark => response['bookmark'],
          :data => @return_val
        })
  end

end
