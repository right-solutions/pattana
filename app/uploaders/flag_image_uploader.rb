class FlagImageUploader < ImageUploader
	
  def store_dir
    "uploads/flag_images/#{model.id}"
  end

  version :large do
    process :resize_to_fill => [550, 275]
  end

	version :medium do
    process :resize_to_fill => [250, 125]
  end

  version :small do
    process :resize_to_fill => [100, 50]
  end

  version :tiny do
    process :resize_to_fill => [40, 20]
  end
  
end
