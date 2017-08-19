class Region < Pattana::ApplicationRecord
  
  # Associations
  belongs_to :country
  has_many :cities
  
	# Validations
	validates :name, presence: true, length: {minimum: 2, maximum: 128}
	
  # ------------------
  # Class Methods
  # ------------------

  # Scopes Methods

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> region.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| joins("INNER JOIN countries co on co.id = regions.country_id").where("LOWER(regions.name) LIKE LOWER('%#{query}%') || LOWER(regions.iso_code) LIKE LOWER('%#{query}%') || LOWER(co.name) LIKE LOWER('%#{query}%')")}

  scope :show_in_api, -> { where(show_in_api: true) }

  # Import Methods

  def self.save_row_data(hsh)

    return if hsh[:name].blank?

    iso_code = self.clean_string(hsh[:iso_code])
    region = Region.where("iso_code = ?", iso_code).first || Region.new(iso_code: iso_code)
    region.name = self.clean_string(hsh[:name]) if hsh[:name]
    
    begin
      country = nil
      country_iso_alpha_2 = region.iso_code.split("-").first.strip
      country = Country.where("iso_alpha_2 = ?", country_iso_alpha_2).first if country_iso_alpha_2
      region.country = country if country
    rescue Exception => e
      puts "Error while parsing iso code for country - #{e.message}".red
    end

    region.latitude = self.clean_string(hsh[:latitude]) if hsh[:latitude] && hsh[:latitude] != "NULL"
    region.longitude = self.clean_string(hsh[:longitude]) if hsh[:longitude] && hsh[:longitude] != "NULL"

    region.show_in_api = true if region.country && region.country.show_in_api
    
    # Initializing error hash for displaying all errors altogether
    error_object = Kuppayam::Importer::ErrorHash.new

    if region.valid?
      begin
        region.save!
      rescue Exception => e
        summary = "uncaught #{e} exception while handling connection: #{e.message}"
        details = "Stack trace: #{e.backtrace.map {|l| "  #{l}\n"}.join}"
        error_object.errors << { summary: summary, details: details }        
      end
    else
      summary = "Error while saving region: #{region.name}"
      details = "Error! #{region.errors.full_messages.to_sentence}"
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
    false
  end

  def can_be_deleted?
    false
  end

  # Other Methods
  # -------------

  # * Return full name
  # == Examples
  #   >>> region.display_name
  #   => "India"
  def display_name
    self.name
  end

  # * Return Yes or No
  # == Examples
  #   >>> region.display_show_in_api
  #   => "India"
  def display_show_in_api
    self.show_in_api ? "Yes" : "No"
  end
	
end