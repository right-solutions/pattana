class FlagImageSerializer < ActiveModel::Serializer
  include NullAttributeReplacer
  
  attributes :id, :created_at
  attributes :image_large_path, :image_medium_path, :image_small_path, :image_tiny_path
  	
  def image_large_path
    object.image_url :large
  end

  def image_medium_path
    object.image_url :medium
  end

  def image_small_path
    object.image_url :small
  end

  def image_tiny_path
    object.image_url :tiny
  end
  
end