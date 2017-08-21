require 'csv'
require 'open-uri'
require 'time'

namespace 'pattana' do
  namespace 'import' do
    namespace 'make_data' do

      # Import from xlsx
      ["Country"].each do |cls_name|
        name = cls_name.underscore.pluralize
        desc "Import #{cls_name.pluralize}"
        task name => :environment do
          verbose = true
          verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
          path = Pattana::Engine.root.join('db', 'make_data', "#{cls_name.constantize.table_name}.xlsx")
          cls_name.constantize.import_data_file(path, true, verbose)
          puts "Importing Completed".green if verbose
        end
      end

      # # Import from a single CSV file
      # ["Region"].each do |cls_name|
      #   name = cls_name.underscore.pluralize
      #   desc "Import #{cls_name.pluralize}"
      #   task name => :environment do
      #     verbose = true
      #     verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
      #     path = Pattana::Engine.root.join('db', 'make_data', "#{cls_name.constantize.table_name}.csv")
      #     cls_name.constantize.import_data_file(path, true, verbose)
      #     puts "Importing Completed".green if verbose
      #   end
      # end

      # Import from multiple split CSV files
      ["Region", "City"].each do |cls_name|
        name = cls_name.underscore.pluralize
        desc "Import #{cls_name.pluralize}"
        task name => :environment do
          verbose = true
          verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
          path = Pattana::Engine.root.join('db', 'make_data', "#{cls_name.constantize.table_name}")
          cls_name.constantize.import_data_recursively(path, true, verbose)
          puts "Importing Completed".green if verbose
        end
      end


      # Import Lattitude & Longitude for Countries
      desc "Import Lat Lon for countries"
      task "countries_lat_lon" => :environment do
        path = Pattana::Engine.root.join('db', 'make_data', "countries_lat_lon.csv")
        CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
          country = Country.where("iso_alpha_2 = ?", row[:iso]).first
          if country
            country.latitude = row[:geo_lat] if row[:geo_lat]
            country.longitude = row[:geo_lng] if row[:geo_lng]
            country.save
            print ".".green
          end
        end
        puts " "
        puts "Importing Completed".green if verbose
      end

    end
  end
end
    