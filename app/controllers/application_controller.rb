class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    long_lat = City.currently_sunset
    @photo = Photo.new(long_lat)
  end

end
