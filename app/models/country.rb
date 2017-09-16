class Country < Pattana::ApplicationRecord
  
  # Constants
  EXCLUDED_JSON_ATTRIBUTES = [:created_at, :updated_at, :show_in_api]

  # Associations
  has_many :regions
  has_many :cities

	# Validations
	validates :name, presence: true, length: {minimum: 3, maximum: 128}
	
  # ------------------
  # Class Methods
  # ------------------

  # Exclude some attributes info from json output.
  def as_json(options={})
    options[:except] ||= EXCLUDED_JSON_ATTRIBUTES
    #options[:include] ||= []
    #options[:methods] = []
    #options[:methods] << :profile_image
    json = super(options)
    Hash[*json.map{|k, v| [k, v || ""]}.flatten]
  end

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

  scope :show_in_api, -> { where(show_in_api: true) }

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