class City < Pattana::ApplicationRecord
  
  include ActiveModel::Serializers::JSON
    
  # Constants
  EXCLUDED_JSON_ATTRIBUTES = [:created_at, :updated_at, :show_in_api]

  # Associations
  belongs_to :country
  belongs_to :region, optional: true
  
	# Validations
	validates :name, presence: true, length: {minimum: 3, maximum: 128}
	
  # Callbacks
  before_validation :set_country, on: :create

  # ------------------
  # Class Methods
  # ------------------

  # BACKUP - TODO - REMOVE - TBR
  # Exclude some attributes info from json output.
  # def as_json(options={})
  #   options[:except] ||= EXCLUDED_JSON_ATTRIBUTES
  #   #options[:include] ||= []
  #   #options[:methods] = []
  #   #options[:methods] << :profile_image
  #   json = super(options)
  #   Hash[*json.map{|k, v| [k, v || ""]}.flatten]
  # end

  # Scopes Methods

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> city.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query|  joins("INNER JOIN regions r on cities.region_id = r.id 
                                         INNER JOIN countries co on cities.country_id = co.id ").
                                  where("LOWER(r.name) LIKE LOWER('%#{query}%') OR
                                         LOWER(co.name) LIKE LOWER('%#{query}%') OR
                                         LOWER(cities.name) LIKE LOWER('%#{query}%') OR
                                         LOWER(cities.alternative_names) LIKE LOWER('%#{query}%') OR
                                         LOWER(cities.iso_code) LIKE LOWER('%#{query}%')")}

  scope :show_in_api, -> { where(show_in_api: true) }

  # Import Methods
  
  def self.save_row_data(row_data)
    begin
      city, error_object = self.parse_row_data(row_data)
      city.save if city.errors.blank?
    rescue Exception => e
      summary = "uncaught #{e} exception while handling connection: #{e.message}"
      details = "Stack trace: #{e.backtrace.map {|l| "  #{l}\n"}.join}"
      error_object.errors << { summary: summary, details: details }
    end
    return error_object
  end

  def self.parse_row_data(row_data)

    # Initializing error hash for displaying all errors altogether
    error_object = Kuppayam::Importer::ErrorHash.new

    if row_data[:name].blank?
      name = ""
    else
      name = self.clean_string(row_data[:name], :name)
      country_iso_code = self.clean_string(row_data[:iso_alpha_2], :iso_alpha_2)
      # Sometimes the name could be just 2 letters.
      # In that case, just to let it go, add the region or country name to it 
      name = "#{name}-#{country_iso_code}" if name && name.size <= 2
    end

    city = City.find_by_name(name) || City.new(name: name)

    region = nil
    begin
      
      # Some data sheet would have an iso code for city (iso_code)
      # Some other would have just their country name (country) or country iso code (iso_alpha_2) and region name (region)
      if row_data[:iso_code]
        city.iso_code = self.clean_string(row_data[:iso_code], :iso_code)
        region_iso_code = city.iso_code.split("-")[0..1].join("-")
        region = Region.where("iso_code = ?", region_iso_code).first  if region_iso_code
      elsif row_data[:region_id] && country_iso_code
        region_id = self.clean_string(row_data[:region_id], :region_id)
        region_code1 = "#{country_iso_code}-#{region_id}"
        region_code2 = "#{country_iso_code}-0#{region_id}"
        region = Region.where("iso_code = ? or iso_code = ?", region_code1, region_code2).first
      elsif row_data[:region] && country_iso_code
        region_name = self.clean_string(row_data[:region], :region)
        region = Region.where("name = ?", region_name).first || Region.new(name: region_name)
      end

      # Add region if found
      city.region = region if region

      # At least add country if that exists.
      city.country = region.country if region && region.country
      city.country = Country.where("iso_alpha_2 = ?", country_iso_code).first if city.country.nil? && !country_iso_code.blank?
      
    rescue Exception => e
      puts "Error while parsing country and region - #{e.message}".red
    end

    city.alternative_names = self.clean_string(row_data[:alternative_names], :alternative_names)[0..255] if row_data[:alternative_names]
    city.population = self.clean_string(row_data[:population], :population) if row_data[:population]
    city.priority = 1000
    city.show_in_api = true if city.country && ["United Arab Emirates", "United States", "Saudi Arabia", "Jordan", "India"].include?(city.country.name)

    city.latitude = self.clean_string(row_data[:latitude], :latitude) if row_data[:latitude] && row_data[:latitude] != "NULL"
    city.longitude = self.clean_string(row_data[:longitude], :longitude) if row_data[:longitude] && row_data[:longitude] != "NULL"

    city.show_in_api = true if city.country && city.country.show_in_api

    unless city.valid?
      summary = "Error while saving city: #{city.name}"
      details = "Error! #{city.errors.full_messages.to_sentence}"
      error_object.errors << { summary: summary, details: details }
    end
    return city, error_object
  end

  # ------------------
  # Instance Methods
  # ------------------

  # Callback Methods
  # ------------------

  def set_country
    self.country = self.region.country if self.region && self.region.country
  end

  # Permission Methods
  # ------------------

  def can_be_edited?
    true
  end

  def can_be_deleted?
    return false if operational?
    true
  end

  # Other Methods
  # -------------

  # * Return full name
  # == Examples
  #   >>> city.display_name
  #   => "India"
  def display_name
    self.name
  end

  # * Return Yes or No
  # == Examples
  #   >>> city.display_show_in_api
  #   => "India"
  def display_show_in_api
    self.show_in_api ? "Yes" : "No"
  end

  # * Return Yes or No
  # == Examples
  #   >>> city.display_operational
  #   => "Yes"
  def display_operational
    self.operational ? "Yes" : "No"
  end
	
end