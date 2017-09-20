class RegionPreviewSerializer < ActiveModel::Serializer
  attributes :id, :name, :priority
  
  belongs_to :country, serializer: CountryPreviewSerializer
end