class CountryPreviewSerializer < ActiveModel::Serializer
  include NullAttributeReplacer
  attributes :id, :name, :iso_name, :iso_alpha_2, :dialing_prefix, :priority, :operational

  has_one :flag_image, class_name: "Image::FlagImage", serializer: FlagImageSerializer do
    if object.flag_image
      object.flag_image
    else
      object.build_flag_image
    end
  end
end