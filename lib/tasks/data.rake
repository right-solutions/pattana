require 'csv'
require 'open-uri'
require 'time'
require 'colorize'

namespace 'pattana' do
  namespace 'import' do
    namespace 'data' do
      
      desc "Mark Operational"
      task :mark_operational => :environment do
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)

        destroy_all = false
        destroy_all = true if ["true", "t","1","yes","y"].include?(ENV["destroy_all"].to_s.downcase.strip)
        
        path = Rails.root.join('db', 'data', "operational.csv")
        path = Pattana::Engine.root.join('db', 'data', "operational.csv") unless File.exists?(path)
        
        Country.import_operational_data_file(path, true, verbose)
        puts "Successfully marked the Locations in the CSV as Operational".green if verbose
      end

      desc "Mark All Operational"
      task :mark_all_operational => :environment do
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)

        Country.update_all(operational: true)
        Region.update_all(operational: true)
        City.update_all(operational: true)
      end

      desc "Mark All Show in API"
      task :mark_all_show_in_api => :environment do
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)

        Country.update_all(show_in_api: true)
        Region.update_all(show_in_api: true)
        City.update_all(show_in_api: true)
      end

    end
  end
end
    