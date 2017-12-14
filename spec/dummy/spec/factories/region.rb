FactoryBot.define do
  
  factory :region do

    name "Region Name"
    iso_code "RG-ISO-CODE"
    
    country
    
    # Lattitude and Longitude
    latitude 12.00001
    longitude 45.00001

    priority 1000
    show_in_api false
    operational false
  end

  
end