require 'spec_helper'

describe Pattana::CountriesController, :type => :controller do

  let(:city) {FactoryGirl.create(:city)}
  
  describe "index" do
    3.times { FactoryGirl.create(:city) }
    context "Positive Case" do
      it "should be able to view the list of countries" do
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(200)
      end

      it "should be able to search a city" do
        get :index, params: { use_route: 'usman', query: "India" }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "show" do
    context "Positive Case" do
      it "should be able to view single city details" do
        get :show, params: { use_route: 'usman', id: city.id }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

end
