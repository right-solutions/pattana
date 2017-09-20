require 'spec_helper'

RSpec.describe RegionPreviewSerializer, type: :serializer do

  describe "attributes" do
    it "should include preview attributes" do
      india = FactoryGirl.create(:country, name: "India")
      kerala = FactoryGirl.create(:region, name: "Kerala", country: india)
      
      json_data = ActiveModelSerializers::SerializableResource.new(kerala, serializer: RegionPreviewSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(kerala.id)
      expect(data["name"]).to eq("Kerala")
      expect(data["priority"]).to eq(kerala.priority)
      
      expect(data["country"]["id"]).to eq(india.id)
      expect(data["country"]["name"]).to eq("India")
      expect(data["country"]["iso_name"]).to eq(india.iso_name)
      expect(data["country"]["dialing_prefix"]).to eq(india.dialing_prefix)
      expect(data["country"]["priority"]).to eq(india.priority)
    end
  end
  
  
end