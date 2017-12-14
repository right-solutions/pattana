FactoryBot.define do
  
  factory :city do

    name "Region Name"
    iso_code "RG-ISO-CODE"
    
    country
    region
    
    # Lattitude and Longitude
    latitude 12.00001
    longitude 45.00001

    population 100000

    priority 1000
    show_in_api false
    operational false
  end
  
end