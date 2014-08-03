class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    lat_lon_list = City.currently_sunset
    @photo = Photo.new(lat_lon_list)
  end

  def full_screen
    lat_lon_list = City.currently_sunset
    @photo = Photo.new(lat_lon_list)
    render 'application/full_screen'
  end

end
