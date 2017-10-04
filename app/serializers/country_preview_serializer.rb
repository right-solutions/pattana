class CountryPreviewSerializer < ActiveModel::Serializer
  include NullAttributeReplacer
  attributes :id, :name, :iso_name, :iso_alpha_2, :dialing_prefix, :priority, :operational
end