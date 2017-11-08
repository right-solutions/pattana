class CityPreviewSerializer < ActiveModel::Serializer
  include NullAttributeReplacer
  
  attributes :id, :name, :priority, :operational
  
  has_one :country, serializer: CountryPreviewSerializer do
  	if object.country
      object.country
    else
      object.build_country
    end
  end

  has_one :region, serializer: RegionPreviewSerializer do
  	if object.region
      object.region
    else
      object.build_region
    end
  end
end