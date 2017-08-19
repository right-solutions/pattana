require 'csv'
require 'open-uri'
require 'time'
require 'colorize'

namespace 'import' do
  namespace 'master_data' do

    desc "Import all data in sequence"
    task 'all' => :environment do

      import_list = ["countries", "regions", "cities"]
      
      import_list.each do |item|
        print "Importing #{item.titleize} \t".yellow
        begin
          Rake::Task["import:master_data:#{item}"].invoke
        rescue ArgumentError => e
            puts "Loading #{item} - Failed - #{e.message}".red
        rescue Exception => e
          puts "Importing #{item.titleize} - Failed - #{e.message}".red
          puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        end
      end
      puts " "
    end

    # Import from SQL file
    ["Country", "Region", "City"].each do |cls_name|
      name = cls_name.underscore.pluralize
      desc "Import #{cls_name.pluralize}"
      task name => :environment do
        path = Pattana::Engine.root.join('db', 'master_data', "#{cls_name.constantize.table_name}.sql")
        begin
          system "bundle exec rails db < #{path.to_s}"
          puts "Imported #{cls_name.pluralize} SQL file successfully".green
          puts "Saved #{cls_name.constantize.count} rows".green
        rescue ArgumentError => e
          puts "Loading #{cls_name} - Failed - #{e.message}".red
        rescue Exception => e
          puts "Importing #{cls_name.titleize} - Failed - #{e.message}".red
          puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        end
      end
    end

  end
end
    