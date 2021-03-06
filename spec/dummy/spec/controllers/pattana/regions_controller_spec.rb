require 'spec_helper'

describe Pattana::RegionsController, :type => :controller do

  let(:region) {FactoryBot.create(:region)}
  
  describe "index" do
    3.times { FactoryBot.create(:region) }
    context "Positive Case" do
      it "should be able to view the list of regions" do
        get :index, params: { use_route: 'pattana',}
        expect(response.status).to eq(200)
      end

      it "should be able to search a region" do
        get :index, params: { use_route: 'pattana', query: "Kerala" }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "show" do
    context "Positive Case" do
      it "should be able to view single region details" do
        get :show, params: { use_route: 'pattana', id: region.id }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "cities" do
    context "Positive Case" do
      it "should be able to its cities" do
        get :cities, params: { use_route: 'pattana', id: region.id }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "show_in_api" do
    context "Positive Case" do
      it "should be mark show_in_api true" do
        region.update_attribute(:show_in_api, false)
        get :show_in_api, params: { use_route: 'pattana', id: region.id }, xhr: true
        region.reload
        expect(response.status).to eq(200)
        expect(region.show_in_api).to be_truthy
      end
    end
  end

  describe "hide_in_api" do
    context "Positive Case" do
      it "should be mark show_in_api true" do
        region.update_attribute(:show_in_api, true)
        get :hide_in_api, params: { use_route: 'pattana', id: region.id }, xhr: true
        region.reload
        expect(response.status).to eq(200)
        expect(region.show_in_api).to be_falsy
      end
    end
  end

  describe "mark_as_operational" do
    context "Positive Case" do
      it "should be mark operational true" do
        region.update_attribute(:operational, false)
        get :mark_as_operational, params: { use_route: 'pattana', id: region.id }, xhr: true
        region.reload
        expect(response.status).to eq(200)
        expect(region.operational).to be_truthy
      end
    end
  end

  describe "remove_operational" do
    context "Positive Case" do
      it "should be mark operational true" do
        region.update_attribute(:operational, true)
        get :remove_operational, params: { use_route: 'pattana', id: region.id }, xhr: true
        region.reload
        expect(response.status).to eq(200)
        expect(region.operational).to be_falsy
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
        region_params = FactoryBot.build(:region, name: "Some Name").attributes
        expect do
          post :create, params: { use_route: 'pattana', region: region_params }, xhr: true
        end.to change(Region, :count).by(1)
        expect(Region.last.name).to match("Some Name")
      end
    end
  end

  describe "update" do
    context "Positive Case" do
      it "site admin should be able to update a region" do
        region = FactoryBot.create(:region, name: "Some Name")
        region_params = region.attributes.clone
        region_params["name"] = "Changed Name"
        expect do
          put :update, params: { use_route: 'pattana', id: region.id, region: region_params }, xhr: true
        end.to change(Region, :count).by(0)
        expect(region.reload.name).to match("Changed Name")
      end
    end
  end

  describe "destroy" do
    context "Positive Case" do
      it "site admin should be able to remove a region" do
        region
        expect do
          delete :destroy, params: { use_route: 'pattana', id: region.id }, xhr: true
        end.to change(Region, :count).by(-1)
      end
    end
  end

end
