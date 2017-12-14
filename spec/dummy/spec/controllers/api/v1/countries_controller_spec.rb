require "spec_helper"

RSpec.describe Pattana::Api::V1::CountriesController, :type => :request do  

  describe "countries" do
    context "Positive Case" do
      it "should return all the countries" do
        FactoryBot.create(:country, name: "India", show_in_api: true)
        FactoryBot.create(:country, name: "Pakistan", show_in_api: true)
        FactoryBot.create(:country, name: "Bangladesh", show_in_api: true)
        FactoryBot.create(:country, name: "United States")

        get "/api/v1/countries"
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)

        data = response_body['data']

        expect(data.map{|x| x["name"]}).to match_array(["India", "Pakistan", "Bangladesh"])
      end
      it "should search countries" do
        FactoryBot.create(:country, name: "Mango Tree", show_in_api: true)
        FactoryBot.create(:country, name: "Jack Tree", show_in_api: false)
        FactoryBot.create(:country, name: "Banyan Tree", show_in_api: true)
        FactoryBot.create(:country, name: "Mango Flower", show_in_api: true)

        get "/api/v1/countries?q=tree"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Mango Tree", "Banyan Tree"])

        get "/api/v1/countries?q=mango"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Mango Tree", "Mango Flower"])
      end

      it "should filter operational countries" do
        FactoryBot.create(:country, name: "Mango Tree", show_in_api: true, operational: true)
        FactoryBot.create(:country, name: "Jack Tree", show_in_api: false, operational: true)
        FactoryBot.create(:country, name: "Banyan Tree", show_in_api: true, operational: false)
        FactoryBot.create(:country, name: "Mango Flower", show_in_api: true, operational: false)

        get "/api/v1/countries?operational=true"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Mango Tree"])
      end
    end
  end

end