require "spec_helper"

RSpec.describe Pattana::Api::V1::CitiesController, :type => :request do  

  describe "countries" do
    context "Positive Case" do
      it "should return all the cities in a country / region" do
        india = FactoryGirl.create(:country, name: "India", show_in_api: true)
        kerala = FactoryGirl.create(:region, name: "Kerala", show_in_api: true, country: india)
        karnataka = FactoryGirl.create(:region, name: "Karnataka", show_in_api: false, country: india)

        FactoryGirl.create(:city, name: "Calicut", show_in_api: true, region: kerala, country: india)
        FactoryGirl.create(:city, name: "Cochin", show_in_api: true, region: kerala, country: india)
        FactoryGirl.create(:city, name: "Kottakkal", show_in_api: false, region: kerala, country: india)
        FactoryGirl.create(:city, name: "Mysore", show_in_api: true, region: karnataka, country: india)

        # Get Cities in India
        get "/api/v1/#{india.id}/cities"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Calicut", "Cochin", "Mysore"])

        # Get Cities in Kerala
        get "/api/v1/#{india.id}/#{kerala.id}/cities"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Calicut", "Cochin"])

        uae = FactoryGirl.create(:country, name: "United Arab Emirates", show_in_api: true)
        abu_dhabhi = FactoryGirl.create(:region, name: "Abu Dhabi", show_in_api: true, country: uae)
        dubai = FactoryGirl.create(:region, name: "Dubai", show_in_api: true, country: uae)
        
        FactoryGirl.create(:city, name: "Dubai", show_in_api: true, country: uae)
        FactoryGirl.create(:city, name: "Abu Dhabhi", show_in_api: true, country: uae)
        FactoryGirl.create(:city, name: "Al Ain", show_in_api: false, country: uae)

        # Get Cities of U.A.E
        get "/api/v1/#{uae.id}/cities"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Dubai", "Abu Dhabhi"])
      end
    end
    context 'Negative Cases' do
      it "should show errors if a valid country id is not passed" do
        get "/api/v1/1234/cities"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        expect(response_body["errors"]["heading"]).to eq("Invalid Country ID")
        expect(response_body["errors"]["message"]).to eq("Pass a vaild Country ID to get the regions. Get Countries List along with their IDs from Countries API")
      end

      it "should show errors if a valid region id is not passed" do
        india = FactoryGirl.create(:country, name: "India", show_in_api: true)
        get "/api/v1/#{india.id}/1234/cities"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        expect(response_body["errors"]["heading"]).to eq("Invalid Region ID")
        expect(response_body["errors"]["message"]).to eq("Pass a vaild Region ID to get the regions. Get Regions List along with their IDs from Regions API")
      end

      it "should show errors if a the region id doesn't belongs to the country id passed" do
        india = FactoryGirl.create(:country, name: "India", show_in_api: true)
        kerala = FactoryGirl.create(:region, name: "Kerala", show_in_api: true, country: india)
        
        FactoryGirl.create(:city, name: "Calicut", show_in_api: true, region: kerala, country: india)
        FactoryGirl.create(:city, name: "Cochin", show_in_api: true, region: kerala, country: india)
        FactoryGirl.create(:city, name: "Kottakkal", show_in_api: false, region: kerala, country: india)
        
        uae = FactoryGirl.create(:country, name: "United Arab Emirates", show_in_api: true)
        
        get "/api/v1/#{uae.id}/#{kerala.id}/cities"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        expect(response_body["errors"]["heading"]).to eq("Region ID and the Country ID doesn't match")
        expect(response_body["errors"]["message"]).to eq("Make sure that you pass the region id which belongs the right country id. This error is likely to be encountered when the region id belongs to a different country id than the one you have passed")
      end
    end
  end

end