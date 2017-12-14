require 'spec_helper'

RSpec.describe CountryPreviewSerializer, type: :serializer do

  describe "attributes" do
    it "should include preview attributes" do
      india = FactoryBot.create(:country, name: "India")
      
      json_data = ActiveModelSerializers::SerializableResource.new(india, serializer: CountryPreviewSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(india.id)
      expect(data["name"]).to eq("India")
      expect(data["iso_name"]).to eq(india.iso_name)
      expect(data["dialing_prefix"]).to eq(india.dialing_prefix)
      expect(data["priority"]).to eq(1000)
    end
  end
  
  
end