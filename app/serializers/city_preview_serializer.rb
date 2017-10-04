class CityPreviewSerializer < ActiveModel::Serializer
  include NullAttributeReplacer
  
  attributes :id, :name, :priority, :operational
  
  belongs_to :country, serializer: CountryPreviewSerializer
  belongs_to :region, serializer: RegionPreviewSerializer
end