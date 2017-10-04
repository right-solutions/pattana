class RegionPreviewSerializer < ActiveModel::Serializer
  include NullAttributeReplacer
  attributes :id, :name, :priority, :operational
  
  belongs_to :country, serializer: CountryPreviewSerializer
end