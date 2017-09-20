require 'spec_helper'

RSpec.describe CityPreviewSerializer, type: :serializer do

  describe "attributes" do
    it "should include preview attributes" do
      india = FactoryGirl.create(:country, name: "India")
      kerala = FactoryGirl.create(:region, name: "Kerala", country: india)
      kochi = FactoryGirl.create(:city, name: "Kochi", region: kerala)
  
      json_data = ActiveModelSerializers::SerializableResource.new(kochi, serializer: CityPreviewSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(kochi.id)
      expect(data["name"]).to eq("Kochi")
      expect(data["priority"]).to eq(kochi.priority)
      
      expect(data["country"]["id"]).to eq(india.id)
      expect(data["country"]["name"]).to eq("India")
      expect(data["country"]["iso_name"]).to eq(india.iso_name)
      expect(data["country"]["dialing_prefix"]).to eq(india.dialing_prefix)
      expect(data["country"]["priority"]).to eq(india.priority)

      expect(data["region"]["id"]).to eq(kerala.id)
      expect(data["region"]["name"]).to eq("Kerala")
      expect(data["country"]["priority"]).to eq(india.priority)
    end
  end
  
  
end