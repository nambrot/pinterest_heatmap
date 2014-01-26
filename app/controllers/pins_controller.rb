class PinsController < ApplicationController
  respond_to :json
  def index
    respond_with Pin.where(:location_check => true).page(params[:page]).per(params[:per_page]).map { |e| JSON.parse(e.data).keep_if{|k,v| %w(locationData repin_count id).include? k} }
  end
end
