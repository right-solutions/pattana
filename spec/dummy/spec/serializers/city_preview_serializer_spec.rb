require 'spec_helper'

RSpec.describe CityPreviewSerializer, type: :serializer do

  describe "attributes" do
    it "should show empty region if it doesn't exist" do
      india = FactoryGirl.create(:country, name: "India")
      kochi = FactoryGirl.create(:city, name: "Kochi", region: nil, country: india)
  
      json_data = ActiveModelSerializers::SerializableResource.new(kochi, serializer: CityPreviewSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(kochi.id)
      expect(data["name"]).to eq("Kochi")
      expect(data["priority"]).to eq(kochi.priority)
      expect(data["operational"]).to eq(kochi.operational)
      
      expect(data["country"]["id"]).to eq(india.id)
      expect(data["country"]["name"]).to eq("India")
      expect(data["country"]["iso_name"]).to eq(india.iso_name)
      expect(data["country"]["iso_alpha_2"]).to eq(india.iso_alpha_2)
      expect(data["country"]["dialing_prefix"]).to eq(india.dialing_prefix)
      expect(data["country"]["priority"]).to eq(india.priority)
      expect(data["country"]["operational"]).to eq(india.operational)

      expect(data["region"]["id"]).to be_blank
      expect(data["region"]["name"]).to be_blank
      expect(data["region"]["priority"]).not_to be_blank
      expect(data["region"]["operational"]).to be_falsy      
    end

    it "should include preview attributes" do
      india = FactoryGirl.create(:country, name: "India")
      kerala = FactoryGirl.create(:region, name: "Kerala", country: india)
      kochi = FactoryGirl.create(:city, name: "Kochi", region: kerala)
  
      json_data = ActiveModelSerializers::SerializableResource.new(kochi, serializer: CityPreviewSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(kochi.id)
      expect(data["name"]).to eq("Kochi")
      expect(data["priority"]).to eq(kochi.priority)
      expect(data["operational"]).to eq(kochi.operational)
      
      expect(data["country"]["id"]).to eq(india.id)
      expect(data["country"]["name"]).to eq("India")
      expect(data["country"]["iso_name"]).to eq(india.iso_name)
      expect(data["country"]["iso_alpha_2"]).to eq(india.iso_alpha_2)
      expect(data["country"]["dialing_prefix"]).to eq(india.dialing_prefix)
      expect(data["country"]["priority"]).to eq(india.priority)
      expect(data["country"]["operational"]).to eq(india.operational)

      expect(data["region"]["id"]).to eq(kerala.id)
      expect(data["region"]["name"]).to eq("Kerala")
      expect(data["region"]["priority"]).not_to be_blank
      expect(data["region"]["operational"]).to be_falsy
    end
  end
  
  
end