require 'spec_helper'

describe Pattana::CountriesController, :type => :controller do

  let(:country) {FactoryBot.create(:country)}
  
  describe "index" do
    3.times { FactoryBot.create(:country) }
    context "Positive Case" do
      it "should be able to view the list of countries" do
        get :index, params: { use_route: 'pattana',}
        expect(response.status).to eq(200)
      end

      it "should be able to search a country" do
        get :index, params: { use_route: 'pattana', query: "India" }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "show" do
    context "Positive Case" do
      it "should be able to view single country details" do
        get :show, params: { use_route: 'pattana', id: country.id }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "regions" do
    context "Positive Case" do
      it "should be able to its regions" do
        get :regions, params: { use_route: 'pattana', id: country.id }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "cities" do
    context "Positive Case" do
      it "should be able to its cities" do
        get :cities, params: { use_route: 'pattana', id: country.id }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "show_in_api" do
    context "Positive Case" do
      it "should be mark show_in_api true" do
        country.update_attribute(:show_in_api, false)
        get :show_in_api, params: { use_route: 'pattana', id: country.id }, xhr: true
        country.reload
        expect(response.status).to eq(200)
        expect(country.show_in_api).to be_truthy
      end
    end
  end

  describe "hide_in_api" do
    context "Positive Case" do
      it "should be mark show_in_api true" do
        country.update_attribute(:show_in_api, true)
        get :hide_in_api, params: { use_route: 'pattana', id: country.id }, xhr: true
        country.reload
        expect(response.status).to eq(200)
        expect(country.show_in_api).to be_falsy
      end
    end
  end

  describe "mark_as_operational" do
    context "Positive Case" do
      it "should be mark operational true" do
        country.update_attribute(:operational, false)
        get :mark_as_operational, params: { use_route: 'pattana', id: country.id }, xhr: true
        country.reload
        expect(response.status).to eq(200)
        expect(country.operational).to be_truthy
      end
    end
  end

  describe "remove_operational" do
    context "Positive Case" do
      it "should be mark operational true" do
        country.update_attribute(:operational, true)
        get :remove_operational, params: { use_route: 'pattana', id: country.id }, xhr: true
        country.reload
        expect(response.status).to eq(200)
        expect(country.operational).to be_falsy
      end
    end
  end

  describe "new" do
    context "Positive Case" do
      it "should display the new form for site admin" do
        get :new, params: { use_route: 'pattana' }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "edit" do
    context "Positive Case" do
      it "should display the edit form for site admin" do
        get :edit, params: { use_route: 'pattana',}, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "create" do
    context "Positive Case" do
      it "site admin should be able to create a country" do
        country_params = FactoryBot.build(:country, name: "Some Name").attributes
        expect do
          post :create, params: { use_route: 'pattana', country: country_params }, xhr: true
        end.to change(Country, :count).by(1)
        expect(Country.last.name).to match("Some Name")
      end
    end
  end

  describe "update" do
    context "Positive Case" do
      it "site admin should be able to update a country" do
        country = FactoryBot.create(:country, name: "Some Name")
        country_params = country.attributes.clone
        country_params["name"] = "Changed Name"
        expect do
          put :update, params: { use_route: 'pattana', id: country.id, country: country_params }, xhr: true
        end.to change(Country, :count).by(0)
        expect(country.reload.name).to match("Changed Name")
      end
    end
  end

  describe "destroy" do
    context "Positive Case" do
      it "site admin should be able to remove a country" do
        country
        expect do
          delete :destroy, params: { use_route: 'pattana', id: country.id }, xhr: true
        end.to change(Country, :count).by(-1)
      end
    end
  end

end
