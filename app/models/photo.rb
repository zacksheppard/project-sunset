require 'open-uri'
require 'json'

class Photo

  attr_reader :list_of_lat_lon, :author, :location, :photo_url, :lat, :lon

  def initialize(list_of_lat_lon)
    @list_of_lat_lon = list_of_lat_lon
  end

  def sunset_by_lat_lon
    # list_of_lat_lon is passed over from the controller.
    if list_of_lat_lon.empty?
      @photo_url = "http://flickr.com/47022012@N05/11917764943"
      @author = "smileybears"
      @location = "Atlanta"
      "https://farm4.staticflickr.com/3846/14796102872_8d34287bf2_b.jpg"
    else
      coordinates = self.get_lat_lon
      @lat, @lon = coordinates[0],coordinates[1]
      @location = coordinates[2]
      source = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=ec7bc063e59faf82689e51120e618d2d&tags=sunset&sort=interestingness-desc&safe_search=1&lat=#{@lat}&lon=#{@lon}&radius=32&radius_units=km&format=json&nojsoncallback=1&extras=path_alias%2Cowner_name%2Curl_h"
      data = JSON.load(open(source))
      
      begin
        photos = data["photos"]["photo"]
        count = photos.count
        index = rand(0..[20, count -1].min )
        if photos[index]["url_h"] # && width > height # removed for now
          id = photos[index]["id"]
          owner = photos[index]["owner"]
          @photo_url = "http://flickr.com/#{owner}/#{id}"
          @author = photos[index]["ownername"]
          photos[index]["url_h"] 
        else
          puts "Misfire #{data['photos']['photo'][index]['url_h']}"
          puts "------>, Height: #{height}, Width: #{width}, #{@photo_url}"
          sunset_by_lat_lon
        end
      rescue 
        sunset_by_lat_lon
      end
    end
  end

  def get_lat_lon
    list_of_lat_lon.sample
  end

end

