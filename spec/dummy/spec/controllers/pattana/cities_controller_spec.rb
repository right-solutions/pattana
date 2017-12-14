require 'spec_helper'

describe Pattana::CitiesController, :type => :controller do

  let(:city) {FactoryBot.create(:city)}
  
  describe "index" do
    3.times { FactoryBot.create(:city) }
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

  describe "show_in_api" do
    context "Positive Case" do
      it "should be mark show_in_api true" do
        city.update_attribute(:show_in_api, false)
        get :show_in_api, params: { use_route: 'pattana', id: city.id }, xhr: true
        city.reload
        expect(response.status).to eq(200)
        expect(city.show_in_api).to be_truthy
      end
    end
  end

  describe "hide_in_api" do
    context "Positive Case" do
      it "should be mark show_in_api true" do
        city.update_attribute(:show_in_api, true)
        get :hide_in_api, params: { use_route: 'pattana', id: city.id }, xhr: true
        city.reload
        expect(response.status).to eq(200)
        expect(city.show_in_api).to be_falsy
      end
    end
  end

  describe "mark_as_operational" do
    context "Positive Case" do
      it "should be mark operational true" do
        city.update_attribute(:operational, false)
        get :mark_as_operational, params: { use_route: 'pattana', id: city.id }, xhr: true
        city.reload
        expect(response.status).to eq(200)
        expect(city.operational).to be_truthy
      end
    end
  end

  describe "remove_operational" do
    context "Positive Case" do
      it "should be mark operational true" do
        city.update_attribute(:operational, true)
        get :remove_operational, params: { use_route: 'pattana', id: city.id }, xhr: true
        city.reload
        expect(response.status).to eq(200)
        expect(city.operational).to be_falsy
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
      it "site admin should be able to create a region" do
        city_params = FactoryBot.build(:city, name: "Some Name").attributes
        expect do
          post :create, params: { use_route: 'pattana', city: city_params }, xhr: true
        end.to change(City, :count).by(1)
        expect(City.last.name).to match("Some Name")
      end
    end
  end

  describe "update" do
    context "Positive Case" do
      it "site admin should be able to update a city" do
        city = FactoryBot.create(:city, name: "Some Name")
        city_params = city.attributes.clone
        city_params["name"] = "Changed Name"
        expect do
          put :update, params: { use_route: 'pattana', id: city.id, city: city_params }, xhr: true
        end.to change(City, :count).by(0)
        expect(city.reload.name).to match("Changed Name")
      end
    end
  end

  describe "destroy" do
    context "Positive Case" do
      it "site admin should be able to remove a city" do
        city
        expect do
          delete :destroy, params: { use_route: 'pattana', id: city.id }, xhr: true
        end.to change(City, :count).by(-1)
      end
    end
  end



end
