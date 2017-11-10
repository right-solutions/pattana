class Image::FlagImage < Image::Base

	mount_uploader :image, FlagImageUploader

	# Configuration
  # -------------
  def self.image_configuration
    {
      max_upload_limit: 1048576,
      min_upload_limit: 1,
      resolutions: [550, 275],
      form_upload_image_label: "Upload a new Image",
      form_title: "Upload an Image (Flag)",
      form_sub_title: "Please read the instructions below:",
      form_instructions: [
        "the filename should be in .jpg / .jpeg or .png format",
        "the image resolutions should be <strong>550 x 275 Pixels</strong>",
        "the file size should be greater than 100 Kb and or lesser than <strong>10 MB</strong>"
      ]
    }
  end
end
