class CountryPreviewSerializer < ActiveModel::Serializer
  attributes :id, :name, :iso_name, :dialing_prefix, :priority
end