class City < ActiveRecord::Base
    require 'csv'
    def self.generate_cities
        i =0
        File.open("worldcitiespop.txt").each do |line|
            puts line.inspect
            line.encode!('UTF-8', :undef => :replace, :invalid => :replace, :replace => "")
            row = line.strip.split(",")
            puts row.inspect
            if row[1] != "" && row[4] != ""
                city = City.new
                city.tap do |c|
                    c.name = row[1]
                    c.population = row[4]
                    c.latitude = row[5]
                    c.longitude = row[6]
                    c.save
                end
            end

        end
    end
end
