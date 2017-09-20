class CountryPreviewSerializer < ActiveModel::Serializer
  include NullAttributeReplacer
  attributes :id, :name, :iso_name, :dialing_prefix, :priority
end