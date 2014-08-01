require 'open-uri'
require 'json'

class Photo

  attr_reader :list_of_lon_lat

  def initialize(list_of_lon_lat)
    @list_of_lon_lat = list_of_lon_lat
  end

  def sunset_by_lat_lon
    #binding.pry
    if list_of_lon_lat.empty?
      @photo_url = "http://flickr.com/47022012@N05/11917764943"
      @author = "smileybears"
      @location = "Atlanta"
      "https://farm4.staticflickr.com/3846/14796102872_8d34287bf2_b.jpg"
    else
      coordinates = self.get_lat_long
      @lat, @lon = coordinates[0],coordinates[1]
      @location = coordinates[2]
      source = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=ec7bc063e59faf82689e51120e618d2d&tags=sunset&sort=interestingness-desc&safe_search=1&lat=#{@lat}&lon=#{@lon}&radius=32&radius_units=km&format=json&nojsoncallback=1&extras=path_alias%2Cowner_name%2Curl_l"
      data = JSON.load(open(source))
      
      begin
        count = data["photos"]["photo"].count
        index = rand(0..[20, count -1].min )
        farm_id = data["photos"]["photo"][index]["farm"]
        server_id = data["photos"]["photo"][index]["server"]
        id = data["photos"]["photo"][index]["id"]
        secret = data["photos"]["photo"][index]["secret"]
        owner = data["photos"]["photo"][index]["owner"]

        @photo_url = "http://flickr.com/#{owner}/#{id}"

        @author = data["photos"]["photo"][index]["ownername"]

        "http://farm#{farm_id}.staticflickr.com/#{server_id}/#{id}_#{secret}_b.jpg"
      rescue 
        sunset_by_lat_lon
      end
    end
  end

  def get_lat_long
    list_of_lon_lat.sample
  end

  def author
    @author
  end

  def location
    @location
  end

  def photo_url
    @photo_url
  end

  def latitude
    @lat
  end

  def longitude
    @lon
  end

end

