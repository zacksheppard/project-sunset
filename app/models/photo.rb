require 'open-uri'
require 'json'

class Photo

  attr_reader :list_of_lon_lat

  def initialize(list_of_lon_lat)
    @list_of_lon_lat = list_of_lon_lat
  end

  def sunset_by_lat_lon
    coordinates = self.get_lat_long
    @lat, @lon = coordinates[0],coordinates[1]
    @location = coordinates[2]
    source = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=ec7bc063e59faf82689e51120e618d2d&tags=sunset&sort=interestingness-desc&lat=#{@lat}&lon=#{@lon}&format=json&nojsoncallback=1&extras=path_alias%2Cowner_name"
    data = JSON.load(open(source))
    
    farm_id = data["photos"]["photo"][0]["farm"]
    server_id = data["photos"]["photo"][0]["server"]
    id = data["photos"]["photo"][0]["id"]
    secret = data["photos"]["photo"][0]["secret"]
    owner = data["photos"]["photo"][0]["owner"]

    @photo_url = "http://flikr.com/#{owner}/#{id}"

    @author = data["photos"]["photo"][0]["ownername"]

    "http://farm#{farm_id}.staticflickr.com/#{server_id}/#{id}_#{secret}_b.jpg"
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

