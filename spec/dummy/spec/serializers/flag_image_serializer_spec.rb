require 'spec_helper'

RSpec.describe FlagImageSerializer, type: :serializer do
  describe "attributes" do
    it "should include image attributes" do
      flag_image = FactoryBot.create(:flag_image)
      
      json_data = ActiveModelSerializers::SerializableResource.new(flag_image, serializer: FlagImageSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(flag_image.id)
      expect(data["created_at"]).to eq(flag_image.created_at.strftime('%d-%m-%Y %H:%M:%S'))
      expect(data["image_large_path"]).not_to be_blank
      expect(data["image_medium_path"]).not_to be_blank
      expect(data["image_small_path"]).not_to be_blank
      expect(data["image_tiny_path"]).not_to be_blank
    end
  end
end