class City < ActiveRecord::Base
    require 'open-uri'
    require 'json'
    def self.generate_cities
        count = 0
        File.open("city_seed_data.txt").each do |line|
            # puts line.inspect
            # line.encode!('UTF-8', :undef => :replace, :invalid => :replace, :replace => "")
            row = line.strip.split(",")
            # binding.pry
            puts row.inspect
            seed_time = Time.now
            # if row[1] != "" && row[4] != "" && row[4] != "0.0"
            unless count == 0
                city = City.new
                

                city.tap do |c|
                    c.name = row[0]
                    c.population = row[1]
                    c.latitude = row[2]
                    c.longitude = row[3]
                    c.dst_offset = row[4]
                    c.raw_offset = row[5]
                    c.total_offset = row[6]
                    c.timezone = row[7]
                    c.sunset_utc = row[8]
                    c.sunset_hour = row[9]
                    c.sunset_min = row[10]
                    c.last_time_updated = seed_time
                    c.save
                end
            end
            # end
            count += 1

        end
    end

    def self.biggest_cities
        City.order(population: :desc).limit(1000)
    end


    def self.print_cities_for_seed_data
        self.biggest_cities.each do |city|
            if city.sunset_utc
                puts "#{city.name},#{city.population},#{city.latitude},#{city.longitude},#{city.dst_offset},#{city.raw_offset},#{city.total_offset},#{city.timezone},#{city.sunset_utc},#{city.sunset_hour},#{city.sunset_min}"
            end
        end
    end

    def self.get_timezones
        date = Time.now.to_s
        self.biggest_cities.each do |city|
            url = "https://maps.googleapis.com/maps/api/timezone/json?location=#{city.latitude},#{city.longitude}&timestamp=#{date}&key=AIzaSyBKiF69WTPFEm5_GO7UBahxww1S9psankk"
            @data = JSON.load(open(url))

            city.dst_offset = @data["dstOffset"]
            city.raw_offset = @data["rawOffset"]
            if  @data["dstOffset"] && @data["rawOffset"]
                city.total_offset = @data["dstOffset"] + @data["rawOffset"]
            else
                puts "can't find offset for #{city.id}: #{city.name}!"
            end
            city.timezone = @data["timeZoneId"]
            puts "done with #{city.id}: #{city.name}"
            city.save
        end
    end



    def self.get_sunset_times
        time_of_api_request = Time.now
        self.cities_to_update.each do |city|
            puts "getting data for #{city.name}"
            url = "http://api.wunderground.com/api/a112e57999a31e49/astronomy/q/#{city.latitude},#{city.longitude}.json"
            @data = JSON.load(open(url))
            
            #"sunset"=>{"hour"=>"21", "minute"=>"16"}
            sunset = @data["sun_phase"]["sunset"]
            city.sunset_hour = sunset["hour"].to_i
            city.sunset_min = sunset["minute"].to_i


            city.sunset_utc = self.sunset_time_to_seconds(sunset["hour"].to_i, sunset["minute"].to_i, city.total_offset)

            puts "#{city.sunset_utc}"

            city.last_time_updated = time_of_api_request
            city.save

        end
    end

    def self.sunset_time_to_seconds(hours, minutes, offset)
        seconds = (hours*60*60 + minutes*60) - offset
        if seconds < 0
            seconds += 86400
        elsif seconds > 86400
            seconds -= 86400
        end
        return seconds 
    end

    def self.currently_sunset
        now = Time.now.utc
        soon = Time.now.utc + (60*20) #add twenty minutes from now in seconds
        seconds_now = self.sunset_time_to_seconds(now.hour, now.min, 0)
        seconds_soon = self.sunset_time_to_seconds(soon.hour, soon.min, 0)

        sunset_cities = []
        self.biggest_cities.each do |city|
            if city.sunset_utc && city.sunset_utc < seconds_soon && city.sunset_utc >= seconds_now
                sunset_cities << [city.latitude, city.longitude, city.name]
            end
        end
        return sunset_cities
    end

    def self.cities_to_update
        where.not(:last_time_updated => (4.days.ago..Time.current))
    end

end