class Country < Pattana::ApplicationRecord
  
  # Associations
  has_many :regions
  has_many :cities
  has_one :flag_image, :as => :imageable, :dependent => :destroy, :class_name => "Image::FlagImage"

	# Validations
	validates :name, presence: true, length: {minimum: 3, maximum: 128}
	
  # ------------------
  # Class Methods
  # ------------------

  # Scopes Methods

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> country.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(name) LIKE LOWER('%#{query}%') OR 
                                        LOWER(official_name) LIKE LOWER('%#{query}%') OR 
                                        LOWER(iso_name) LIKE LOWER('%#{query}%') OR 
                                        LOWER(dialing_prefix) LIKE LOWER('%#{query}%') OR 
                                        LOWER(currency_code) LIKE LOWER('%#{query}%') OR 
                                        LOWER(iso_alpha_2) LIKE LOWER('%#{query}%') OR 
                                        LOWER(iso_alpha_3) LIKE LOWER('%#{query}%')")}

  scope :show_in_api, lambda {|val| where("countries.show_in_api is #{val.to_s.upcase}")}
  scope :operational, lambda {|val| where("countries.operational is #{val.to_s.upcase}")}

  # Import Methods

  def self.save_row_data(hsh)

    return if hsh[:name].blank?

    iso_alpha_2 = self.clean_string(hsh[:iso_alpha_2])
    country = Country.where("iso_alpha_2 = ?", iso_alpha_2).first || Country.new(iso_alpha_2: iso_alpha_2)
    
    country.name = self.clean_string(hsh[:name]) if hsh[:name]
    country.iso_name = self.clean_string(hsh[:iso_name]) if hsh[:iso_name]
    country.official_name = self.clean_string(hsh[:official_name]) if hsh[:official_name]
    
    country.iso_alpha_3 = self.clean_string(hsh[:iso_alpha_3]) if hsh[:iso_alpha_3]
    country.itu_code = self.clean_string(hsh[:itu_code]) if hsh[:itu_code]
    country.dialing_prefix = self.clean_string(hsh[:dialing_prefix].to_s) if hsh[:dialing_prefix]
    country.fips = self.clean_string(hsh[:fips]) if hsh[:fips]
    
    country.currency_code = self.clean_string(hsh[:currency_code]) if hsh[:currency_code]
    country.currency_name = self.clean_string(hsh[:currency_name]) if hsh[:currency_name]
    country.is_independent = self.clean_string(hsh[:is_independent]) if hsh[:is_independent]
    country.capital = self.clean_string(hsh[:capital]) if hsh[:capital]
    country.continent = self.clean_string(hsh[:continent]) if hsh[:continent]
    country.tld = self.clean_string(hsh[:tld]) if hsh[:tld]
    country.languages = self.clean_string(hsh[:languages]) if hsh[:languages]

    country.latitude = self.clean_string(hsh[:latitude]) if hsh[:latitude] && hsh[:latitude] != "NULL"
    country.longitude = self.clean_string(hsh[:longitude]) if hsh[:longitude] && hsh[:longitude] != "NULL"

    country.show_in_api = true if hsh[:show_in_api] && ["t", "true", "yes", "y"].include?(self.clean_string(hsh[:show_in_api]).downcase)
    
    # Initializing error hash for displaying all errors altogether
    error_object = Kuppayam::Importer::ErrorHash.new

    if country.valid?
      begin
        country.save!
      rescue Exception => e
        summary = "uncaught #{e} exception while handling connection: #{e.message}"
        details = "Stack trace: #{e.backtrace.map {|l| "  #{l}\n"}.join}"
        error_object.errors << { summary: summary, details: details }        
      end
    else
      summary = "Error while saving country: #{country.name}"
      details = "Error! #{country.errors.full_messages.to_sentence}"
      error_object.errors << { summary: summary, details: details }
    end
    return error_object
  end

  def self.mark_operational_data(hsh)

    return if hsh[:name].blank?

    country = Country.where("name = ?", hsh[:name]).first

    # Initializing error hash for displaying all errors altogether
    error_object = Kuppayam::Importer::ErrorHash.new
    
    if country
      begin
        country.regions.update_all(operational: true)
        country.cities.update_all(operational: true)
        country.operational = true
        country.save
      rescue Exception => e
        summary = "uncaught #{e} exception while marking '#{hsh[:name]}' as operational: #{e.message}"
        details = "Stack trace: #{e.backtrace.map {|l| "  #{l}\n"}.join}"
        error_object.errors << { summary: summary, details: details }        
      end
    else
      summary = "Error while marking '#{hsh[:name]}' as operational"
      details = "Country is nil. Couldn't find country with name '#{hsh[:name]}'"
      error_object.errors << { summary: summary, details: details }
    end
    return error_object
  end

  def self.import_operational_data_file(csv_path, single_transaction=true, verbose=true)
    print_memory_usage do
      print_time_spent do
        if File.exists?(csv_path)
          if File.extname(csv_path) == ".csv"
            puts "CSV file found at '#{csv_path.to_s}'.".green if verbose
            
            errors = []
            sum = 0

            # , encoding: 'windows-1251:utf-8', :row_sep => :auto
            if single_transaction
              ActiveRecord::Base.transaction do 
                CSV.foreach(csv_path, headers: true, header_converters: :symbol, skip_blanks: true) do |row|
                  error_object = mark_operational_data(row)
                  errors << error_object if error_object
                  error_object.print_dot if error_object && verbose
                  sum += 1
                end
              end
            else
              CSV.foreach(csv_path, headers: true, header_converters: :symbol, skip_blanks: true) do |row|
                error_object = mark_operational_data(row)
                errors << error_object if error_object
                error_object.print_dot if error_object && verbose
                sum += 1
              end
            end
            puts "\tScanned #{sum} rows".yellow

            if verbose
              puts ""
              errors.each do |error_object|
                error_object.print_all if error_object
              end
            end

          else
            puts "Unsupported File encountered'#{csv_path.to_s}'.".red if verbose
            return
          end
        else
          puts "Import File not found at '#{csv_path.to_s}'.".red if verbose
        end
      end
    end
  end

  # ------------------
  # Instance Methods
  # ------------------

  # Permission Methods
  # ------------------

  def can_be_edited?
    true
  end

  def can_be_deleted?
    return false if self.regions.any? || self.cities.any?
    return false if operational?
    true
  end

  # Other Methods
  # -------------

  # * Return full name
  # == Examples
  #   >>> country.display_name
  #   => "India"
  def display_name
    self.name
  end

  # * Return Yes or No
  # == Examples
  #   >>> country.display_show_in_api
  #   => "No"
  def display_show_in_api
    self.show_in_api ? "Yes" : "No"
  end

  # * Return Yes or No
  # == Examples
  #   >>> country.display_operational
  #   => "Yes"
  def display_operational
    self.operational ? "Yes" : "No"
  end
	
end