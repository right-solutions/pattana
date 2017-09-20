class RegionPreviewSerializer < ActiveModel::Serializer
  include NullAttributeReplacer
  attributes :id, :name, :priority
  
  belongs_to :country, serializer: CountryPreviewSerializer
end