FactoryGirl.define do
  
  factory :country do

    name "Country Name"
    official_name "Official Name"
    iso_name "OF"
    
    # Federal Information Processing Standard
    fips "FIPS"

    iso_alpha_2 "OF"
    iso_alpha_3 "OFN"

    # Codes assigned by the International Telecommunications Union
    itu_code "XYZ"
    
    # International Dialing Prefix
    dialing_prefix "999"

    # Top Level Domain
    tld ".world"

    # Lattitude and Longitude
    latitude 12.00001
    longitude 45.00001

    # Other Details
    capital "Capital"
    continent "Asia"
    currency_code "ABC"
    currency_name "AB Currency"
    is_independent true
    languages "Chakka, Manga, Thenga"

    priority 1000
    show_in_api false
  end

  
end