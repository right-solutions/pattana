require "spec_helper"

RSpec.describe Pattana::Api::V1::RegionsController, :type => :request do  

  describe "countries" do
    context "Positive Case" do
      it "should return all the regions in a country" do
        india = FactoryGirl.create(:country, name: "India", show_in_api: true)
        uae = FactoryGirl.create(:country, name: "United Arab Emirates", show_in_api: true)
        FactoryGirl.create(:region, name: "Kerala", show_in_api: true, country: india)
        FactoryGirl.create(:region, name: "Tamil Nadu", show_in_api: true, country: india)
        FactoryGirl.create(:region, name: "Pondicheri", show_in_api: false, country: india)
        FactoryGirl.create(:region, name: "Dubai", show_in_api: true, country: uae)
        FactoryGirl.create(:region, name: "Sharjah", show_in_api: true, country: uae)

        # Get Regions in India
        get "/api/v1/#{india.id}/regions"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Kerala", "Tamil Nadu"])

        # Get Regions of U.A.E
        get "/api/v1/#{uae.id}/regions"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Dubai", "Sharjah"])
      end
      it "should search regions" do
        india = FactoryGirl.create(:country, name: "India", show_in_api: true)
        bangladesh = FactoryGirl.create(:country, name: "bangladesh", show_in_api: true)
        FactoryGirl.create(:region, name: "Madhya Pradesh", show_in_api: true, country: india)
        FactoryGirl.create(:region, name: "Uthar Pradesh", show_in_api: true, country: india)
        FactoryGirl.create(:region, name: "Kerala Pradesh", show_in_api: false, country: india)
        FactoryGirl.create(:region, name: "Bangla Pradesh", show_in_api: true, country: bangladesh)
        
        # Get Regions
        get "/api/v1/#{india.id}/regions?q=pradesh"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Madhya Pradesh", "Uthar Pradesh"])
      end
      it "should filter operational regions" do
        india = FactoryGirl.create(:country, name: "India", show_in_api: true)
        
        FactoryGirl.create(:region, name: "Madhya Pradesh", show_in_api: false, country: india, operational: true)
        FactoryGirl.create(:region, name: "Uthar Pradesh", show_in_api: true, country: india, operational: false)
        FactoryGirl.create(:region, name: "Kerala Pradesh", show_in_api: true, country: india, operational: true)
        FactoryGirl.create(:region, name: "West Bengal", show_in_api: false, country: india, operational: false)
        
        # Get Regions
        get "/api/v1/#{india.id}/regions?operational=true"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Kerala Pradesh"])
      end
    end
    context 'Negative Cases' do
      it "should show errors if a valid country id is not passed" do
        india = FactoryGirl.create(:country, name: "India", show_in_api: true)
        uae = FactoryGirl.create(:country, name: "United Arab Emirates", show_in_api: true)
        FactoryGirl.create(:region, name: "Kerala", show_in_api: true, country: india)
        FactoryGirl.create(:region, name: "Tamil Nadu", show_in_api: true, country: india)
        FactoryGirl.create(:region, name: "Dubai", show_in_api: true, country: uae)
        FactoryGirl.create(:region, name: "Sharjah", show_in_api: true, country: uae)

        # Get Regions in India
        get "/api/v1/1234/regions"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        expect(response_body["errors"]["heading"]).to eq("Invalid Country ID")
        expect(response_body["errors"]["message"]).to eq("Pass a vaild Country ID to get the regions. Get Countries List along with their IDs from Countries API")
      end
    end
  end

end