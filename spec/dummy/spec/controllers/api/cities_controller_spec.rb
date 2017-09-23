require "spec_helper"

RSpec.describe Pattana::Api::V1::CitiesController, :type => :request do  

  describe "cities" do
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
        get "/api/v1/countries/#{india.id}/cities"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Calicut", "Cochin", "Mysore"])

        # Get Cities in Kerala
        get "/api/v1/regions/#{kerala.id}/cities"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Calicut", "Cochin"])

        uae = FactoryGirl.create(:country, name: "United Arab Emirates", show_in_api: true)
        abu_dhabhi = FactoryGirl.create(:region, name: "Abu Dhabi", show_in_api: true, country: uae)
        dubai = FactoryGirl.create(:region, name: "Dubai", show_in_api: true, country: uae)

        FactoryGirl.create(:city, name: "Dubai", show_in_api: true, region: dubai)
        FactoryGirl.create(:city, name: "Abu Dhabhi", show_in_api: true, region: dubai)
        FactoryGirl.create(:city, name: "Al Ain", show_in_api: false, region: dubai)

        # Get Cities of U.A.E
        get "/api/v1/countries/#{uae.id}/cities"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Dubai", "Abu Dhabhi"])
      end
      it "should return search for a city" do
        india = FactoryGirl.create(:country, name: "India", show_in_api: true)
        kerala = FactoryGirl.create(:region, name: "Kerala", show_in_api: true, country: india)
        karnataka = FactoryGirl.create(:region, name: "Karnataka", show_in_api: true, country: india)

        FactoryGirl.create(:city, name: "Kozhikode", show_in_api: true, region: kerala, country: india)
        FactoryGirl.create(:city, name: "Areekode", show_in_api: true, region: kerala, country: india)
        FactoryGirl.create(:city, name: "Some kode in karnataka", show_in_api: true, region: karnataka, country: india)
        FactoryGirl.create(:city, name: "Thiruvananthapuram", show_in_api: true, region: kerala, country: india)
        FactoryGirl.create(:city, name: "Mangalapuram", show_in_api: true, region: karnataka, country: india)

        # Get Cities in India
        get "/api/v1/countries/#{india.id}/cities?q=kode"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Kozhikode", "Areekode", "Some kode in karnataka"])

        get "/api/v1/countries/#{india.id}/cities?q=puram"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Thiruvananthapuram", "Mangalapuram"])

        # Get Cities in Kerala
        get "/api/v1/regions/#{kerala.id}/cities?q=kode"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Kozhikode", "Areekode"])

        # Get Cities in Karnataka
        get "/api/v1/regions/#{karnataka.id}/cities?q=kode"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(true)
        data = response_body['data']
        expect(data.map{|x| x["name"]}).to match_array(["Some kode in karnataka"])
      end
    end
    context 'Negative Cases' do
      it "should show errors if a valid country id is not passed" do
        get "/api/v1/countries/1234/cities"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        expect(response_body["errors"]["heading"]).to eq("Invalid Country ID")
        expect(response_body["errors"]["message"]).to eq("Pass a vaild Country ID to get the regions. Get Countries List along with their IDs from Countries API")
      end

      it "should show errors if a valid region id is not passed" do
        india = FactoryGirl.create(:country, name: "India", show_in_api: true)
        get "/api/v1/regions/1234/cities"
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        expect(response_body["errors"]["heading"]).to eq("Invalid Region ID")
        expect(response_body["errors"]["message"]).to eq("Pass a vaild Region ID to get the regions. Get Regions List along with their IDs from Regions API")
      end
    end
  end

end