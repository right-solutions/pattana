require "spec_helper"

RSpec.describe Pattana::Api::V1::CountriesController, :type => :request do  

  describe "countries" do
    context "Positive Case" do
      it "should return all the countries" do
        FactoryGirl.create(:country, name: "India", show_in_api: true)
        FactoryGirl.create(:country, name: "Pakistan", show_in_api: true)
        FactoryGirl.create(:country, name: "Bangladesh", show_in_api: true)
        FactoryGirl.create(:country, name: "United States")

        get "/api/v1/countries"
      
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)

        data = response_body['data']

        expect(data.map{|x| x["name"]}).to match_array(["India", "Pakistan", "Bangladesh"])
      end
    end
  end

end