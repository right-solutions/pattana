require 'spec_helper'

describe Pattana::Api::V1::DocsController, :type => :controller do

  describe "should load all doc pages" do
    it "countries" do
      get :countries, params: { use_route: 'pattana' }
      expect(response.status).to eq(200)
    end

    it "regions" do
      get :regions, params: { use_route: 'pattana' }
      expect(response.status).to eq(200)
    end

    it "cities_in_a_country" do
      get :cities_in_a_country, params: { use_route: 'pattana' }
      expect(response.status).to eq(200)
    end

    it "cities_in_a_region" do
      get :cities_in_a_region, params: { use_route: 'pattana' }
      expect(response.status).to eq(200)
    end
  end

end
